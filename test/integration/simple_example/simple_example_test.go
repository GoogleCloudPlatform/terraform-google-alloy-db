// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package primary_instance_adb_cluster

import (
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestSimpleExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// Getting the expected Project ID from the outputs
		projectId := example.GetStringOutput("project_id")
		kmsKeyName := example.GetStringOutput("kms_key_name")
		secondarykmsKeyName := example.GetStringOutput("secondary_kms_key_name")
		region := example.GetStringOutput("region")
		secondaryRegion := example.GetStringOutput("secondary_region")

		// Cluster Information
		alloydbClusterIdPath := example.GetStringOutput("cluster_id")
		alloydbClusterIdPathList := strings.Split(example.GetStringOutput("cluster_id"), "/")
		alloydbClusterId := alloydbClusterIdPathList[len(alloydbClusterIdPathList)-1]

		// Primary Instance Information
		alloydbPrimaryInstancePath := example.GetStringOutput("primary_instance_id")

		cluster_location := region
		state := "READY"
		gcOpsClusterInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--format", "json"})
		gcOpsPrimaryInstanceInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--cluster", alloydbClusterId, "--format", "json"})

		alloyDBClusterInfo := gcloud.Run(t, "alloydb clusters describe "+alloydbClusterId, gcOpsClusterInfo)
		alloyDBInstanceInfo := gcloud.Run(t, "alloydb instances list ", gcOpsPrimaryInstanceInfo).Array()[0]

		// Secondary Cluster Information
		secondaryAlloydbClusterIdPath := example.GetStringOutput("secondary_cluster_id")
		secondaryAlloydbClusterIdPathList := strings.Split(example.GetStringOutput("secondary_cluster_id"), "/")
		secondaryAlloydbClusterId := secondaryAlloydbClusterIdPathList[len(secondaryAlloydbClusterIdPathList)-1]

		// Secondary Primary Instance Information
		secondaryAlloydbPrimaryInstancePath := example.GetStringOutput("secondary_primary_instance_id")

		secondary_cluster_location := secondaryRegion
		secondaryGcOpsClusterInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", secondary_cluster_location, "--format", "json"})
		secondaryGcOpsPrimaryInstanceInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", secondary_cluster_location, "--cluster", secondaryAlloydbClusterId, "--format", "json"})

		secondaryAlloyDBClusterInfo := gcloud.Run(t, "alloydb clusters describe "+secondaryAlloydbClusterId, secondaryGcOpsClusterInfo)
		SecondaryAlloyDBInstanceInfo := gcloud.Run(t, "alloydb instances list ", secondaryGcOpsPrimaryInstanceInfo).Array()[0]

		// check for Cluster
		assert.Equal(alloydbClusterIdPath, alloyDBClusterInfo.Get("name").String(), "Has to be same Cluster path")
		assert.True(alloyDBClusterInfo.Get("continuousBackupConfig.enabled").Bool(), "continuous Backup.enabled is set to True")
		assert.Equal("10", alloyDBClusterInfo.Get("continuousBackupConfig.recoveryWindowDays").String(), "continuousBackupConfig.recoveryWindowDays has expected value 10")
		assert.Equal(kmsKeyName, alloyDBClusterInfo.Get("continuousBackupConfig.encryptionConfig.kmsKeyName").String(), "continuous Backup Encryption key name match")
		assert.Equal(kmsKeyName, alloyDBClusterInfo.Get("encryptionConfig.kmsKeyName").String(), "Cluster Encryption key name match")
		assert.Equal(region, alloyDBClusterInfo.Get("automatedBackupPolicy.location").String(), "Cluster backup region match")
		assert.Equal(kmsKeyName, alloyDBClusterInfo.Get("automatedBackupPolicy.encryptionConfig.kmsKeyName").String(), "Cluster automatic backup Encryption key name match")
		assert.Equal("PRIMARY", alloyDBClusterInfo.Get("clusterType").String(), "Cluster type match")

		// Check for Primary Instance
		assert.Equal(alloydbPrimaryInstancePath, alloyDBInstanceInfo.Get("name").String(), "Has to be same Primary Instance Path")
		assert.Equal(state, alloyDBInstanceInfo.Get("state").String())

		// check for Secondary Cluster
		assert.Equal(secondaryAlloydbClusterIdPath, secondaryAlloyDBClusterInfo.Get("name").String(), "Has to be same secondary Cluster path")
		assert.False(secondaryAlloyDBClusterInfo.Get("continuousBackupConfig.enabled").Bool(), "continuous Backup.enabled is set to False")
		assert.Equal(secondarykmsKeyName, secondaryAlloyDBClusterInfo.Get("encryptionConfig.kmsKeyName").String(), "Cluster Encryption key name match for secondary cluster")
		assert.Equal("SECONDARY", secondaryAlloyDBClusterInfo.Get("clusterType").String(), "Cluster type match")

		// Check for Secondary  Instance
		assert.Equal(secondaryAlloydbPrimaryInstancePath, SecondaryAlloyDBInstanceInfo.Get("name").String(), "Has to be same Primary Instance Path for secondary cluster")
		assert.Equal(state, SecondaryAlloyDBInstanceInfo.Get("state").String())

	})

	example.Test()
}

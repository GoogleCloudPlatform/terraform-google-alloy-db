// Copyright 2025 Google LLC
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

package restore_adb_cluster

import (
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestRestoreExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// Getting the expected Project ID from the outputs
		projectId := example.GetStringOutput("project_id")
		region := example.GetStringOutput("region")

		// Cluster Information
		alloydbClusterIdPath := example.GetStringOutput("source_cluster_id")
		alloydbClusterIdPathList := strings.Split(example.GetStringOutput("source_cluster_id"), "/")
		alloydbClusterId := alloydbClusterIdPathList[len(alloydbClusterIdPathList)-1]

		location := region
		state := "READY"
		gcOpsClusterInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", location, "--format", "json"})
		gcOpsPrimaryInstanceInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", location, "--cluster", alloydbClusterId, "--format", "json"})

		alloyDBClusterInfo := gcloud.Run(t, "alloydb clusters describe "+alloydbClusterId, gcOpsClusterInfo)
		alloyDBInstanceInfo := gcloud.Run(t, "alloydb instances list ", gcOpsPrimaryInstanceInfo).Array()[0]

		// Secondary Cluster Information
		restoredAlloydbClusterIdPath := example.GetStringOutput("restored_cluster_id")
		restoredAlloydbClusterIdPathList := strings.Split(example.GetStringOutput("restored_cluster_id"), "/")
		restoredAlloydbClusterId := restoredAlloydbClusterIdPathList[len(restoredAlloydbClusterIdPathList)-1]

		restored_location := region
		secondaryGcOpsClusterInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", restored_location, "--format", "json"})
		secondaryGcOpsPrimaryInstanceInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", restored_location, "--cluster", restoredAlloydbClusterId, "--format", "json"})

		restoredAlloydbClusterInfo := gcloud.Run(t, "alloydb clusters describe "+restoredAlloydbClusterId, secondaryGcOpsClusterInfo)
		restoredAlloydbInstanceInfo := gcloud.Run(t, "alloydb instances list ", secondaryGcOpsPrimaryInstanceInfo).Array()[0]

		// check for Cluster
		assert.Equal(alloydbClusterIdPath, alloyDBClusterInfo.Get("name").String(), "Has to be same Cluster path")

		// Check for Primary Instance
		assert.Equal(state, alloyDBInstanceInfo.Get("state").String())

		// check for Secondary Cluster
		assert.Equal(restoredAlloydbClusterIdPath, restoredAlloydbClusterInfo.Get("name").String(), "Has to be same Restored Cluster path")

		// Check for Secondary  Instance
		assert.Equal(state, restoredAlloydbInstanceInfo.Get("state").String())

	})

	example.Test()
}

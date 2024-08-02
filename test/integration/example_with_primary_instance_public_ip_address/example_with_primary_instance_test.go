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

func TestExampleWithPrimary(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// Getting the expected Project ID from the outputs
		projectId := example.GetStringOutput("project_id")

		// Cluster Information
		alloydb_cluster_id_path := example.GetStringOutput("cluster_id")
		alloydb_cluster_id_path_list := strings.Split(example.GetStringOutput("cluster_id"), "/")
		alloydb_cluster_id := alloydb_cluster_id_path_list[len(alloydb_cluster_id_path_list)-1]

		// Primary Instance Information
		alloydb_primary_instance_path := example.GetStringOutput("primary_instance_id")

		cluster_location := "us-central1"
		state := "READY"
		gcOps_ClusterInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--format", "json"})
		gcOps_PrimaryInstanceInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--cluster", alloydb_cluster_id, "--format", "json"})

		alloyDBClusterInfo := gcloud.Run(t, "alloydb clusters describe "+alloydb_cluster_id, gcOps_ClusterInfo)
		alloyDBInstanceInfo := gcloud.Run(t, "alloydb instances list ", gcOps_PrimaryInstanceInfo).Array()[0]

		// check for Cluster
		assert.Equal(alloydb_cluster_id_path, alloyDBClusterInfo.Get("name").String(), "Has to be same Cluster path")

		// Check for Primary Instance
		assert.Equal(alloydb_primary_instance_path, alloyDBInstanceInfo.Get("name").String(), "Has to be same Primary Instance Path")
		assert.Equal(state, alloyDBInstanceInfo.Get("state").String())
	})

	example.Test()
}

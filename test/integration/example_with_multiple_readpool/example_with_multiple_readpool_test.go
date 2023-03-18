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

package multiple_readpool_instance

import (
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestExampleWithMultipleReadPool(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// Getting the expected Project ID from the outputs
		projectId := example.GetStringOutput("project_id")

		// Cluster Information from terraform
		alloydb_cluster_id_path := example.GetStringOutput("cluster_id")
		alloydb_cluster_id_path_list := strings.Split(example.GetStringOutput("cluster_id"), "/")
		alloydb_cluster_id := alloydb_cluster_id_path_list[len(alloydb_cluster_id_path_list)-1]

		// Primary Instance Information from terraform
		alloydb_primary_instance_path := example.GetStringOutput("primary_instance_id")

		// Readpool Instances Information from terraform
		alloydb_read_instances_paths_string := example.GetStringOutput("read_instance_ids")
		alloydb_read_instances_paths_string = string(alloydb_read_instances_paths_string[:len(alloydb_read_instances_paths_string)-1])
		alloydb_read_instances_paths_string = string(alloydb_read_instances_paths_string[1:])

		// State information from GCloud

		cluster_location := "us-central1"
		state := "READY"
		gcOps_ClusterInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--format", "json"})
		gcOps_PrimaryInstanceInfo := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--cluster", alloydb_cluster_id, "--format", "json"})
		alloyDBClusterInfo := gcloud.Run(t, "alloydb clusters describe "+alloydb_cluster_id, gcOps_ClusterInfo)
		alloyDBInstanceInfo := gcloud.Run(t, "alloydb instances list ", gcOps_PrimaryInstanceInfo).Array()[0]
		instances_list := gcloud.Run(t, "alloydb instances list ", gcOps_PrimaryInstanceInfo).Array()

		alloyDB_readinstances := instances_list[1].Get("name").String()
		for i := 2; i < len(instances_list); i++ {
			alloyDB_readinstances = alloyDB_readinstances + " " + instances_list[i].Get("name").String()
		}

		// Check if expected state (via terraform) is same as actual state (on Cloud)

		// Check for Cluster
		assert.Equal(alloydb_cluster_id_path, alloyDBClusterInfo.Get("name").String(), "Cluster path must match")

		// Check for Primary Instance
		assert.Equal(alloydb_primary_instance_path, alloyDBInstanceInfo.Get("name").String(), "Primary Instance Paths must match")
		assert.Equal(state, alloyDBInstanceInfo.Get("state").String())

		// Check for Readpool Instance
		assert.Equal(alloydb_read_instances_paths_string, alloyDB_readinstances, "Readpool instances path must match")
	})

	example.Test()
}

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

package single_readpool_instance

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
)

func TestExampleWithReadPool(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// example.DefaultVerify(assert)
		projectID := example.GetStringOutput("project_id")
		alloydb_cluster_id_path := strings.Split(example.GetStringOutput("cluster_id"), "/")
		alloydb_primary_instance_path := strings.Split(example.GetStringOutput("primary_instance_id"), "/")
		alloydb_read_instances_paths_string := example.GetStringOutput("read_instance_ids")
		alloydb_read_instances_paths_string = string(alloydb_read_instances_paths_string[:len(alloydb_read_instances_paths_string)-1])
		alloydb_read_instances_paths_string = string(alloydb_read_instances_paths_string[1:])

		alloydb_cluster_id := alloydb_cluster_id_path[len(alloydb_cluster_id_path)-1]
		alloydb_primary_instance_id := alloydb_primary_instance_path[len(alloydb_primary_instance_path)-1]
		alloydb_read_instances_paths_list := strings.Split(alloydb_read_instances_paths_string, ",")

		for i, alloydb_read_instances_path := range alloydb_read_instances_paths_list {
			alloydb_read_instances_path := strings.Split(alloydb_read_instances_path, "/")
			alloydb_read_instances_paths_list[i] = alloydb_read_instances_path[len(alloydb_read_instances_path)-1]
		}

		expected_projectID := "ci-alloy-db-1-d510"
		expected_clusterID := "alloydb-cluster-nrp"
		expected_primaryInstanceID := "primary-instance-1"
		expected_readPoolIDs := []string{"read-instance-1"}

		assert.Equal(expected_projectID, projectID)
		assert.Equal(expected_clusterID, alloydb_cluster_id)
		assert.Equal(expected_primaryInstanceID, alloydb_primary_instance_id)
		assert.Equal(expected_readPoolIDs, alloydb_read_instances_paths_list)
	})

	example.Test()
}

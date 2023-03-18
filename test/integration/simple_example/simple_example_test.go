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

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestSimpleExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		alloydb_cluster_id_path := strings.Split(example.GetStringOutput("cluster_id"), "/")
		alloydb_primary_instance_path := strings.Split(example.GetStringOutput("primary_instance_id"), "/")

		alloydb_cluster_id := alloydb_cluster_id_path[len(alloydb_cluster_id_path)-1]
		alloydb_primary_instance_id := alloydb_primary_instance_path[len(alloydb_primary_instance_path)-1]

		expected_clusterID := "alloydb-cluster-with-prim"
		expected_primaryInstanceID := "primary-instance-1"

		assert.Equal(expected_clusterID, alloydb_cluster_id)
		assert.Equal(expected_primaryInstanceID, alloydb_primary_instance_id)
	})

	example.Test()
}

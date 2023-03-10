package primary_instance_adb_cluster

import (
	"strings"
	"testing"
	"github.com/stretchr/testify/assert"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
)

func TestExampleWithPrimary(t *testing.T) {
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

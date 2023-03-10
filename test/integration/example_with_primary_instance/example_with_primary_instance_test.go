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
		projectId := example.GetStringOutput("project_id")
		alloydb_cluster_id_path := strings.Split(example.GetStringOutput("cluster_id"), "/")
		// alloydb_primary_instance_path := strings.Split(example.GetStringOutput("primary_instance_id"), "/")

		alloydb_cluster_id := alloydb_cluster_id_path[len(alloydb_cluster_id_path)-1]
		// alloydb_primary_instance_id := alloydb_primary_instance_path[len(alloydb_primary_instance_path)-1]

		cluster_location := "us-central1"
		gcOps := gcloud.WithCommonArgs([]string{"--project", projectId, "--region", cluster_location, "--format", "json"})

		alloyDBClusterInfo := gcloud.Run(t, "alloydb clusters describe "+alloydb_cluster_id, gcOps)
		// alloyDBInstanceInfo := gcloud.Run(t, "alloydb instances describe --cluster "+alloydb_cluster_id+" "+alloydb_cluster_id, gcOps)

		assert.Equal("projects/"+projectId+"/global/networks/primary-example-adb-network", alloyDBClusterInfo.Get("network").String(), "Has to be same network")
	})

	example.Test()
}

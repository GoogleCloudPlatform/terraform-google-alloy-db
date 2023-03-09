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
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
)

func TestExampleWithReadPool(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// example.DefaultVerify(assert)
		projectID := example.GetStringOutput("project_id")
		alloydb_cluster_id := example.GetStringOutput("cluster_id")
		alloydb_primary_instance_id := example.GetStringOutput("primary_instance_id")
		alloydb_read_instances := example.GetStringOutput("read_instance_ids")

		assert.Equal("ci-alloy-db-1-d510", projectID)
		assert.Equal("projects/ci-alloy-db-1-d510/locations/us-central1/clusters/alloydb-cluster-nrp", alloydb_cluster_id)
		assert.Equal("projects/ci-alloy-db-1-d510/locations/us-central1/clusters/alloydb-cluster-nrp/instances/primary-instance-1", alloydb_primary_instance_id)
		assert.Equal("[projects/ci-alloy-db-1-d510/locations/us-central1/clusters/alloydb-cluster-nrp/instances/read-instance-1]", alloydb_read_instances)
	})

	// example.DefineVerify(func(assert *assert.Assertions) {
	// 	example.DefaultVerify(assert)

	// 	projectID := example.GetStringOutput("project_id")
	// 	spannerInstanceId := example.GetStringOutput("spanner_instance_id")
	// 	spannerDbId := example.GetStringOutput("spanner_db")
	// 	spannerInstanceName := strings.Split(spannerInstanceId, "/")[1]
	// 	spannerDbName := strings.Split(spannerDbId, "/")[1]
	// 	services := gcloud.Run(t, "services list", gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})).Array()
	// 	spannerInstances := gcloud.Run(t, "spanner instances list", gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})).Array()
	// 	spannerDbs := gcloud.Run(t, "spanner databases list --instance "+spannerInstanceName, gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})).Array()

	// 	svcmatch := utils.GetFirstMatchResult(t, services, "config.name", "spanner.googleapis.com")
	// 	spannerInstanceMatch := utils.GetFirstMatchResult(t, spannerInstances, "name", "projects/"+projectID+"/instances/"+spannerInstanceName)
	// 	spannerDbMatch := utils.GetFirstMatchResult(t, spannerDbs, "name", "projects/"+projectID+"/instances/"+spannerInstanceName+"/databases/"+spannerDbName)

	// 	assert.Equal("ENABLED", svcmatch.Get("state").String(), "Spanner service should be enabled")
	// 	assert.Equal("READY", spannerInstanceMatch.Get("state").String(), "Spanner Instance should be READY")
	// 	assert.Equal("200", spannerInstanceMatch.Get("processingUnits").String(), "Spanner Instance processingUnits should be 200")
	// 	assert.Equal(
	// 		"projects/"+projectID+"/instanceConfigs/"+"regional-europe-west1",
	// 		spannerInstanceMatch.Get("config").String(),
	// 		"Spanner Instance config should be in projects/"+projectID+"/instanceConfigs/"+"regional-europe-west1",
	// 	)
	// 	assert.Equal(
	// 		"GOOGLE_STANDARD_SQL",
	// 		spannerDbMatch.Get("databaseDialect").String(),
	// 		"Spanner DB Dialect should be GOOGLE_STANDARD_SQL",
	// 	)
	// 	assert.Equal(
	// 		"GOOGLE_DEFAULT_ENCRYPTION",
	// 		spannerDbMatch.Get("encryptionInfo").Array()[0].Get("encryptionType").String(),
	// 		"Spanner DB encryption type should be GOOGLE_DEFAULT_ENCRYPTION",
	// 	)

	// })
	example.Test()
}

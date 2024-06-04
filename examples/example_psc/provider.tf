/******************************************
  Provider credential configuration
 *****************************************/

locals {
  tf_sa = "gcp-sinprj-terraform@sinprj.iam.gserviceaccount.com"
}
provider "google" {
  impersonate_service_account = local.tf_sa
}

provider "google-beta" {
  impersonate_service_account = local.tf_sa
}


resource "google_service_account" "checkred_integration" {
  account_id   = "checkred-integration-account"
  display_name = "CheckRed Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.checkred_integration.email
}

resource "google_project_iam_binding" "viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/viewer"

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.checkred_integration.email}",
  ]
}

resource "google_project_iam_binding" "token_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:CHECKRED_SERVICE_ACCOUNT_EMAIL",
  ]
}

resource "google_project_iam_custom_role" "checkred_gke_policy" {
  role_id     = "checkred_gke_policy"
  title       = "CheckRed GKE Policy"
  description = "Custom role with permission to proxy GKE nodes"
  project     = "PROJECT_ID"

  permissions = [
    "container.nodes.proxy",
  ]
}

resource "google_project_iam_binding" "checkred_gke_policy_binding" {
  project = "PROJECT_ID"
  role    = "projects/PROJECT_ID/roles/${google_project_iam_custom_role.checkred_gke_policy.role_id}"

  members = [
    "serviceAccount:CHECKRED_SERVICE_ACCOUNT_EMAIL",
  ]
}


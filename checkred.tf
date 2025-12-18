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

resource "google_service_account_iam_binding" "allow_org_impersonation" {
  service_account_id = google_service_account.checkred_dns_org_integration.name
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL",
  ]
}

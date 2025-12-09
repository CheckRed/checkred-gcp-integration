resource "google_service_account" "checkred_dns_integration" {
  account_id   = "checkred-dns-integration-account"
  display_name = "CheckRed DNS Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.checkred_dns_integration.email
}

resource "google_project_iam_binding" "dns_reader_binding" {
  project = "PROJECT_ID"
  role    = "roles/dns.reader"

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.checkred_dns_integration.email}",
  ]
}

resource "google_project_iam_binding" "dns_logs_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/logging.viewer"

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.checkred_dns_integration.email}",
  ]
}

resource "google_project_iam_binding" "token_dns_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:CHECKRED_SERVICE_ACCOUNT_EMAIL",
  ]
}

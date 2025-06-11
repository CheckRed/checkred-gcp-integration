resource "google_service_account" "checkred_integration" {
  account_id   = "checkred-dnspm-indiv-account"
  display_name = "CheckRed Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.checkred_integration.email
}

resource "google_project_iam_custom_role" "checkred_dnspm_logs_viewer_role" {
  role_id     = "CheckRedDNSPMRole"
  title       = "CheckRed DNSPM Logs Viewer Role"
  description = "Custom role with DNSPM specific permissions"
  permissions = ["logging.logEntries.list","logging.privateLogEntries.list"]
}

resource "google_project_iam_binding" "dns_reader_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/dns.reader"

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.checkred_integration.email}",
  ]
}

resource "google_project_iam_binding" "dns_logs_role_viewer_binding" {
  project = "PROJECT_ID"
  role    = google_project_iam_custom_role.checkred_dnspm_logs_viewer_role.name

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

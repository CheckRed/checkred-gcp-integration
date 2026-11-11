resource "google_service_account" "dns_integration" {
  account_id   = "dns-intg-acnt"
  display_name = "DNS Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.dns_integration.email
}

resource "google_project_iam_member" "dns_reader_binding" {
  project = "PROJECT_ID"
  role    = "roles/dns.reader"

  member = "serviceAccount:${google_service_account.dns_integration.email}"
}

resource "google_project_iam_custom_role" "resourcemanager_reader_role_dns" {
  project     = "PROJECT_ID"
  role_id     = "resourcemanagerReaderdns"
  title       = "Resource Manager Reader DNS"
  description = "Read access to folders and projects"

  permissions = [
    "resourcemanager.projects.get",
  ]
}

# Bind the custom role to the DNS integration service account
resource "google_project_iam_member" "resourcemanager_reader_binding" {
  project = "PROJECT_ID"
  role    = google_project_iam_custom_role.resourcemanager_reader_role_dns.name

  member = "serviceAccount:${google_service_account.dns_integration.email}"
}

resource "google_project_iam_member" "dns_logs_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/logging.viewer"

  member = "serviceAccount:${google_service_account.dns_integration.email}"
}

resource "google_project_iam_member" "token_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  member = "serviceAccount:SERVICE_ACCOUNT_EMAIL"
}

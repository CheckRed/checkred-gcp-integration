resource "google_service_account" "checkred_integration" {
  account_id   = "checkred-dnspm-individual-integration-account"
  display_name = "CheckRed Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.checkred_integration.email
}

resource "google_project_iam_custom_role" "checkred_dnspm_role" {
  role_id     = "CheckRedDNSPMRole"
  title       = "CheckRed DNSPM Role"
  description = "Custom role with DNSPM specific permissions"
  permissions = ["dns.changes.get","dns.changes.list","dns.dnsKeys.get","dns.dnsKeys.list","dns.managedZoneOperations.get","dns.managedZoneOperations.list","dns.managedZones.get","dns.managedZones.list","dns.policies.get","dns.policies.list","dns.projects.get","dns.resourceRecordSets.get","dns.resourceRecordSets.list","resourcemanager.projects.get","resourcemanager.projects.list","logging.logEntries.list","logging.privateLogEntries.list"]
}


resource "google_project_iam_binding" "viewer_binding" {
  project = "PROJECT_ID"
  role    = google_project_iam_custom_role.checkred.checkred_dnspm_role.role_id

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

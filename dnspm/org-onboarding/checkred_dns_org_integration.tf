data "google_project" "project" {
}

resource "google_service_account" "checkred_dns_org_integration" {
  account_id   = "checkred-dns-org-integration"
  display_name = "CheckRed Organization Integration Service Account"
  project      = data.google_project.project.number
}

data "google_projects" "all_projects" {
  filter = "parent.id:*"
}

resource "google_project_iam_binding" "checkred_dns_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/dns.reader"

  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_organization_iam_custom_role" "checkred_dns_read_access_role" {
  role_id     = "CheckRedReadAccessRole"
  org_id      = "ORGANIZATION_ID"
  title       = "checkred-dns-service-account-read-role"
  description = "CheckRed DNS integration custom role for read access to organization, folders & projects"
  permissions = [
    "resourcemanager.organizations.get",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list"
  ]
}

resource "google_project_iam_custom_role" "checkred_dnspm_logs_viewer_role" {
  role_id     = "CheckRedDNSPMOrgRole"
  title       = "CheckRed DNSPM Org Logs Viewer Role"
  description = "Custom role with DNSPM specific permissions"
  permissions = ["logging.logEntries.list","logging.privateLogEntries.list"]
}

resource "google_organization_iam_binding" "list_projects_binding" {
  org_id = "ORGANIZATION_ID"
  role   = google_organization_iam_custom_role.checkred_dns_read_access_role.id
  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_project_iam_binding" "dns_logs_role_viewer_binding" {
  project = "PROJECT_ID"
  role    = google_project_iam_custom_role.checkred_dnspm_logs_viewer_role.name

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_project_iam_binding" "token_creator_binding" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL",
  ]
}

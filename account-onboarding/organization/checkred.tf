data "google_project" "project" {
}

resource "google_service_account" "checkred_org_integration" {
  account_id   = "checkred-org-integration"
  display_name = "CheckRed Organization Integration Service Account"
  project      = data.google_project.project.number
}

data "google_projects" "all_projects" {
  #filter = "parent.id:*"
  filter = "parent.type:organization parent.id=ORGANIZATION_ID"

}

resource "google_project_iam_binding" "checkred_viewer" {
  count   = var.enable_cspm ? length(data.google_projects.all_projects.projects) : 0
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.checkred_org_integration.email}",
  ]
}

resource "google_organization_iam_custom_role" "checkred_read_access_role" {
  role_id     = "CheckRedReadAccessRole"
  org_id      = "ORGANIZATION_ID"
  title       = "checkred-service-account-read-role"
  description = "CheckRed integration custom role for read access to organization, folders & projects"
  permissions = [
    "resourcemanager.organizations.get",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list"
  ]
}

resource "google_organization_iam_binding" "list_projects_binding" {
  org_id = "ORGANIZATION_ID"
  role   = google_organization_iam_custom_role.checkred_read_access_role.id
  members = [
    "serviceAccount:${google_service_account.checkred_org_integration.email}",
  ]
}

resource "google_organization_iam_custom_role" "checkred_dnspm_viewer_role" {
  count   = var.enable_dnspm ? 1 : 0
  org_id     = "ORGANIZATION_ID"
  role_id     = "CheckRedDNSPMOrgRole"
  title       = "CheckRed DNSPM Org Logs Viewer Role"
  description = "Custom role with DNSPM specific permissions"
  permissions = [
    "dns.changes.get",
    "dns.changes.list",
    "dns.dnsKeys.get",
    "dns.dnsKeys.list",
    "dns.managedZoneOperations.get",
    "dns.managedZoneOperations.list",
    "dns.managedZones.get",
    "dns.managedZones.list",
    "dns.policies.get",
    "dns.policies.list",
    "dns.projects.get",
    "dns.resourceRecordSets.get",
    "dns.resourceRecordSets.list",
    "resourcemanager.projects.get",
    "logging.logEntries.list",
    "logging.privateLogEntries.list"
  ]
}

resource "google_project_iam_binding" "checkred_dns_viewer" {
  count   = var.enable_dnspm  ? length(data.google_projects.all_projects.projects) : 0
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = google_organization_iam_custom_role.checkred_dnspm_viewer_role[0].name

  members = [
    "serviceAccount:${google_service_account.checkred_org_integration.email}",
  ]
 depends_on = [
    google_organization_iam_custom_role.checkred_dnspm_viewer_role
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

output "checkred_org_service_account_email" {
  value       = google_service_account.checkred_org_integration.email
  description = "CheckRed Org Intergration Service Account Email"
}

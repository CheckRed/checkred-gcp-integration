data "google_project" "project" {
}

resource "google_service_account" "dns_org_integration" {
  account_id   = "dns-org-integration"
  display_name = "DNS Organization Integration Service Account"
  project      = data.google_project.project.number
}

data "google_projects" "all_projects" {
  filter = "parent.id:*"
}


resource "google_project_iam_member" "dns_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/dns.reader"

  member ="serviceAccount:${google_service_account.dns_org_integration.email}"

}


resource "google_project_iam_member" "logs_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/logging.viewer"

  member ="serviceAccount:${google_service_account.dns_org_integration.email}"
}

resource "google_project_iam_member" "storage_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/storage.viewer"

  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_project_iam_member" "cloud_functions_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/cloudfunctions.viewer"

  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_project_iam_member" "cloud_run_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/run.viewer"

  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_organization_iam_custom_role" "dns_read_access_role" {
  role_id     = "DNSReadAccessRoleV3"
  org_id      = "ORGANIZATION_ID"
  title       = "service-account-dns-read-role-v3"
  description = "DNS integration custom role for read access to organization, folders & projects"
  permissions = [
    "resourcemanager.organizations.get",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
    "iam.serviceAccounts.getAccessToken"
  ]
}

resource "google_organization_iam_binding" "list_projects_binding" {
  org_id = "ORGANIZATION_ID"
  role   = google_organization_iam_custom_role.dns_read_access_role.id
  members = [
    "serviceAccount:${google_service_account.dns_org_integration.email}",
  ]
}

resource "google_project_iam_member" "token_creator_binding" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  member = "serviceAccount:ORG_SERVICE_ACCOUNT_EMAIL"
}
 

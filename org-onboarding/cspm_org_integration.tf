data "google_project" "project" {
}

resource "google_service_account" "cspm_org_integration" {
  account_id   = "cspm-org-integration"
  display_name = "GCP Organization Integration Service Account"
  project      = data.google_project.project.number
}

data "google_projects" "all_projects" {
  filter = "parent.id:*"
}


resource "google_project_iam_binding" "gcp_viewer" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.cspm_org_integration.email}",
  ]
}

resource "google_organization_iam_custom_role" "cspm_read_access_role" {
  role_id     = "ReadAccessRoleCspm"
  org_id      = "ORGANIZATION_ID"
  title       = "cspm-service-account-read-role"
  description = "GCP integration custom role for read access to organization, folders & projects"
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
  role   = google_organization_iam_custom_role.cspm_read_access_role.id
  members = [
    "serviceAccount:${google_service_account.cspm_org_integration.email}",
  ]
}

resource "google_project_iam_binding" "token_creator_binding" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:ORG_SERVICE_ACCOUNT_EMAIL",
  ]
}

data "google_project" "project" {
}

resource "google_service_account" "checkred_org_integration" {
  account_id   = "checkred-org-integration"
  display_name = "CheckRed Organization Integration Service Account"
  project      = data.google_project.project.number
}

data "google_projects" "all_projects" {
  filter = "parent.id:*"
}


resource "google_project_iam_binding" "checkred_viewer" {
  count   = length(data.google_projects.all_projects.projects)
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

resource "google_project_iam_binding" "token_creator_binding" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL",
  ]
}

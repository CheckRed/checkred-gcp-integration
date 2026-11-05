data "google_project" "project" {
}

resource "google_service_account" "checkred_dns_org_integration" {
  account_id   = "checkred-dns-org-integration"
  display_name = "CheckRed DNS Organization Integration Service Account"
  project      = data.google_project.project.number
}

data "google_projects" "all_projects" {
  filter = "parent.id:*"
}

resource "google_organization_iam_custom_role" "checkred_dns_read_access_role" {
  role_id     = "CheckRedDNSReadAccessRoleV3"
  org_id      = "ORGANIZATION_ID"
  title       = "checkred-service-account-dns-read-role-v3"
  description = "CheckRed DNS integration custom role for read access to organization, folders & projects"
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
  role   = google_organization_iam_custom_role.checkred_dns_read_access_role.id
  members = [
    "serviceAccount:${google_service_account.checkred_dns_org_integration.email}",
  ]
}

resource "google_organization_iam_custom_role" "checkred_ddos_read_access_role" {
  role_id     = "CheckRedDDoSReadAccessRoleV1"
  org_id      = "ORGANIZATION_ID"
  title       = "checkred-service-account-ddos-read-role-v1"
  description = "CheckRed DDoS integration custom role for read access to network, compute, logging & monitoring resources"
  permissions = [
    "compute.projects.get",
    "compute.instanceGroups.get",
    "compute.networkEndpointGroups.get",
    "compute.regionNetworkEndpointGroups.get",
    "resourcemanager.projects.get",
    "compute.backendBuckets.list",
    "compute.backendServices.list",
    "compute.securityPolicies.list",
    "run.domainmappings.list",
    "run.services.list",
    "compute.instances.list",
    "compute.firewallPolicies.list",
    "compute.firewalls.list",
    "compute.forwardingRules.list",
    "compute.addresses.list",
    "compute.instanceGroupManagers.list",
    "compute.instanceGroups.list",
    "logging.logEntries.list",
    "monitoring.timeSeries.list",
    "compute.networkEdgeSecurityServices.list",
    "compute.networkEndpointGroups.list",
    "logging.privateLogEntries.list",
    "compute.publicAdvertisedPrefixes.list",
    "resourcemanager.projects.list",
    "compute.targetInstances.list"
  ]
}

resource "google_organization_iam_member" "checkred_ddos_read_access_binding" {
  org_id = "ORGANIZATION_ID"
  role   = google_organization_iam_custom_role.checkred_ddos_read_access_role.id
  member = "serviceAccount:${google_service_account.checkred_dns_org_integration.email}"
}

resource "google_project_iam_member" "token_creator_binding" {
  count   = length(data.google_projects.all_projects.projects)
  project = data.google_projects.all_projects.projects[count.index].project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  member = "serviceAccount:CHECKRED_ORG_SERVICE_ACCOUNT_EMAIL"
}

resource "google_service_account" "ddos_integration" {
  account_id   = "ddos-intg-acnt"
  display_name = "DDoS Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.ddos_integration.email
}

resource "google_project_iam_custom_role" "resourcemanager_reader_role" {
  project     = "PROJECT_ID"
  role_id     = "resourcemanagerReader"
  title       = "Resource Manager Reader"
  description = "Read access to folders and projects"
  permissions = [
    "resourcemanager.projects.get",

  ]
}

# Bind the custom role to the DNS integration service account
resource "google_project_iam_member" "resourcemanager_reader_binding" {
  project = "PROJECT_ID"
  role    = google_project_iam_custom_role.resourcemanager_reader_role.name

  member = "serviceAccount:${google_service_account.ddos_integration.email}"
}

resource "google_project_iam_custom_role" "ddos_read_role" {
  project     = "PROJECT_ID"
  role_id     = "DDoSReadRoleV1"
  title       = "DDoS Read Role"
  description = "DDoS integration custom role for read access to network, compute, logging & monitoring resources"
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
    "compute.targetInstances.list"
  ]
}

resource "google_project_iam_member" "ddos_read_binding" {
  project = "PROJECT_ID"
  role    = google_project_iam_custom_role.ddos_read_role.name
  member  = "serviceAccount:${google_service_account.ddos_integration.email}"
}

resource "google_project_iam_member" "token_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  member = "serviceAccount:SERVICE_ACCOUNT_EMAIL"
}

resource "google_service_account" "dns_ddos_cloud_correlation_integration" {
  account_id   = "dns-ddos-cc-intg-acnt"
  display_name = "DNS DDoS Cloud Correlation Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.dns_ddos_cloud_correlation_integration.email
}

resource "google_project_iam_member" "dns_reader_binding" {
  project = "PROJECT_ID"
  role    = "roles/dns.reader"

  # Reference the email of the service account from the output
  member = "serviceAccount:${google_service_account.dns_ddos_cloud_correlation_integration.email}"
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

  member = "serviceAccount:${google_service_account.dns_ddos_cloud_correlation_integration.email}"
}

resource "google_project_iam_member" "dns_logs_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/logging.viewer"

  # Reference the email of the service account from the output
  member = "serviceAccount:${google_service_account.dns_ddos_cloud_correlation_integration.email}"
}

resource "google_project_iam_member" "token_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  member = "serviceAccount:SERVICE_ACCOUNT_EMAIL"
}

# Grant Storage Viewer permission
resource "google_project_iam_member" "storage_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/storage.viewer"

  member = "serviceAccount:${google_service_account.dns_ddos_cloud_correlation_integration.email}"
}

# Grant Cloud Functions Viewer permission
resource "google_project_iam_member" "cloudfunctions_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/cloudfunctions.viewer"

  member = "serviceAccount:${google_service_account.dns_ddos_cloud_correlation_integration.email}"
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
  member  = "serviceAccount:${google_service_account.dns_ddos_integration.email}"
}

# Grant Cloud Run Viewer permission
resource "google_project_iam_member" "run_viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/run.viewer"

  member = "serviceAccount:${google_service_account.dns_ddos_cloud_correlation_integration.email}"
}


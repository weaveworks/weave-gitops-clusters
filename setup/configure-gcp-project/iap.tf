#
# Configure bits for the Identity Aware Proxy
#
# This is mostly configured per-project.
# cf. https://cloud.google.com/iap/docs/enabling-kubernetes-howto
#
# I am 90% certain that 'brand' things here correspond to the general project
# bits in the above
#


resource "google_iap_brand" "weave_gitops" {
  support_email     = var.oauth_support_email
  application_title = "weave-gitops-clusters"
  project           = "586119081318"
}

# Grant all weave-workers (well everyone with a weave email) access to the app
resource "google_iap_web_iam_member" "weaveworkers" {
  project = var.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member  = "domain:weave.works"
}

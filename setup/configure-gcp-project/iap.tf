#
# Configure bits for the Identity Aware Proxy
#
# This is mostly configured per-project.
# cf. https://cloud.google.com/iap/docs/enabling-kubernetes-howto
#
# I am 90% certain that 'brand' things here correspond to the general project
# bits in the above
#

locals {
  # Must match the google group prefix ('@weave.works' appended inline)
  # for team list see https://groups.google.com/all-groups?q=team
  ww_engineering_teams = [
    for team in [
      "bluetonium",
      "denim",
      "flux",
      "frostbite",
      "pesto",
      "pitch-black",
      "quick-silver",
      "sunglow",
      "team-gitops-design",
      "timber-wolf",
    ] :
    "team-${team}@weave.works"
  ]
}

resource "google_iap_brand" "weave_gitops" {
  support_email     = var.oauth_support_email
  application_title = "weave-gitops-clusters"
  project           = "586119081318"
}

# Allow access to the cluster to these groups
resource "google_iap_web_iam_member" "cluster_group_accessors" {
  for_each = toset(local.ww_engineering_teams)

  project = var.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member  = "group:${each.value}"
}

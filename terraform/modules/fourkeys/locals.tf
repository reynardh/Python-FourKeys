locals {
  event_handler_container_url = var.enable_build_images ? format("gcr.io/%s/event-handler", var.project_id) : var.event_handler_container_url
  dashboard_container_url     = var.enable_build_images ? format("gcr.io/%s/fourkeys-grafana-dashboard", var.project_id) : var.dashboard_container_url
  parser_container_urls = var.enable_build_images ? {
    "github"      = format("gcr.io/%s/github-parser", var.project_id)
    "gitlab"      = format("gcr.io/%s/gitlab-parser", var.project_id)
    "cloud-build" = format("gcr.io/%s/cloud-build-parser", var.project_id)
    "tekton"      = format("gcr.io/%s/tekton-parser", var.project_id)
  } : var.parser_container_urls
}

variable "google_project_id" {
  type = string
}

variable "google_region" {
  type = string
}

variable "bigquery_region" {
  type = string
  validation {
    condition = (
      contains(["US", "EU"], var.bigquery_region)
    )
    error_message = "The value for 'bigquery_region' must be one of: 'US','EU'."
  }
}

variable "parsers" {
  type        = list(any)
  description = "list of data parsers to configure (e.g. 'gitlab','tekton')"
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
}

variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
}
variable "cluster_name" {
  description = "Cluster Name"
  type        = string
  default       = "flux-preview"
}
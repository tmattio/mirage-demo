output "project_id" {
  description = "The project ID where the environment has been provisioned on."
  value       = var.project_id
}

output "region" {
  description = "The location where the environment has been provisioned on."
  value       = var.region
}

output "github-actions-email" {
  description = "Email of the Github Actions service account."
  value       = module.global.github-actions-email
}

output "github-actions-private-key" {
  description = "Private key of the Github Actions service account."
  value       = module.global.github-actions-private-key
}
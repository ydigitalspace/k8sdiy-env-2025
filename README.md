# K8S DIY
# Flux Operator with Ephemeral Environments

The example demonstrates how to create Preview Environments based on Pull Request event with Flux Operator and [Ephemeral Environments](https://fluxcd.control-plane.io/operator/resourcesets/github-pull-requests/).

Note: The GitHub repository* is created and auto initialised ready for Flux stack, Flux Operator and Discord notifications to use.

###### *Creating a fine-gained PAT and dedicated Flux user recommend, for more information see [here](https://fluxcd.io/flux/installation/bootstrap/github/#github-organization)


## Quick Start

``` bash
bash ./codespace.sh
flux -n app-preview create secret git github-auth \
   --url=https://github.com/org/app \
   --username=flux \
   --password=${GITHUB_TOKEN}
kubectl apply -f gateway
kubectl apply -f preview
```

## Cleanup
``` bash
cd bootstrap
tofu destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | >= 1.2 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 6.1 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | >= 0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | >= 1.2 |
| <a name="provider_github"></a> [github](#provider\_github) | >= 6.1 |
| <a name="provider_kind"></a> [kind](#provider\_kind) | >= 0.4 |

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/resources/bootstrap_git) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [kind_cluster.this](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | GitHub organization | `string` | `""` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository | `string` | `""` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub token | `string` | `""` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

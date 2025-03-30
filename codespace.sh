#!/bin/bash
# Install OpenTofu
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone 

# Install K9S to manage the cluster
curl -sS https://webi.sh/k9s | sh

# Initialize Tofu
cd bootstrap
tofu init

# Prompt the user to enter the GitHub token securely
read -s GITHUB_TOKEN

# Export GitHub organization, repository, and token as environment variables
export TF_VAR_github_token="$GITHUB_TOKEN"

# Apply terrafrom configuration
tofu apply

# Create alias for k9s, kubectl and command-line autocompletion
alias kk="EDITOR='code --wait' k9s"
alias tf=tofu
alias k=kubectl
# source <(kubectl completion zsh)

# kubectl create secret generic kbot --from-literal=token=$TELE_TOKEN -n app-preview
#
# export ENVOY_SERVICE=$(kubectl get svc -n envoy-gateway-system --selector=gateway.envoyproxy.io/owning-gateway-namespace=default,gateway.envoyproxy.io/owning-gateway-name=eg -o jsonpath='{.items[0].metadata.name}')
#
# kubectl -n envoy-gateway-system port-forward service/${ENVOY_SERVICE} 8888:80 &
#
# k apply -f preview
# flux -n app-preview create secret git github-auth \
#   --url=https://github.com/org/app \
#   --username=flux \
#   --password=${GITHUB_TOKEN}
# # kubectl create secret generic github-auth --from-literal=token=${GITHUB_TOKEN} -n app-preview

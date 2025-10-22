# ===== Help =====
help:
	@echo "Available targets:"
	@echo "  tools             - Install necessary tools"
	@echo "  tofu              - Initialize Tofu"
	@echo "  set-github-vars   - Set GitHub variables"
	@echo "  apply-tofu        - Apply Tofu configuration"
	@echo "  create-aliases    - Create command aliases"
	@echo "  init              - Run all targets to bootstrap the environment"
	@echo "  kind-up           - Create kind cluster (NAME, IMAGE overridable)"
	@echo "  kind-down         - Delete kind cluster"
	@echo "  kind-recreate     - Recreate kind cluster"
	@echo "  kind-snapshot     - Export cluster resources to cluster-state.yaml"

# ===== Tools / Bootstrap =====
tools:
	@echo "Installing tools..."
	@curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone
	@curl -sS https://webi.sh/k9s | bash
	@curl -sS https://fluxcd.io/install.sh | bash

tofu:
	@echo "Initializing Tofu..."
	@cd bootstrap && tofu init

set-github-vars:
	@echo "Setting GitHub variables..."
	@read -p "Enter your GitHub organization: " TF_VAR_github_org; \
	read -p "Enter your GitHub repository: " TF_VAR_github_repository; \
	read -s -p "Enter your GitHub token: " TF_VAR_github_token; \
	echo; \
	export TF_VAR_github_org=$$TF_VAR_github_org; \
	export TF_VAR_github_repository=$$TF_VAR_github_repository; \
	export TF_VAR_github_token=$$TF_VAR_github_token; \
	echo "GitHub Organization: $$TF_VAR_github_org"; \
	echo "GitHub Repository: $$TF_VAR_github_repository"; \
	echo "GitHub Token: [HIDDEN]"

apply-tofu:
	@echo "Applying Tofu configuration..."
	@tofu apply

create-aliases:
	@echo "Creating aliases..."
	@alias kk="EDITOR='code --wait' k9s"
	@alias k=kubectl

# Run all bootstrap steps
init: tools tofu set-github-vars apply-tofu create-aliases
	@echo "Bootstrapping complete."

# ===== kind helpers =====
.PHONY: kind-up kind-down kind-recreate kind-snapshot
KIND_NAME ?= k8sdiy
KIND_IMAGE ?= kindest/node:v1.30.4

kind-up:
	NAME=$(KIND_NAME) IMAGE=$(KIND_IMAGE) bash scripts/kind-up.sh

kind-down:
	NAME=$(KIND_NAME) bash scripts/kind-down.sh

kind-recreate: kind-down kind-up

kind-snapshot:
	NAME=$(KIND_NAME) bash scripts/kind-snapshot.sh


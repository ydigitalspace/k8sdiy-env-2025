# Variables
IMAGE_NAME=ghcr.io/den-vasyliev/my-helm-chart
IMAGE_TAG=latest
CHART_NAME=my-helm-chart
NAMESPACE=test

# Build Docker image
build:
		docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# Push Docker image to repository
push:
		docker push $(IMAGE_NAME):$(IMAGE_TAG)

# Deploy Helm chart
deploy:
		helm upgrade --install $(CHART_NAME) ./$(CHART_NAME) --namespace $(NAMESPACE)

# Clean up Helm release
clean:
		helm uninstall $(CHART_NAME) --namespace $(NAMESPACE)

# Full pipeline
all: build push deploy

.PHONY: build push deploy clean all
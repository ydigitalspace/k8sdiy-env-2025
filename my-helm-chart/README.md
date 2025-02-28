# my-helm-chart/my-helm-chart/README.md

# My Helm Chart

This Helm chart deploys a simple HTTP server application using a distroless image. The application responds with a version message on port 8080.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.x

## Installation

To install the chart, use the following command:

```bash
helm install my-release ./my-helm-chart
```

Replace `my-release` with your desired release name.

## Configuration

The following table lists the configurable parameters of the chart and their default values:

| Parameter          | Description                          | Default         |
|--------------------|--------------------------------------|------------------|
| `image.repository` | Container image repository            | `gcr.io/distroless/static` |
| `image.tag`        | Container image tag                   | `latest`         |
| `service.type`     | Service type (e.g., ClusterIP, NodePort) | `ClusterIP`     |
| `service.port`     | Port to expose the service           | `8080`           |

## Uninstallation

To uninstall the chart, use the following command:

```bash
helm uninstall my-release
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.
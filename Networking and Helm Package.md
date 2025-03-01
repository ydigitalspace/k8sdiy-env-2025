# Kubernetes Networking and Helm Package Management & Troubleshooting

## Task 1: Replace iptables with IPVS

### Overview
Це завдання фокусується на переключені режиму мережевого проксі Kubernetes з iptables на IPVS (IP Virtual Server) для покращення продуктивності та масштабованості. IPVS забезпечує кращу продуктивність для великих кластерів, оскільки використовує більш ефективні структури даних (хеш-таблиці) порівняно з лінійними списками iptables.

### Steps:
1. **Configure and create KinD Cluster with IPVS in your main.tf file **
   ```hcl
   networking {
       kube_proxy_mode = "ipvs"
   }
   ```

2. **Cluster Node Management**
   - Find container ID: `docker ps`
   - Access node: `docker exec -it <CONTAINER_ID> bash`
   - Update package manager: `apt-get update`
   - Install IPVS tools: `apt-get install ipvsadm`

3. **Comparison and Verification**
   - Compare iptables configuration: `iptables-save`
   - Check IPVS configuration: `ipvsadm -ln`
   - Note: IPVS typically shows significantly reduced rule complexity compared to iptables

## Task 2: Helm Package Troubleshooting

### Overview
Дізнайтеся, як працювати з Helm пакетами, включаючи витягування, перевірку, встановлення та усунення несправностей.

### Steps:
1. **Package Retrieval**
   ```bash
   export HELM_EXPERIMENTAL_OCI=1
   helm pull oci://ghcr.io/den-vasyliev/charts/my-helm-chart --version 0.1.00
   ```

2. **Package Validation and Installation**
   - Validate package: `helm lint my-helm-chart-0.1.00.tgz`
   - Install to test namespace: `helm install test my-helm-chart-0.1.00.tgz -n test`
   - Verify deployment: `kubectl get all -n test`

3. **Troubleshooting Process**
   - Check pod logs: `kubectl logs <pod-name> -n test`
   - Describe resources: `kubectl describe <resource> -n test`
   - Update installation: `helm upgrade <release-name> <chart> -n test`
   - Verify service: 
     ```bash
     kubectl port-forward <pod-name> <local-port>:<container-port> -n test
     curl localhost:<local-port>
     ```

## Task 3: Load Balancing Configuration

### Overview
Налаштуйте та протестуйте балансування навантаження між різними версіями вашого додатку за допомогою сервісів NodePort та зовнішніх балансувальників.

### Steps:
1. **Version Management**
   - Install second version: `helm install <release-name> <chart> --set version=2.0.0`
   - Create NodePort service: `kubectl expose deployment <deployment-name> --type=NodePort`

2. **Load Balancing Setup**
   - Configure 20/80 distribution between versions
   - Scale deployments: `kubectl scale deployment <deployment-name> --replicas=<count>`

3. **External Access**
   - Configure HAProxy: Create and apply haproxy.cfg
   - Expose service using ngrok or GitHub Codespace ports
   - Test load distribution

## Task 4: Gateway API Configuration*

### Overview
(Завдання із зірочкою)

Реалізуйте та налаштуйте Gateway API  для вашого пакета Helm, включно з пакуванням та розповсюдженням.

### Steps:
1. **Gateway Setup**
   - Create HTTPRoute configuration (htr.yaml)
   - Test configuration locally
   - Integrate into Helm chart

2. **Package Management**
   - Package chart: `helm package <chart-directory>`
   - Registry authentication: 
     ```bash
     export GITHUB_TOKEN=<your-token>
     helm registry login ghcr.io -u <username> -p $GITHUB_TOKEN
     ```
   - Push package: `helm push <package> oci://ghcr.io/<repository>`

## Best Practices
- Завжди перевіряйте конфігурації перед застосуванням
- Використовуйте змістовні назви для релізів та ресурсів
- Підтримуйте належний контроль версій для Helm чартів

## Additional Resources
- [Kubernetes IPVS Documentation](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-ipvs)
- [Helm Documentation](https://helm.sh/docs/)
- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [HAProxy Configuration Guide](http://www.haproxy.org/#docs)

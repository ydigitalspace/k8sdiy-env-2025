mkdir -p ./kubebuilder/bin && \
    curl -L https://storage.googleapis.com/kubebuilder-tools/kubebuilder-tools-1.30.0-linux-amd64.tar.gz -o kubebuilder-tools.tar.gz && \
    tar -C ./kubebuilder --strip-components=1 -zvxf kubebuilder-tools.tar.gz && \
    rm kubebuilder-tools.tar.gz

# Download kubelet
echo "Downloading kubelet..." && \
    KUBE_VERSION="v1.28.6" && \
    curl -L "https://dl.k8s.io/v1.30.0/bin/linux/amd64/kubelet" -o kubebuilder/bin/kubelet && \
    chmod +x kubebuilder/bin/kubelet

# Generating service account key pair
echo "Generating service account key pair..." && \
openssl genrsa -out /tmp/sa.key 2048 && \
openssl rsa -in /tmp/sa.key -pubout -out /tmp/sa.pub

# Generating token
echo "Generating token file..." && \
    TOKEN="1234567890" && \
    echo "${TOKEN},admin,admin,system:masters" > /tmp/token.csv

kubebuilder/bin/kubectl config set-credentials test-user --token=1234567890
kubebuilder/bin/kubectl config set-cluster test-env --server=https://127.0.0.1:6443 --insecure-skip-tls-verify
kubebuilder/bin/kubectl config set-context test-context --cluster=test-env --user=test-user --namespace=default 
kubebuilder/bin/kubectl config use-context test-context

# Get the container's IP address
HOST_IP=$(hostname -I | awk '{print $1}')

# Start etcd
echo "Starting etcd..."
kubebuilder/bin/etcd \
    --advertise-client-urls http://$HOST_IP:2379 \
    --listen-client-urls http://0.0.0.0:2379 \
    --data-dir ./etcd \
    --listen-peer-urls http://0.0.0.0:2380 \
    --initial-cluster default=http://$HOST_IP:2380 \
    --initial-advertise-peer-urls http://$HOST_IP:2380 \
    --initial-cluster-state new \
    --initial-cluster-token test-token &

# Wait for etcd to be ready
curl http://127.0.0.1:2379/health

# Start kube-apiserver
echo "Starting kube-apiserver..."
sudo kubebuilder/bin/kube-apiserver \
    --etcd-servers=http://$HOST_IP:2379 \
    --service-cluster-ip-range=10.0.0.0/24 \
    --bind-address=0.0.0.0 \
    --secure-port=6443 \
    --advertise-address=$HOST_IP \
    --authorization-mode=AlwaysAllow \
    --token-auth-file=/tmp/token.csv \
    --enable-priority-and-fairness=false \
    --allow-privileged=true \
    --profiling=false \
    --storage-backend=etcd3 \
    --storage-media-type=application/json \
    --v=0 \
    --service-account-issuer=https://kubernetes.default.svc.cluster.local \
    --service-account-key-file=/tmp/sa.pub \
    --service-account-signing-key-file=/tmp/sa.key&

# Wait for API server to be ready

kubebuilder/bin/kubectl get --raw='/readyz'

cat << EOF | sudo tee /var/lib/kubelet/config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: true
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubelet/ca.crt"
authorization:
  mode: AlwaysAllow
clusterDomain: "cluster.local"
clusterDNS:
  - "10.0.0.10"
resolvConf: "/etc/resolv.conf"
runtimeRequestTimeout: "15m"
cgroupDriver: "cgroupfs"
failSwapOn: false
serverTLSBootstrap: true
containerRuntimeEndpoint: "unix:///run/containerd/containerd.sock"
staticPodPath: "/etc/kubernetes/manifests"
EOF

# Create necessary directories for kubelet
echo "Creating kubelet directories..."
sudo mkdir -p /var/lib/kubelet
sudo mkdir -p /etc/kubernetes/manifests
sudo mkdir -p /var/log/kubernetes

# Generate CA certificate for kubelet
echo "Generating CA certificate for kubelet..."
openssl genrsa -out /tmp/ca.key 2048
openssl req -x509 -new -nodes -key /tmp/ca.key -subj "/CN=kubelet-ca" -days 365 -out /tmp/ca.crt
sudo cp /tmp/ca.crt /var/lib/kubelet/ca.crt

# Create kubelet kubeconfig
cat << EOF | sudo tee /var/lib/kubelet/kubeconfig
apiVersion: v1
kind: Config
clusters:
- cluster:
    insecure-skip-tls-verify: true
    server: https://127.0.0.1:6443
  name: local
contexts:
- context:
    cluster: local
    user: kubelet
  name: kubelet-context
current-context: kubelet-context
users:
- name: kubelet
  user:
    token: "1234567890"
EOF

# Start kubelet
echo "Starting kubelet..."
sudo kubebuilder/bin/kubelet \
    --kubeconfig=/var/lib/kubelet/kubeconfig \
    --config=/var/lib/kubelet/config.yaml \
    --root-dir=/var/lib/kubelet \
    --cert-dir=/var/lib/kubelet/pki \
    --hostname-override=codespaces-77e311 \
    --node-ip=$HOST_IP \
    --register-with-taints=node-role.kubernetes.io/control-plane:NoSchedule \
    --v=2 &

# Wait for kubelet to be ready
sudo kubebuilder/bin/kubectl get nodes --kubeconfig=/var/lib/kubelet/kubeconfig
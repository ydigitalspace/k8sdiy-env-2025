## K3S Bootstrap 
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true sh -
##
sudo k3s server --snapshotter native&
##
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml 
sudo chmod o+r /etc/rancher/k3s/k3s.yaml
##
alias k=kubectl
go install github.com/kubecolor/kubecolor@latest
alias kubectl=kubecolor
compdef kubecolor=kubectl
curl -sS https://webi.sh/k9s | sh
alias kk="EDITOR='code --wait' k9s"


# Disables IPv6 for Docker and installs K3S
#
# sudo tee /etc/docker/daemon.json >/dev/null <<-EOF
# {
#   "ip6tables": false,
#   "ipv6": false
# }
# EOF
# sudo pkill dockerd && sudo pkill containerd
# bash /usr/local/share/docker-init.sh
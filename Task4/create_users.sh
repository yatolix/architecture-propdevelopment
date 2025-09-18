kubectl config view --raw -o jsonpath='{.clusters[?(@.name=="docker-desktop")].cluster.certificate-authority-data}' | base64 -d > ca.crt

# Create developer user in group 'developers' using developer-csr.conf
openssl genrsa -out developer.key 2048
openssl req -new -key developer.key -out developer.csr -config developer-csr.conf

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: developer-csr
spec:
  request: $(cat developer.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # 10 days
  usages:
  - client auth
EOF

kubectl certificate approve developer-csr
kubectl get csr developer-csr -o jsonpath='{.status.certificate}' | base64 -d > developer.crt

kubectl config set-cluster docker-desktop \
  --certificate-authority=ca.crt \
  --server=https://kubernetes.docker.internal:6443 \
  --kubeconfig=developer-config

kubectl config set-credentials developer \
  --client-certificate=developer.crt \
  --client-key=developer.key \
  --kubeconfig=developer-config

kubectl config set-context developer-context \
  --cluster=docker-desktop \
  --user=developer \
  --namespace=default \
  --kubeconfig=developer-config


# Create devops user in group 'devops-engineers' using devops-csr.conf
openssl genrsa -out devops.key 2048
openssl req -new -key devops.key -out devops.csr -config devops-csr.conf

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: devops-csr
spec:
  request: $(cat devops.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # 10 days
  usages:
  - client auth
EOF

kubectl certificate approve devops-csr
kubectl get csr devops-csr -o jsonpath='{.status.certificate}' | base64 -d > devops.crt

kubectl config set-cluster docker-desktop \
  --certificate-authority=ca.crt \
  --server=https://kubernetes.docker.internal:6443 \
  --kubeconfig=devops-config

kubectl config set-credentials devops \
  --client-certificate=devops.crt \
  --client-key=devops.key \
  --kubeconfig=devops-config

kubectl config set-context devops-context \
  --cluster=docker-desktop \
  --user=devops \
  --namespace=default \
  --kubeconfig=devops-config

# Create isec user in group 'isecs' using isec-csr.conf
openssl genrsa -out isec.key 2048
openssl req -new -key isec.key -out isec.csr -config isec-csr.conf

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: isec-csr
spec:
  request: $(cat isec.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # 10 days
  usages:
  - client auth
EOF

kubectl certificate approve isec-csr
kubectl get csr isec-csr -o jsonpath='{.status.certificate}' | base64 -d > isec.crt

kubectl config set-cluster docker-desktop \
  --certificate-authority=ca.crt \
  --server=https://kubernetes.docker.internal:6443 \
  --kubeconfig=isec-config

kubectl config set-credentials isec \
  --client-certificate=isec.crt \
  --client-key=isec.key \
  --kubeconfig=isec-config

kubectl config set-context isec-context \
  --cluster=docker-desktop \
  --user=isec \
  --namespace=default \
  --kubeconfig=isec-config
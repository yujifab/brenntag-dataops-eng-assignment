# brenntag-dataops-eng-assignment
made by Fabio Yuji Ivamoto

# Requirements
1. Install Minikube
2. Install Docker
3. Install Helm
4. Install Helm Dashboard 
5. Install https://min.io/download#/kubernetes

# Minikube initialization
1. `minikube start`

# Helm dashboard
1. `helm plugin install https://github.com/komodorio/helm-dashboard.git`
2. UI starter ` helm dashboard`

# Trino configuration
0. Check you K8S cluster: `kubectl cluster-info`
1. add trino repo: `helm repo add trino https://trinodb.github.io/charts`
2. Install Trino cluster: `helm install example-trino-cluster trino/trino`
3. Port forward: 


`export POD_NAME=$(kubectl get pods --namespace default -l "app=trino,release=example-trino-cluster,component=coordinator" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080`

# Clean Up environment
1. `helm uninstall example-trino-cluster`
2. `helm plugin uninstall dashboard`
2. verifying current pods ` helm uninstall example-trino-clusterk`
3. `minikube delete --all
`


# REFS

1. https://trino.io/docs/current/installation/kubernetes.html#running-a-local-kubernetes-cluster-with-kind
2. https://minikube.sigs.k8s.io/docs/start/
3. https://github.com/komodorio/helm-dashboard
4. https://min.io/download#/kubernetes
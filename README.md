# brenntag-dataops-eng-assignment
made by Fabio Yuji Ivamoto

# Requirements
1. Install Minikube (or any K8s provider)
   1. `minikube start`
   2. `minikube dashboard`
2. Install Docker
3. Install Helm
4. Install Helm Dashboard
   1. `helm plugin install https://github.com/komodorio/helm-dashboard.git`
   2. `helm dashboard --port 8180`


# Kubernetes Configuration
1. in order to the cluster pull images from the Docker Hub registry, you have to configure the secrets as follow:
```
kubectl create secret docker-registry my-dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=your-dockerhub-username \
  --docker-password=your-dockerhub-password \
  --docker-email=your-email@example.com

```
2. enable ingress to pull images from internet `minikube addons enable ingress`
# Initial setup
1. run `sh deployments/scripts/up.sh`
2. `kubectl expose deployment my-minio --name=my-minio`
3. `kubectl expose deployment`
# Trino configuration
1. Check you K8S cluster: `kubectl cluster-info`
2. add trino repo: `helm repo add trino https://trinodb.github.io/charts`
3. Install Trino cluster: `helm install brenntag-trino-cluster trino/trino`
4. Port forward: 


`export POD_NAME=$(kubectl get pods --namespace default -l "app=trino,release=brenntag-trino-cluster,component=coordinator" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080`

# Minio Configuration
1. `export ROOT_USER=$(kubectl get secret --namespace default my-minio -o jsonpath="{.data.root-user}" | base64 -d)`
admin
2. `export ROOT_PASSWORD=$(kubectl get secret --namespace default my-minio -o jsonpath="{.data.root-password}" | base64 -d)`
2UAboLpB21
3. 
``` 
kubectl run --namespace default my-minio-client \ 
     --rm --tty -i --restart='Never' \
     --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
     --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
     --env MINIO_SERVER_HOST=my-minio \
     --image docker.io/bitnami/minio-client:2023.9.29-debian-11-r0 -- admin info minio
``` 



# Application Build
1. `docker build --tag python-docker .`

# Application Local test
1. Create a bridge network
`docker network create brenntag-network`

2. Start minio environment via Docker
```
mkdir -p ~/minio/data

docker run \
   -p 9000:9000 \
   -p 9090:9090 \
   --name minio \
   -v ~/minio/data:/data \
   -e "MINIO_ROOT_USER=ROOTNAME" \
   -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
   --network brenntag-network \
   quay.io/minio/minio server /data --console-address ":9090"
```

3. Start the application
```

docker build \
    -t brenntag_api_csv \
    --no-cache \
    ./app

```
`docker run --name my-flask-app -p 5001:5001 --network brenntag-network -d brenntag_api_csv`

4. Check the services running via browser
![local containers](./img/local_containers.png)

![minio browser](./img/minio_browser.png)
![app browser](./img/flask_browser.png)

5. Upload a csv file

![file_uploaded](./img/file_upload.png)


6. Check Bucket in Minio

![bucket_check](./img/bucket_browser.png)


# Clean Up environment
1. `sh down.sh`
2. `helm plugin uninstall dashboard`
3. verifying current pods ` helm uninstall brenntag-trino-cluster`
4. `minikube delete --all
`


# REFS

1. https://trino.io/docs/current/installation/kubernetes.html#running-a-local-kubernetes-cluster-with-kind
2. https://minikube.sigs.k8s.io/docs/start/
3. https://github.com/komodorio/helm-dashboard
4. https://min.io/download#/kubernetes
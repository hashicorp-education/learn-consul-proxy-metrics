terraform init
terraform apply --auto-approve
# wait 15 minutes for build

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw kubernetes_cluster_id)

helm install --values helm/values-v1.yaml consul hashicorp/consul --create-namespace --namespace consul --version "1.2.0"

kubectl apply --filename hashicups/

export CONSUL_HTTP_TOKEN=$(kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d) && \
export CONSUL_HTTP_ADDR=https://$(kubectl get services/consul-ui --namespace consul -o jsonpath='{.status.loadBalancer.ingress[0].hostname}') && \
export CONSUL_HTTP_SSL_VERIFY=false && \
export CONSUL_APIGW_ADDR=http://$(kubectl get svc/api-gateway -o json | jq -r '.status.loadBalancer.ingress[0].hostname') 

consul catalog services

kubectl apply -f proxy/proxy-defaults.yaml

kubectl delete --filename hashicups/ && \
kubectl apply --filename hashicups/

./install-grafana-stack.sh

kubectl port-forward svc/grafana-agent 8080:80


echo $CONSUL_APIGW_ADDR
# Go to API gateway URL and see only frontend part of application is available

cp -f hashicups-ecs/ecs-services-and-tasks-with-consul.tf ecs-services-and-tasks.tf

terraform init
terraform apply --auto-approve

consul catalog services
# notice now all (6) of the hashicups microservices are in the mesh

echo $CONSUL_APIGW_ADDR
# Go to API gateway URL and see the whole application works
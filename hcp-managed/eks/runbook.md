terraform init
terraform apply --auto-approve
# wait 10-15 minutes for build

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw kubernetes_cluster_id)

export CONSUL_HTTP_TOKEN=$(terraform output -raw consul_root_token) && \
export CONSUL_HTTP_ADDR=$(terraform output -raw consul_url)

# Notice that Consul services exist
consul catalog services

# Go to Grafana URL
export GRAFANA_URL=http://$(kubectl get svc/grafana --namespace observability -o json | jq -r '.status.loadBalancer.ingress[0].hostname') && \
echo $GRAFANA_URL
# Check out metrics/logs/traces

# Go to API gateway URL
export CONSUL_APIGW_ADDR=http://$(kubectl get svc/api-gateway -o json | jq -r '.status.loadBalancer.ingress[0].hostname') && \
echo $CONSUL_APIGW_ADDR
# Explore HashiCups to generate traffic


# For troubleshooting
kubectl port-forward svc/prometheus-server -n observability 8080:80


echo $CONSUL_HTTP_ADDR
# check out Consul

consul-k8s upgrade -config-file=helm/consul-v2.yaml
# upgrade Consul
helm repo add grafana https://grafana.github.io/helm-charts && \
helm repo update

kubectl create namespace grafana && \
helm install loki --values helm/loki.yaml grafana/loki-stack --version "2.9.9" --namespace grafana && \
kubectl rollout status statefulset loki --namespace grafana --timeout=300s && \

#mimir too resource intensive - install prometheus instead for this testing
#helm install mimir --values helm/mimir.yaml grafana/mimir-distributed --version "2.9.0" --namespace grafana && \
#helm install mimir grafana/mimir-distributed --namespace grafana
#kubectl rollout status statefulset mimir --namespace grafana --timeout=300s && \

helm install --values helm/prometheus.yaml prometheus prometheus-community/prometheus --version "15.5.3" --namespace grafana && \
kubectl rollout status deployment prometheus-server --namespace grafana --timeout=300s && \

#helm install grafana-agent --values helm/grafana-agent.yaml grafana/grafana-agent --version "0.35.3" && \
helm install grafana-agent --values helm/grafana-agent.yaml grafana/grafana-agent 
kubectl rollout status statefulset grafana-agent --namespace default --timeout=300s && \

#helm install --values helm/grafana.yaml grafana grafana/grafana --version "6.23.1" --namespace grafana && \
helm install --values helm/grafana.yaml grafana grafana/grafana --namespace grafana
kubectl rollout status deployment grafana --namespace default --timeout=300s && \

echo "#######################################" && \
echo "Observability Suite Deployment Complete" && \
echo "#######################################"
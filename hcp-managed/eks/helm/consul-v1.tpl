global:
  # The main enabled/disabled setting.
  # If true, servers, clients, Consul DNS and the Consul UI will be enabled.
  enabled: false
  # The prefix used for all resources created in the Helm chart.
  name: consul
  # The Consul version to use.
  image: "hashicorp/consul-enterprise:${consul_version}-ent"
  # The name of the datacenter that the agents should register as.
  datacenter: ${datacenter}
  # Enable Consul ACL engine
  acls:
    manageSystemACLs: true
    bootstrapToken:
      secretName: bootstrap-token
      secretKey: token
  # Enable TLS
  tls:
    enabled: true
  # Exposes Prometheus metrics for the Consul service mesh and sidecars.
  metrics:
    enabled: true
    # Enables Consul servers and clients metrics.
    enableAgentMetrics: true
    # Configures the retention time for metrics in Consul servers and clients.
    agentMetricsRetentionTime: "1m"

externalServers:
  enabled: true
  hosts: [${consul_hosts}]
  httpsPort: 443
  useSystemRoots: true
  k8sAuthMethodHost: ${k8s_api_endpoint}

server:
  enabled: false

connectInject:
  transparentProxy:
    defaultEnabled: true
  enabled: true
  apiGateway:
    manageExternalCRDs: true
    managedGatewayClass:
      serviceType: LoadBalancer
  default: true
  # Enables metrics for Consul Connect sidecars.
  metrics:
    defaultEnabled: true
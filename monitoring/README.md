# Monitoring Setup for EKS

This directory contains Terraform configuration to automatically deploy monitoring stack (Prometheus + Grafana) to your EKS cluster.

## What Gets Installed

- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization dashboards
- **AlertManager**: Alert management
- **Node Exporter**: Node-level metrics
- **Kube State Metrics**: Kubernetes resource metrics
- **Pre-configured dashboards**: For K8s monitoring

## Deployment

Monitoring is automatically deployed when you run:

```bash
cd infra/environments/prod
terraform init
terraform plan
terraform apply
```

## Access Grafana

After deployment, get the LoadBalancer URL:

```bash
kubectl get svc -n monitoring monitoring-grafana
```

Or use port-forward:

```bash
kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80
```

**Login credentials:**
- Username: `admin`
- Password: `admin123` (change in `infra/modules/eks/variables.tf`)

## Access Prometheus

```bash
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```

Visit: http://localhost:9090

## Customization

Edit `infra/modules/eks/monitoring.tf` to customize:
- Retention period (default: 7 days)
- Storage size (default: 20Gi for Prometheus, 10Gi for Grafana)
- Service type (default: LoadBalancer)

## Verify Installation

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

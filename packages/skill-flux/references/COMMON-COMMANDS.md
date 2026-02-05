# FluxCD Common Commands

Quick reference for frequently used `kubectl` and `flux` CLI commands.

## flux CLI Commands

### Installation & Verification

```bash
# Install Flux on cluster
flux install --namespace=flux-system

# Check Flux installation
flux check
flux version

# Get all Flux resources
flux get all -A
```

### Source Management

```bash
# Create GitRepository
flux create source git my-repo \
  --url=https://github.com/user/repo.git \
  --branch=main \
  --interval=5m

# Create HelmRepository
flux create source helm bitnami \
  --url=https://charts.bitnami.com/bitnami \
  --interval=1h

# Create OCIRepository
flux create source oci my-oci \
  --url=oci://ghcr.io/user/my-artifact \
  --tag=latest

# List sources
flux get sources all -A

# Reconcile source immediately
flux reconcile source git my-repo -n flux-config
```

### Sync Management

```bash
# Create Kustomization
flux create kustomization my-app \
  --source=my-repo \
  --path=./deploy \
  --prune=true \
  --interval=5m

# Create HelmRelease
flux create helmrelease my-app \
  --source=bitnami \
  --chart=nginx \
  --target-namespace=apps

# List sync resources
flux get kustomizations -A
flux get helmreleases -A

# Reconcile Kustomization
flux reconcile kustomization my-app -n flux-config

# Suspend reconciliation
flux suspend kustomization my-app -n flux-config

# Resume reconciliation
flux resume kustomization my-app -n flux-config
```

### Notification Management

```bash
# Create Receiver
flux create receiver my-webhook \
  --type=github \
  --event=push

# Create Provider
flux create provider slack my-slack \
  --type=slack \
  --channel=alerts

# Create Alert
flux create alert my-alert \
  --provider-ref=my-slack \
  --event-severity=error \
  --event-source=Kustomization
```

### Image Automation

```bash
# Create ImageRepository
flux create image repository my-image \
  --image=ghcr.io/user/my-app

# Create ImagePolicy
flux create image policy my-policy \
  --image-ref=my-image \
  --select-semver='>=1.0 <2.0'

# Create ImageUpdateAutomation
flux create image update my-automation \
  --git-repo-ref=my-repo \
  --git-repo-path=./clusters/prod \
  --checkout-branch=main \
  --push-branch=main
```

## kubectl Commands

### View Resources

```bash
# List all Flux resources
kubectl get fluxcd.io -A

# List by type
kubectl get gitrepository -A
kubectl get kustomization -A
kubectl get helmrelease -A
kubectl get imagerepository -A

# Detailed view
kubectl describe gitrepository my-repo -n flux-config

# Watch reconciliation
kubectl get kustomization -n flux-config -w

# Show specific field
kubectl get kustomization my-app -n flux-config \
  -o jsonpath='{.status.conditions[0]}'
```

### Status Checks

```bash
# Check condition status
kubectl get kustomization -n flux-config \
  -o custom-columns=NAME:.metadata.name,\
READY:.status.conditions[0].status,\
REASON:.status.conditions[0].reason

# Get last applied revision
kubectl get kustomization my-app -n flux-config \
  -o jsonpath='{.status.lastAppliedRevision}'

# Check artifact reference
kubectl get gitrepository my-repo -n flux-config \
  -o jsonpath='{.status.artifact.url}'
```

### Events

```bash
# List recent events
kubectl get events -n flux-config --sort-by='.lastTimestamp'

# Watch events in real-time
kubectl get events -n flux-config -w

# Events for specific resource
kubectl describe kustomization my-app -n flux-config | grep -A20 Events
```

### Log Access

```bash
# Flux controller logs
kubectl logs -n flux-system deployment/source-controller -f
kubectl logs -n flux-system deployment/helm-controller -f
kubectl logs -n flux-system deployment/kustomize-controller -f

# Get logs from specific pod
kubectl logs -n flux-system <pod-name> -c <container> -f

# Previous logs (after restart)
kubectl logs -n flux-system <pod-name> --previous
```

### Editing Resources

```bash
# Edit resource in place
kubectl edit kustomization my-app -n flux-config

# Patch resource
kubectl patch kustomization my-app -n flux-config \
  --type merge -p '{"spec":{"interval":"10m"}}'

# Apply from stdin
cat <<EOF | kubectl apply -f -
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: my-app
  namespace: flux-config
spec:
  sourceRef:
    name: my-repo
  path: ./deploy
EOF
```

### Resource Management

```bash
# Export resource
kubectl get kustomization my-app -n flux-config -o yaml

# Get specific field
kubectl get helmrelease my-app -n app-namespace \
  -o jsonpath='{.spec.values}'

# Delete resource
kubectl delete kustomization my-app -n flux-config

# Delete all Kustomizations in namespace
kubectl delete kustomization -n flux-config --all
```

### Annotations

```bash
# Force reconciliation
kubectl annotate kustomization my-app -n flux-config \
  fluxcd.io/reconcile=manual --overwrite

# Remove annotation
kubectl annotate kustomization my-app -n flux-config \
  fluxcd.io/reconcile-

# Add custom annotation
kubectl annotate kustomization my-app -n flux-config \
  managed-by=platform-team --overwrite
```

### Debugging

```bash
# Describe with full details
kubectl describe kustomization my-app -n flux-config

# Export for analysis
kubectl get kustomization my-app -n flux-config -o yaml > my-app.yaml

# Check resource state
kubectl get all -n flux-system

# Resource limits
kubectl top nodes
kubectl top pods -n flux-system

# Debug pod
kubectl debug -it deployment/source-controller -n flux-system
```

## Helm Integration

### When Using HelmRelease

```bash
# Check release
helm list -n app-namespace
helm history my-app -n app-namespace

# Get current values
helm get values my-app -n app-namespace

# Get manifest
helm get manifest my-app -n app-namespace

# Test values rendering
helm template my-app bitnami/nginx

# Get chart info
helm search repo bitnami/nginx
```

## Kustomize Integration

### When Using Kustomization

```bash
# Build locally
kustomize build ./deploy

# Validate
kustomize build ./deploy | kubectl apply --dry-run=client -f -

# Build with patches
kustomize build ./deploy/overlays/prod

# Kustomize version
kustomize version
```

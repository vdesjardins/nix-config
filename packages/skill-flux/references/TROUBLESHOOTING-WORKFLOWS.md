# FluxCD Troubleshooting Workflows

Step-by-step procedures for diagnosing and resolving common Flux issues.

## Verification & Testing

### Verify GitRepository is Ready

```bash
# Check status
kubectl get gitrepository -n flux-config
kubectl describe gitrepository my-repo -n flux-config

# Should show:
# status.conditions[0].type: Ready
# status.conditions[0].status: "True"
# status.artifact.url: <recent commit hash>
```

### Check HelmRelease Deployment Status

```bash
# Get HelmRelease status
kubectl get helmrelease -n app-namespace
kubectl describe helmrelease my-app -n app-namespace

# View release history
helm list -n app-namespace
helm history my-app -n app-namespace

# Check actual deployed values
helm get values my-app -n app-namespace
```

### Debug ImageUpdateAutomation Failures

```bash
# Check if image was detected
kubectl get imagerepository -n flux-system
kubectl describe imagerepository my-image -n flux-system

# View the policy match
kubectl get imagepolicy -n flux-system
kubectl describe imagepolicy my-policy -n flux-system

# Check automation run history
kubectl logs -n flux-system deployment/image-automation-controller -f
```

## Common Failure Scenarios

### Scenario 1: GitRepository Not Ready

**Symptoms**: GitRepository stuck in "False" Ready state

```bash
# 1. Describe the resource
kubectl describe gitrepository my-repo -n flux-config

# Look for condition.reason:
# - "AuthenticationFailed" -> SSH key or HTTP auth issue
# - "GitOperationFailed" -> Git operation (clone/fetch) failed
# - "SourceVerificationFailed" -> Signature verification failed
```

**SSH Key Issues**:

```bash
# Verify secret exists and has sshkey field
kubectl get secret -n flux-config
kubectl describe secret git-credentials -n flux-config

# Test SSH manually from controller pod
kubectl run -it --rm debug --image=alpine/fluxcd:latest \
  --restart=Never -- sh

# Inside pod
ssh -i /etc/gitops/ssh/identity git@github.com
```

**HTTP Auth Issues**:

```bash
# For HTTP, verify secret has username/password fields
kubectl get secret -n flux-config git-http-auth -o yaml

# Test HTTP access
curl -u username:password https://git.example.com/repo.git/info/refs
```

**Network/Firewall**:

```bash
# Check if repository is reachable from cluster
kubectl run -it --rm debug --image=alpine/fluxcd:latest \
  --restart=Never -- sh

# Inside pod
ping github.com
telnet github.com 22  # For SSH
curl https://github.com  # For HTTPS
```

### Scenario 2: HelmRelease Stuck in Progressing

**Symptoms**: HelmRelease shows "Progressing" but never completes

```bash
# Check detailed status
kubectl describe helmrelease my-app -n app-namespace

# Look in status.conditions for:
# - "SourceNotReady" -> Referenced HelmChart or HelmRepository not ready
# - "TestFailed" -> Helm tests failing
# - "HealthCheckFailed" -> Pod readiness/liveness checks failing
```

**HelmChart Not Ready**:

```bash
# 1. Verify HelmChart exists
kubectl get helmchart -n flux-system

# 2. Check HelmRepository status
kubectl get helmrepository -n flux-system
kubectl describe helmrepository bitnami -n flux-system

# 3. Check if chart exists in repository
helm search repo bitnami/nginx
```

**Chart Installation Timeout**:

```bash
# Increase timeout in HelmRelease
kubectl patch helmrelease my-app -n app-namespace \
  --type merge -p '{"spec":{"timeout":"10m"}}'

# Check helm operations directly
helm get values my-app -n app-namespace
helm history my-app -n app-namespace
```

**Pod Health Checks**:

```bash
# Check if pods are actually running
kubectl get pods -n app-namespace
kubectl describe pod <pod-name> -n app-namespace

# Check pod logs
kubectl logs <pod-name> -n app-namespace

# Check readiness/liveness probe failures
kubectl describe pod <pod-name> -n app-namespace | grep -A5 Conditions
```

### Scenario 3: Kustomization Validation Error

**Symptoms**: Kustomization shows reconciliation failed with validation errors

```bash
# Check error message
kubectl describe kustomization my-app -n flux-config

# Look for reason:
# - "ValidationFailed" -> Kustomize validation failed
# - "GenerateFailed" -> Kustomize generation failed
# - "InvalidKustomization" -> Invalid kustomization.yaml
```

**Test Kustomization Locally**:

```bash
# Get the kustomization from Git
git clone <repo>
cd clusters/prod/apps/my-app

# Test locally
kustomize build .
kustomize build . | kubectl apply --dry-run=client -f -
```

**Debug in Cluster**:

```bash
# Check controller logs
kubectl logs -n flux-system deployment/kustomize-controller -f

# Get kustomization source
kubectl get kustomization my-app -n flux-config -o yaml | \
  grep -A5 sourceRef

# Manually apply from Git commit
kubectl apply -k git+https://github.com/user/repo/clusters/prod/apps/my-app@main
```

### Scenario 4: Image Repository Scan Failure

**Symptoms**: ImageRepository shows scan failures, no images discovered

```bash
# Check ImageRepository status
kubectl describe imagerepository my-image -n flux-system

# Look in status.conditions for:
# - "ScanFailed" -> Registry scan failed
# - "DependencyNotReady" -> Secret credentials not found
```

**Registry Access Issues**:

```bash
# Verify secret exists
kubectl get secret -n flux-system
kubectl describe secret registry-credentials -n flux-system

# Test registry access manually
kubectl run -it --rm debug --image=curlimages/curl:latest \
  --restart=Never -- sh

# Inside pod
curl -u username:password https://registry.io/v2/my-image/tags/list
```

**Private Registry**:

```bash
# Create registry credentials secret
kubectl create secret docker-registry regcred \
  --docker-server=registry.io \
  --docker-username=user \
  --docker-password=pass \
  -n flux-system

# Reference in ImageRepository
kubectl patch imagerepository my-image -n flux-system \
  --type merge -p '{"spec":{"secretRef":{"name":"regcred"}}}'
```

## General Debugging Commands

### Check Flux System Health

```bash
# All resources in flux-system
kubectl get all -n flux-system

# Flux custom resources
kubectl get fluxcd.io -n flux-system

# Recent events
kubectl get events -n flux-system --sort-by=.metadata.creationTimestamp
```

### Review Controller Logs

```bash
# Source Controller
kubectl logs -n flux-system deployment/source-controller -f

# Kustomize Controller
kubectl logs -n flux-system deployment/kustomize-controller -f

# Helm Controller
kubectl logs -n flux-system deployment/helm-controller -f

# Notification Controller
kubectl logs -n flux-system deployment/notification-controller -f

# Image Reflector Controller
kubectl logs -n flux-system deployment/image-reflector-controller -f

# Image Automation Controller
kubectl logs -n flux-system deployment/image-automation-controller -f
```

### Export for Analysis

```bash
# Export all Flux resources for inspection
kubectl get fluxcd.io -A -o yaml > flux-resources.yaml

# Export specific resource
kubectl get kustomization my-app -n flux-config -o yaml

# Export with conditions visible
kubectl get kustomization -A -o \
  jsonpath='{range .items[*]}{.metadata.name}{"\t"}' \
  '{.status.conditions[0].reason}{"\n"}{end}'
```

### Manual Reconciliation

```bash
# Force immediate reconciliation
kubectl annotate kustomization my-app -n flux-config \
  fluxcd.io/reconcile=manual --overwrite

# Check reconciliation result
kubectl describe kustomization my-app -n flux-config
```

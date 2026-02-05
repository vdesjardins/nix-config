---
name: flux
description: >-
  FluxCD is the standard GitOps approach for Kubernetes - diagnose issues,
  manage resources, and optimize deployments using declarative configuration
  synced from Git
---

# FluxCD Skill

FluxCD is the standard GitOps tool for Kubernetes. It continuously reconciles
desired state from Git repositories with actual cluster state. Use this skill
when:

- Troubleshooting Flux reconciliation failures or synchronization issues
- Managing Flux custom resources (GitRepository, HelmRepository,
  Kustomization, HelmRelease)
- Analyzing and fixing pod/deployment issues in Flux-managed clusters
- Debugging webhook receivers and automation flows
- Optimizing image automation and deployment strategies
- Understanding cluster state and reconciliation status

## Core Concepts

**Flux Architecture**: FluxCD operates as controllers within Kubernetes that
reconcile desired state (from Git) with actual cluster state. The primary
components are:

- **Source Controllers**: Pull configuration and charts from Git/OCI registries
  - GitRepository: Watch and fetch from Git repositories
  - OCIRepository: Fetch from OCI registries
  - HelmRepository: Index Helm charts from repositories

- **Sync Controllers**: Apply configuration to the cluster
  - Kustomization: Apply Kustomize overlays declaratively
  - HelmRelease: Deploy and manage Helm charts with templating

- **Notification & Webhooks**:
  - Receiver: Webhook endpoint for Git push notifications
  - Provider: Configure notification destinations
  - Alert: Monitor resource status changes

- **Image Automation**:
  - ImageRepository: Poll container registries
  - ImagePolicy: Define versioning policies (semver, alphabetical, etc.)
  - ImageUpdateAutomation: Automatically commit image updates to Git

## Troubleshooting Workflow

1. **Identify the resource type**: Determine which Flux resource is failing
   (GitRepository, HelmRelease, Kustomization, etc.)

2. **Get resource status**: Check the custom resource's status conditions and
   lastObservedGeneration

3. **Review logs**: Examine controller logs for reconciliation errors or
   warnings

4. **Check dependencies**: Verify source resources (GitRepository,
   HelmRepository) are ready before sync resources

5. **Analyze events**: Look at Kubernetes events for more context on failures

6. **Check Git/Registry**: Validate that referenced Git branches, OCI
   registries, or Helm repos are accessible

## Common Issues and Patterns

### GitRepository Failures

- **Authentication**: SSH keys or credentials misconfigured
- **Branch/ref**: Target branch doesn't exist or is wrong
- **Network**: Repository unreachable or firewall blocked
- **Secrets**: GitRepository can't find SSH keys or HTTP auth secrets

### HelmRelease Failures

- **Chart not found**: HelmRepository not ready or chart doesn't exist
- **Values**: Chart values invalid or incompatible with installed version
- **Dependencies**: Chart dependencies not available
- **Secrets**: Release references secret that doesn't exist

### Kustomization Failures

- **Source not ready**: Referenced GitRepository hasn't synced yet
- **Validation**: Kustomize validation errors in the overlay
- **RBAC**: Controller doesn't have permissions to apply resources
- **Reconciliation**: Resource conflicts or immutable field changes

### Image Automation

- **Scan failures**: ImageRepository can't access registry
- **Policy matching**: No tags match the version policy
- **Git operations**: Can't push image update commits to repository
- **Permission**: Missing write access to Git repo for automation commits

## Key Commands for Analysis

When analyzing a Flux-managed cluster:

1. List all Flux resources: `kubectl get fluxcd.io` or check specific types
2. Describe a resource: `kubectl describe <resource-type> <name> -n
   <namespace>`
3. View status conditions: Look at `.status.conditions` array
4. Check recent events: `kubectl describe <resource> -n <namespace>` (shows
   events)
5. Review controller logs: `kubectl logs -n flux-system deploy/<controller>
   -f`
6. Validate Git sync: Check the commit hash in status matches Git
7. Test Helm chart: Use `helm template` to validate rendering

## Integration Points

- **Git repositories**: Source of truth for all configuration
- **Container registries**: Image sources for workloads
- **Helm repositories**: Chart repositories for package management
- **Kubernetes API**: All resources apply via standard kubectl
- **Webhooks**: Git platforms trigger Flux reconciliation via receivers

## References

See the `references/` directory for detailed documentation:

- **FLUX-API-REFERENCE.md**: Complete API reference for all FluxCD custom
  resources (GitRepository, HelmRelease, Kustomization, ImagePolicy, etc.)
  with field descriptions, examples, and status conditions
- **BEST-PRACTICES.md**: Production deployment patterns and optimization
  strategies
- **TROUBLESHOOTING-WORKFLOWS.md**: Step-by-step diagnostic procedures for
  common failure scenarios
- **COMMON-COMMANDS.md**: kubectl and flux CLI command reference

# FluxCD Best Practices

Production-ready patterns for deploying and maintaining Flux-managed clusters.

## Organization & Structure

### Namespace Strategy

- **flux-system**: Controllers and operators (managed by Flux itself)
- **flux-config**: Flux custom resources that define reconciliation
- **app-***: Application namespaces (one per logical application grouping)

Use namespace labels to organize resources by team or environment:

```yaml
namespaces:
  prod: "true"
  team: platform
```

### Repository Structure

Organize Git repositories for optimal Flux reconciliation:

```tree
.
├── clusters/
│   ├── prod/
│   │   ├── flux-system/
│   │   ├── kustomization.yaml
│   │   └── sources/
│   └── staging/
├── apps/
│   ├── app-a/
│   │   ├── base/
│   │   └── overlays/
│   └── app-b/
└── infrastructure/
    ├── monitoring/
    └── logging/
```

## Reconciliation Optimization

### Interval Configuration

- **Source refresh**: 5-10 minutes for stable repos (longer = less API calls)
- **Kustomization sync**: 5-10 minutes for stability
- **Image scan**: 1 hour for ImageRepository polling
- **Critical paths**: 1 minute for frequently changing configs

Use longer intervals for stable infrastructure, shorter for active development.

### Retry Strategy

Configure sensible retry policies to handle transient failures:

```yaml
spec:
  retryInterval: 5m
  timeout: 5m
```

Exponential backoff prevents cascading failures during outages.

## Security Best Practices

### Credential Management

- **SSH keys**: Store in Kubernetes secrets, reference via `secretRef`
- **HTTP auth**: Use tokens, not passwords; rotate regularly
- **Image pull secrets**: Configure for private container registries
- **TLS**: Enable TLS verification for all remote connections

### RBAC

- Limit Flux service account to minimal permissions
- Use `serviceAccountName` to run Kustomization/HelmRelease with specific SA
- Audit Flux resource changes via admission webhooks

### Secret Encryption

- Use SOPS or sealed-secrets for sensitive Git-stored secrets
- Configure secret decryption keys in flux-system namespace
- Never commit unencrypted secrets to Git

## Image Automation

### ImageUpdateAutomation Strategy

Automate image updates safely:

```yaml
spec:
  sourceRef:
    name: my-repo
  git:
    commit:
      author:
        name: "Flux Automation"
        email: "flux@example.com"
  update:
    strategy: Setters
    path: ./deploy
  interval: 1h
```

- Use `Setters` strategy for kustomization.yaml markers
- `Patch` strategy for strategic merge patches
- Commit frequency: Once per hour or per update batch

### Policy Selection

Choose appropriate ImagePolicy types:

- **semver**: For semantic versioning tags (`v1.2.3`)
- **alphabetical**: For alphabetical ordering (older < newer)
- **numerical**: For numeric versions
- **regex**: For custom patterns with capture groups

## High Availability

### Multi-Cluster Setup

- Deploy Flux to multiple clusters with identical configs
- Use Git branches for cluster-specific overrides
- Enable cross-cluster reconciliation if needed

### Controller Redundancy

- Run multiple Flux controller replicas
- Use pod anti-affinity to spread across nodes
- Set resource requests/limits appropriately

## Monitoring & Alerting

### Key Metrics to Track

- **Reconciliation success rate**: Alert on < 95%
- **Reconciliation duration**: Baseline and alert on increases
- **Git sync lag**: Time between Git commit and reconciliation
- **Resource count**: Alert on unexpected changes
- **Error rates**: By resource type and namespace

### Alert Examples

```yaml
spec:
  eventSeverity: error
  eventSources:
    - kind: Kustomization
    - kind: HelmRelease
  suspend: false
```

Send alerts to Slack/Teams for:

- Failed reconciliation
- Repeated retry attempts
- Controller restarts
- Image scan failures

## Troubleshooting Preparation

### Logging Strategy

- Enable debug logging on controllers during investigation
- Retain historical logs (7+ days minimum)
- Correlate logs across source and sync controllers

### Documentation

- Document custom resources and their purpose
- Keep runbooks for common failures
- Document GitOps workflow for team
- Version control all Flux configuration

## Testing & Validation

### Pre-Deployment Testing

1. Test Kustomize overlays locally: `kustomize build`
2. Validate Helm charts: `helm template`
3. Test GitRepository with `flux create source git --dry-run`
4. Validate resources: `kubectl apply --dry-run=client -f`

### Staged Rollout

- Deploy to development cluster first
- Validate for 24+ hours in dev
- Use Git branches for cluster-specific testing
- Automate promotion between environments

## Upgrade & Maintenance

### Flux Updates

1. Test updates in non-production cluster first
2. Review release notes for breaking changes
3. Plan maintenance window if needed
4. Update CRDs before controllers
5. Monitor reconciliation during and after upgrade

### CRD Management

- Keep CRD versions current with controllers
- Use `--install-crds` flag in HelmRelease for chart CRDs
- Test CRD upgrades don't break existing resources

## Performance Optimization

### Resource Limits

Set appropriate requests/limits on Flux deployments:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 64Mi
  limits:
    cpu: 500m
    memory: 256Mi
```

Adjust based on cluster size and reconciliation frequency.

### Large Deployments

For clusters with many resources:

- Split large Kustomizations into smaller ones
- Use multiple Kustomizations instead of one monolithic one
- Increase controller memory limits
- Adjust API server query timeout

## Disaster Recovery

### Backup Strategy

- Back up Flux configuration in Git (primary backup)
- Back up custom resources and secrets separately
- Test recovery procedures regularly
- Document Flux re-initialization procedure

### Recovery Procedure

1. Restore flux-system namespace
2. Re-initialize Flux
3. Git repositories will re-sync automatically
4. Verify reconciliation status
5. Monitor for 30+ minutes

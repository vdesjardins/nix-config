# FluxCD API Reference

This directory contains reference documentation for FluxCD components and
custom resources.

## Source Controllers

Source Controllers manage the retrieval of artifacts from external systems:

### GitRepository

Watches and fetches from Git repositories. Key fields:

- `spec.url`: Git repository URL (HTTP or SSH)
- `spec.ref`: Git reference (branch, tag, semver, or commit)
- `spec.secretRef`: Secret containing credentials (SSH or HTTP auth)
- `spec.interval`: Reconciliation interval (e.g., 1m, 5m)
- `status.artifact`: Reference to latest fetched artifact
- `status.conditions`: Array of reconciliation status conditions

Example use cases:

- Fetch manifests from main branch every 5 minutes
- Monitor a specific Git tag for releases
- Use SSH key authentication for private repositories

### HelmRepository

Indexes Helm charts from repositories:

- `spec.url`: Helm repository URL (HTTP)
- `spec.type`: "oci" for OCI registries or omitted for HTTP
- `spec.secretRef`: Credentials for private repositories
- `spec.interval`: Index refresh interval
- `status.url`: Resolved repository URL
- `status.conditions`: Repository readiness conditions

Common patterns:

- Index public Helm repositories (bitnami, jetstack, etc.)
- Use private Helm repositories with authentication
- Point to OCI registries for Helm charts

### OCIRepository

Fetch artifacts from OCI registries:

- `spec.url`: OCI artifact URL (e.g., oci://registry.io/path/artifact:tag)
- `spec.ref`: Reference constraint (tag, semver pattern, or digest)
- `spec.secretRef`: Registry credentials
- `status.artifact`: Latest fetched artifact information

Use when:

- Distributing Flux configurations as OCI artifacts
- Using container registries as Helm chart repositories
- Versioning and distributing custom packages

### HelmChart

Searches for and fetches Helm charts from HelmRepository sources:

- `spec.chart`: Chart name in the repository
- `spec.sourceRef`: Reference to HelmRepository source
- `spec.version`: Version constraint (semver, "*", or exact version)
- `status.artifact`: Fetched chart artifact reference

Typical usage:

- Define which charts to fetch from indexed repositories
- Specify version constraints for automatic updates
- Referenced by HelmRelease resources

## Sync Controllers

### Kustomization

Applies Kustomize overlays to the cluster:

- `spec.interval`: Reconciliation interval
- `spec.sourceRef`: Reference to GitRepository source
- `spec.path`: Path to Kustomization in repository
- `spec.prune`: Delete resources removed from Git
- `spec.retryInterval`: Retry failed reconciliations
- `spec.timeout`: Timeout for apply operations
- `spec.validation`: Resource validation strategy
- `status.conditions`: Reconciliation status
- `status.lastAppliedRevision`: Last Git revision applied

Key patterns:

- Apply Kustomize overlays from different directories
- Enable pruning to clean up removed resources
- Use validation to catch errors before applying
- Reference custom resources for dependencies

### HelmRelease

Installs and manages Helm releases:

- `spec.chart`: HelmChart reference
- `spec.interval`: Reconciliation interval
- `spec.values`: Helm values as YAML
- `spec.valuesFrom`: References to ConfigMaps/Secrets for values
- `spec.install`: Installation configuration (remediation, crds)
- `spec.upgrade`: Upgrade configuration (crds, force, cleanupOnFail)
- `spec.rollback`: Rollback configuration on failure
- `spec.uninstall`: Uninstall configuration
- `status.history`: Release history with revisions
- `status.conditions`: HelmRelease status conditions

Common scenarios:

- Install application charts with custom values
- Automatically upgrade charts on new versions
- Reference Secrets for sensitive configuration
- Configure automatic rollback on upgrade failures

## Notification Controllers

### Receiver

Webhook endpoint for Git platform notifications:

- `spec.type`: Webhook type (github, gitlab, bitbucket, gitea, generic)
- `spec.events`: List of events to listen for
- `spec.secretRef`: Secret containing webhook token/secret
- `spec.suspend`: Pause webhook processing
- `status.url`: Public webhook URL
- `status.webhookPath`: Path component of webhook URL

Implementation:

- GitHub: Webhook secret in receiver secret
- GitLab: Webhook token in receiver secret
- Generic: Custom webhook signatures

### Provider

Notification destination configuration:

- `spec.type`: Notification type (slack, discord, teams, webhook, etc.)
- `spec.channel`: Channel identifier for service-specific routing
- `spec.address`: Webhook URL or service endpoint
- `spec.secretRef`: Credentials if needed
- `status.conditions`: Provider readiness

Supported providers:

- Slack, Discord, Microsoft Teams, Rocket.Chat
- Webhooks (generic HTTP endpoints)
- Alertmanager, OpsGenie, CloudEvents

### Alert

Monitors resource reconciliation status and sends notifications:

- `spec.providerRef`: Reference to Provider resource
- `spec.eventSeverity`: Minimum event severity to notify (info, warning,
  error)
- `spec.eventSources`: Resources to monitor (Kustomization, HelmRelease, etc.)
- `spec.suspend`: Pause alert processing
- `status.lastHandledReconcileAt`: Last reconciliation time

Use cases:

- Notify on Kustomization failures
- Alert when HelmRelease upgrades fail
- Track Flux system health

## Image Automation Controllers

### ImageRepository

Scans container registries for available image tags:

- `spec.image`: Container image to scan (e.g., docker.io/library/nginx)
- `spec.interval`: Scan interval
- `spec.secretRef`: Registry credentials if private
- `spec.timeout`: Scan operation timeout
- `status.lastScanResult`: Latest scan result with tag list
- `status.latestImage`: Most recent discovered image tag

### ImagePolicy

Determines which image tags to use based on policies:

- `spec.imageRepositoryRef`: Reference to ImageRepository
- `spec.policy`: Policy type (semver, alphabetical, numerical, regex)
- `spec.policy.<type>`: Policy-specific configuration
- `status.latestImage`: Image matching the policy
- `status.latestTag`: Tag matching the policy

Policy types:

- `semver`: Semantic versioning constraints (e.g., `^1.2.0`)
- `alphabetical`: Alphabetical ordering (older < newer)
- `numerical`: Numerical ordering
- `regex`: Custom regex pattern with capture groups

### ImageUpdateAutomation

Automatically commits image updates to Git:

- `spec.sourceRef`: Reference to GitRepository (branch to update)
- `spec.git`: Git configuration (author, commit message)
- `spec.update`: Update strategy and paths
- `spec.interval`: Commit interval
- `status.lastAutomationRunTime`: Last update attempt
- `status.conditions`: Automation status

Common configuration:

- Update image tags in kustomization.yaml or values files
- Configure git author information for commits
- Set commit message template for updates
- Combine with ImagePolicy to automate image updates

## API Versions

Current stable API versions:

- Source API: `v1` (stable)
- Kustomize API: `v1` (stable)
- Helm API: `v2` (stable, v1 deprecated)
- Notification API: `v1` (stable, v1beta3 available)
- Image Reflector API: `v1` (stable)
- Image Update Automation API: `v1` (stable)

All APIs are in the `fluxcd.io` API group.

## Common Status Fields

Most Flux resources follow this status structure:

```yaml
status:
  conditions:
    - type: Ready
      status: "True"
      reason: ReconciliationSucceeded
      message: "Reconciliation succeeded"
      lastTransitionTime: 2024-02-05T10:30:00Z
      observedGeneration: 1
  lastHandledReconcileAt: "2024-02-05T10:30:00Z"
  lastAttemptedRevision: "abc123def456"
  lastAppliedRevision: "abc123def456"
```

Condition types:

- `Ready`: Overall resource readiness
- `Stalled`: Resource processing stalled
- `Reconciling`: Currently reconciling (transient)

Reason codes include:

- `ReconciliationSucceeded`: Operation completed successfully
- `ReconciliationFailed`: Operation failed
- `ProgressingWithRetry`: Retrying failed operation
- `DependencyNotReady`: Dependency blocked processing

## Troubleshooting Reference

Common condition reasons and their meanings:

### Source Resources

- `GitOperationFailed`: Git operation (clone, fetch, pull) failed
- `ArtifactVerificationFailed`: Artifact integrity check failed
- `SourceVerificationFailed`: Signature verification failed (commits,
  artifacts)
- `Fetched`: Successfully fetched latest revision

### Sync Resources

- `ReconciliationFailed`: Apply operation failed
- `HealthCheckFailed`: Resource health checks failed
- `ProgressingWithRetry`: Waiting to retry after failure
- `RemediationFailed`: Automatic remediation attempt failed

### General

- `Suspended`: Resource processing is suspended
- `SourceNotReady`: Source dependency is not ready
- `ArtifactNotFound`: Referenced artifact doesn't exist

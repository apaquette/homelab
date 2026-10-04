# Roadmap

This document describes planned improvements beyond the completed v1.0 infrastructure migration.

The v1.0 milestone establishes the production baseline: the homelab has been migrated from Debian to NixOS, application services have been moved to native NixOS/systemd where appropriate, secrets are managed declaratively with sops-nix, and application backups are managed with Restic.

Future work is therefore focused primarily on **reliability, automation, observability, and infrastructure resilience** rather than completing the core migration.

## v1.0 — Completed

### Debian → NixOS migration

* Replaced the previous Debian host with NixOS.
* Introduced a flake-based system configuration.
* Added Disko for declarative storage configuration.
* Preserved the existing RAID-backed application and media data.
* Retained rollback paths throughout the migration.

### Native service migration

* Migrated application workloads from the legacy Docker/Compose deployment to native NixOS/systemd services.
* Preserved application state and existing service behaviour wherever practical.
* Declaratively configured service dependencies, storage paths, users, permissions, and networking.

### Infrastructure services

* Declarative Caddy reverse proxy configuration.
* Local DNS/DHCP through dnsmasq.
* PostgreSQL managed as system infrastructure.
* systemd-based service orchestration and scheduled jobs.
* sops-nix for encrypted secret management.

### Backup and recovery

* Migrated application backups to Restic.
* Added application-aware backup procedures for stateful services.
* Added PostgreSQL database dumps for database-backed applications.
* Added retention and repository maintenance policies.
* Validated backup integrity and representative restore operations.

### Monitoring and maintenance

* Added health checks and service monitoring.
* Integrated operational notifications.
* Added storage and disk health checks.
* Added scheduled maintenance and backup verification.

---

## v1.1 — Reliability

**Priority: High**

The first major enhancement is to remove the remaining single-site dependency from the backup strategy.

### Off-site Restic backups

Replicate the local Restic repository to an independent off-site location.

Goals:

* Protect against host failure, filesystem failure, theft, and other site-level events.
* Keep the existing local repository for fast recovery.
* Maintain encrypted backups without exposing repository contents to the remote storage provider.
* Document recovery from the off-site repository rather than treating replication as sufficient by itself.

### Automated restore testing

Turn backup verification into an automated recovery test.

Possible implementation:

1. Select representative application data from recent snapshots.
2. Restore it into a temporary location or isolated test environment.
3. Validate expected files and database dumps.
4. Report success or failure through the existing monitoring/notification system.

The objective is to verify **recoverability**, not merely repository integrity.

### Disaster-recovery procedure

Document the complete recovery sequence for a total host replacement:

```text
Install NixOS
    ↓
Restore repository access / secrets
    ↓
Apply declarative system configuration
    ↓
Restore application state from Restic
    ↓
Restore databases
    ↓
Validate services
    ↓
Return production traffic
```

The recovery procedure should be executable by following the documentation without relying on undocumented knowledge of the original host.

---

## v1.2 — Engineering Workflow

**Priority: High**

Once the infrastructure is recoverable, the next goal is to make configuration changes safer and more repeatable.

### Continuous integration

Add CI validation for the repository.

Initial checks:

* `nix flake check`
* Nix evaluation
* configuration builds
* repository-level tests

Future checks can include formatting and static analysis.

### NixOS VM testing

Expand the existing configuration tests into realistic VM-based integration tests.

Potential scenarios:

* service startup
* storage declarations
* networking configuration
* reverse-proxy configuration
* secret wiring
* systemd dependency behaviour
* backup service configuration

The objective is to catch configuration regressions before they reach the production host.

### Deployment validation

Formalize the production deployment workflow:

```text
Change
  ↓
flake check
  ↓
build
  ↓
test
  ↓
inspect generation
  ↓
switch
  ↓
runtime validation
  ↓
commit / release
```

This provides a predictable path from configuration change to production deployment.

### Versioned infrastructure releases

Use Git tags for stable infrastructure milestones.

Example:

```text
v1.0.0
v1.1.0
v1.2.0
```

Each release should represent a known-good infrastructure state that can be referenced during incident response or rollback.

---

## v1.3 — Observability

**Priority: Medium**

The next stage is improving visibility into the operational state of the infrastructure.

### Backup freshness monitoring

Monitor whether each expected backup has completed recently.

Examples:

* latest successful snapshot timestamp
* expected backup frequency
* age of oldest successful application backup
* repository availability

A backup job that silently stops running should become an observable incident.

### Backup dashboard

Expose backup and recovery status through the existing monitoring stack.

Useful information could include:

* last successful backup per application
* backup age
* repository size
* recent failures
* restore-test results
* off-site replication status

### SMART and hardware monitoring

Improve hardware-health monitoring where current devices or interfaces limit automatic SMART collection.

This includes investigating devices such as:

* USB-attached storage
* NVMe devices
* devices where `smartctl` requires additional parameters or capabilities

The goal is to distinguish genuine hardware-health problems from monitoring limitations.

### Recovery-focused alerting

Extend alerts beyond "service is down" to include conditions such as:

* backup failure
* stale backup
* failed restore test
* storage degradation
* repository integrity problems
* unexpected filesystem capacity growth

---

## v2.0 — Infrastructure Expansion

**Priority: Future**

These improvements move the project from a well-recoverable single host toward a more resilient distributed setup.

### Secondary host

Introduce a second physical or virtual host for selected workloads or recovery purposes.

Possible roles:

* backup target
* monitoring node
* disaster-recovery host
* replicated services

### WireGuard-based private networking

Create a secure private network between hosts and trusted remote systems.

Potential uses:

* off-site backup transport
* administrative access
* service-to-service communication
* remote recovery

### Redundancy

Move selected components from single-instance to redundant operation where the additional complexity is justified.

Examples:

* monitoring
* backup infrastructure
* DNS
* selected application services

This should be introduced selectively rather than turning a single-host homelab into a distributed system without a concrete reliability benefit.

---

## Longer-Term Architecture

As the project evolves, the general direction is to reduce unnecessary mutable infrastructure state while keeping application data in appropriate persistent storage.

The desired model is:

```text
Declarative configuration
        +
Version-controlled infrastructure
        +
Encrypted secrets
        +
Persistent application state
        +
Independent backups
        +
Tested recovery procedures
```

The objective is not to eliminate all mutable state. Application data, databases, caches, and other runtime state should remain mutable where that is operationally appropriate. The goal is instead to make the **infrastructure required to recreate the system deterministic and reproducible**.

## Priorities

The current roadmap is intentionally ordered by operational value:

| Version  | Focus                                                          | Priority |
| -------- | -------------------------------------------------------------- | -------- |
| **v1.0** | Debian → NixOS migration and native service architecture       | Complete |
| **v1.1** | Off-site backups, automated restore testing, disaster recovery | High     |
| **v1.2** | CI, VM testing, deployment validation, release workflow        | High     |
| **v1.3** | Backup observability, SMART monitoring, recovery alerting      | Medium   |
| **v2.0** | Second host, WireGuard, selective redundancy                   | Future   |

The most important next milestone is **v1.1**. A local backup system provides strong protection against application or host failure, but an independent off-site copy and repeatable restore testing provide a substantially stronger recovery posture.

Roadmap items are deliberately treated as enhancements rather than prerequisites for v1.0. The current system is considered a complete and usable production baseline.

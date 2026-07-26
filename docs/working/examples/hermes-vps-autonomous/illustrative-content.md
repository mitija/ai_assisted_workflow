# Worked Example A: Hermes Agent on VPS (Autonomous Mode)

> **Framework element in context.** Illustrative fictional content is presented
> as project material. Framework requirements (phases, artefact types, quality
> gates, identifier conventions) are the process being demonstrated. The project
> details are entirely fictional.

---

## Phase 1 — Intake

### Initial Q&A (illustrative)

**Analyst:** What problem are you solving?

**Human:** I need to run a Hermes AI agent on a cheap VPS and talk to it through
Discord. I want the setup to be fully automated so I can rebuild it from
scratch without manual steps.

**Analyst:** Who is it for?

**Human:** Just me — personal use.

**Analyst:** What does success look like?

**Human:**
- I can send a Discord message and get a useful response from Hermes.
- If the VPS dies, I can reprovision it in under 30 minutes with one command.
- It should be secure enough for personal use — I don't want credentials in my
  git repo.

**Analyst:** What are the constraints?

**Human:** Hetzner CX22 (2 vCPU, 4 GB RAM), Ubuntu 24.04, Ansible for
automation. Budget constraint: keep the VPS under EUR 5/month.

**Analyst:** What's out of scope?

**Human:** High availability, load balancing, monitoring dashboard, multi-user
support. Just a single-user single-instance setup.

**Analyst:** What operating mode do you want?

**Human:** Autonomous. I trust you to make the routine decisions. Flag anything
that could compromise security or cost significantly.

### Objective Brief (produced by analyst)

```
OBJ-001: Deploy a maintainable Hermes AI agent on a single Hetzner CX22 VPS,
         accessible via Discord, with fully automated Ansible-based
         provisioning, appropriate for personal use.
```

**Problem statement:** Manual Hermes deployment is error-prone and
non-reproducible. A one-command rebuild is required.

**Beneficiaries:** Single user (the human).

**High-level success criteria:**
- HC-001: A Discord message to Hermes receives a useful response.
- HC-002: A clean VPS can be fully provisioned with a single Ansible run.
- HC-003: Only the configured Discord user can interact with Hermes; credentials are stored securely; secrets and Discord user content are absent from the repository and normal logs; network exposure is restricted to SSH and outbound HTTPS.
- HC-004: Routine operational tasks (log management, secret rotation) are automated; documentation supports ongoing maintenance.

**Constraints:** Hetzner CX22, Ubuntu 24.04, Ansible, EUR 5/month budget,
single-user.

**Scope boundaries:** Single-instance deployment only. No HA, no monitoring
dashboards, no multi-user.

**Explicit exclusions:** High availability, load balancing, monitoring
dashboard, multi-user support, CI/CD pipeline.

**Known integrations:** Discord API, Hetzner cloud (manual VPS creation is
acceptable).

**Assumptions:** VPS is provisioned manually (Ansible runs against an existing
host). Hermes binary is available via GitHub releases. Discord bot token is
obtained manually.

**Selected operating mode:** Autonomous

### Human confirmation

The human confirmed the objective brief as written. Phase 1 complete.

---

## Phase 2 — Discovery (20-step process)

### Step 1 — Frame the objective

The core outcome: a Hermes agent running on a Hetzner CX22 that the human can
interact with via Discord, where the entire software configuration is automated
by Ansible and the VPS can be rebuilt from scratch without manual steps.

### Step 2 — Capture high-level success criteria

Recorded as HC-001 through HC-004 (see Objective Brief above).

### Step 3 — Inspect existing evidence

Inspected: no existing Ansible roles, no prior deployment scripts, no project
conventions in this workspace for Hermes. Domain research was required.

### Step 4 — Research domain conventions

Researched Hermes deployment patterns, Ansible role conventions, Discord bot
security practices, and Hetzner Ubuntu 24.04 setup guides (webfetch used).

### Step 5 — Identify actors, stakeholders and external systems

| Actor / System | Role | Interaction |
|---|---|---|
| Human (Discord user) | Primary user | Sends slash commands, receives responses |
| Hermes agent | Core service | Processes messages, returns AI-generated responses |
| Discord API | External system | Receives bot messages, delivers responses to user |
| Hetzner VPS | Hosting platform | Runs Hermes and supporting services |
| Ansible control machine | Deployment tool | Provisions the VPS remotely |

### Step 6 — Model entities, states and lifecycles

**Hermes service lifecycle:** `stopped → running → failed → auto-restart → running`

**Ansible playbook states:** `unchanged → changed (first-run) → idempotent (subsequent runs)`

**Discord bot connection:** `disconnected → connecting → connected → disconnected (token expiry or network)`

### Step 7 — Generate candidate requirements

| ID | Statement | Provenance |
|---|---|---|
| FR-001 | The system shall deploy Hermes as a systemd service on Ubuntu 24.04. | domain-practice |
| FR-002 | The system shall expose Hermes via a Discord bot using slash commands. | explicitly-requested |
| FR-003 | The system shall authenticate Discord API interactions using a bot token. | inferred-context |
| FR-012 | The Ansible playbook shall install all dependencies (Python, system packages, Hermes binary). | explicitly-requested |
| NFR-001 | The system shall reject Discord interactions from unauthorised users. | risk-control |
| NFR-002 | The system shall restart Hermes automatically after unexpected failure. | domain-practice |
| NFR-003 | The Ansible playbook shall be idempotent — running it multiple times produces the same result. | domain-practice |
| NFR-004 | The Ansible playbook shall complete in under 10 minutes on a clean CX22. | design-decision |
| NFR-005 | The system shall store the Discord bot token in a secure location, not in the playbook repository. | explicitly-requested |
| NFR-006 | Normal logs shall not retain Discord message content or Discord user IDs. | risk-control |
| OPS-001 | The system shall rotate Hermes and system logs to prevent disk exhaustion. | domain-practice |
| OPS-002 | The system shall expose Hermes health via a local HTTP health endpoint. | design-decision |
| OPS-003 | The Ansible playbook shall configure the Uncomplicated Firewall (UFW) to allow only SSH and outbound HTTPS. | risk-control |
| OPS-004 | The Ansible playbook shall support token rotation by re-running with an updated vault file. | design-decision |
| DOC-001 | The project shall include configuration and operations documentation covering all configurable keys, install, start/stop, upgrade, health check, secret rotation, backup, and rebuild procedures. | design-decision |

#### Applicability records

| Category | Applies | Reference(s) | Rationale |
|---|---|---|---|
| Security | Yes | NFR-001, NFR-005, OPS-003 | User authorisation, secret storage, and firewall rules are the three security controls in scope |
| Privacy | Yes | NFR-006 | Normal logs must not retain Discord message content or Discord user IDs |
| Accessibility | Not applicable | — | No custom UI; interaction is via Discord's existing interface |
| Performance | Yes | NFR-004 | Playbook completion time under 10 minutes on CX22 is a bounded performance target |
| Availability | Yes | NFR-002, OPS-002 | Auto-restart and health endpoint provide basic availability management |
| Reliability | Yes | NFR-002, NFR-003 | Auto-restart on failure and idempotent provisioning ensure predictable system behaviour |
| Observability | Yes | OPS-001, OPS-002 | Log rotation controls disk use; health endpoint exposes service state |
| Maintainability | Yes | NFR-003, DOC-001 | Idempotent playbook ensures consistent state; documentation enables future maintenance |
| Deployment | Yes | FR-001, FR-012, OPS-003 | systemd deployment, dependency installation, and UFW configuration are the deployment concerns |
| Configuration | Yes | DOC-001 | Configuration keys and change effects are documented per DOC-001 |
| Backup/Recovery | Yes | DOC-001 | Manual configuration backup is documented; clean rebuild is documented in DOC-001. Automatic backup is explicitly excluded |
| Regulatory/Compliance | Not applicable | — | Personal use; no regulatory regime applies |
| Support/Operations | Yes | OPS-001, OPS-004 | Log rotation and token rotation cover the primary operational lifecycle tasks |

### Step 8 — Define business rules

| ID | Rule | Rationale | Provenance |
|---|---|---|---|
| BR-001 | The authorised Discord user is identified by their Discord user ID, configured in the Hermes config file. | Single-user deployment; avoids building an auth subsystem | design-decision |
| BR-002 | The process manager (systemd) restarts Hermes with exponential backoff: 5s, 15s, 30s, 60s, then every 60s. | Prevents rapid restart loops while ensuring eventual recovery | domain-practice |
| BR-003 | Logs older than 14 days are compressed; logs older than 30 days are deleted. | Balances debugging history with disk constraints on CX22 | domain-practice |

### Step 9 — Analyse exceptions, failures, recovery and edge cases

| Scenario | Expected behaviour |
|---|---|
| Discord API token expires | Hermes logs the error and shuts down; systemd restarts; human must update the token |
| VPS is rebooted | systemd starts Hermes automatically |
| Disk usage exceeds 90% | Log rotation is triggered early; alert logged |
| Ansible run fails mid-way | Playbook halts; subsequent run detects already-completed steps and continues |
| Hermes process crashes | systemd restarts with backoff; health endpoint is unreachable (connection refused) during restart until service is ready |
| Network outage | Hermes fails to connect to Discord API; retries with backoff; health endpoint returns 503 while Hermes is running but Discord is unavailable |
| Unauthorised Discord user sends a command | Hermes ignores the command; no response sent |

### Step 10 — Identify contradictions and gaps

No contradictions found. One gap identified: NFR-001 (reject unauthorised users)
has no corresponding configuration documentation requirement — added DOC-001.

### Step 11 — Classify decisions

| Decision | Class | Rationale |
|---|---|---|
| Port for health endpoint (select a port) | A | Reversible, low-impact; any unused port above 1024 works |
| Log rotation frequency | A | Low-impact; can be adjusted later |
| Process manager choice (systemd vs supervisor) | B | Both work; systemd is standard for Ubuntu |
| Authorised-user identification method | B | Hardcoded ID vs config file; config file is slightly more flexible but both are fine |
| Secret storage approach | C | Different approaches (Ansible vault, env var, sops, HashiCorp Vault) have material security and complexity trade-offs |

### Step 12 — Resolve non-blocking decisions (Class A and B)

| DEC | Decision | Rationale | Alternative considered |
|---|---|---|---|
| DEC-001 | Health endpoint port: 9100 | Standard practice for agent metrics; unlikely to conflict | 9090 (common with Prometheus), 8080 (common with web apps) |
| DEC-002 | Process manager: systemd | Ships with Ubuntu, simple unit file, standard logging | supervisor (additional dependency) |
| DEC-003 | Log rotation: 14-day compress, 30-day delete via logrotate | Fits CX22 disk (40 GB); standard tool | Internal rotation, journald limits |
| DEC-004 | Authorised user via config file (not hardcoded) | Human can add/change user without recompilation; still single-user by default | Hardcoded ID (simpler but less flexible) |

### Step 13 — Escalate consequential decisions (Class C)

**DEC-005 — Secret storage approach**

**Question:** How should the Discord bot token be stored and provided to Hermes?

**Recommendation:** Use Ansible Vault to encrypt the token in a vars file, with
the vault password stored in a local `.vault_pass` file (gitignored). This
provides good security for personal use without requiring external services.

**Alternatives:**
1. Environment variable in systemd unit file (simpler but token visible in
   process listings)
2. sops-encrypted file (more complex, better audit trail)
3. HashiCorp Vault (overkill for single-user)
4. Plaintext in repo (explicitly excluded by HC-003)

**Consequences:** Ansible Vault requires the vault password to be available
during provisioning. The human must secure the `.vault_pass` file separately.

**Human response:** "Ansible Vault sounds fine. Go with that."

### Step 14 — Define detailed success criteria

| SC | Statement | Maps to | Verification |
|---|---|---|---|
| SC-001 | A Discord slash command `/ask What is the capital of France?` receives a relevant response within 30 seconds | HC-001 | VER-001 |
| SC-002 | An unauthorised Discord user receives no response to any command | HC-001, HC-003 | VER-002 |
| SC-003 | After unexpected Hermes process termination, the service becomes active again within 60 seconds without manual intervention | HC-001 | VER-003 |
| SC-004 | `ansible-playbook playbook.yml` on a clean CX22 completes with exit code 0 | HC-002 | VER-004 |
| SC-005 | Running `ansible-playbook playbook.yml` twice produces identical changed=0 output on the second run | HC-002 | VER-005 |
| SC-006 | No secrets appear in `git ls-files` or in `journalctl -u hermes` output | HC-003 | VER-006 |
| SC-007 | UFW status shows only OpenSSH and outbound HTTPS as allowed | HC-003 | VER-007 |
| SC-008 | Log files older than 14 days are compressed and logs older than 30 days are absent from /var/log/hermes/ | HC-004 | VER-008 |
| SC-009 | The health endpoint returns HTTP 200 within 5 seconds of Hermes starting | HC-001 | VER-009 |
| SC-010 | The health endpoint returns HTTP 503 when Hermes is running but Discord API is unavailable (dependency failure) | HC-001 | VER-009 |
| SC-011 | Ansible playbook completes in under 10 minutes (measured) | HC-002 | VER-004 |
| SC-012 | Hermes config file contains the authorised user ID | HC-001 | VER-002 |
| SC-013 | Hermes binary, required Python dependencies, and required system packages are installed | HC-002 | VER-004 |
| SC-014 | systemd unit file is present and enabled | HC-001, HC-002 | VER-004 |
| SC-015 | Hermes restarts with exponential backoff after crash (5s, 15s, 30s, 60s, then every 60s) | HC-001 | VER-003 |
| SC-016 | Vault-encrypted token file is not readable by non-root users | HC-003 | VER-006 |
| SC-017 | The Hermes bot authenticates with Discord using the configured token and responds to a `/ask` command | HC-001 | VER-001 |
| SC-018 | After updating the token in the vault file and re-running the playbook, the bot authenticates with the new token | HC-004 | VER-004 |
| SC-019 | Configuration and operations documentation covers all configurable keys, install, start/stop, upgrade, health check, secret rotation, backup, and rebuild procedures | HC-001, HC-002, HC-004 | VER-010 |
| SC-020 | Normal logs contain no Discord message content or Discord user IDs | HC-003 | VER-006 |

### Step 15 — Define verification methods

| VER | Method | What to check | Pass criteria |
|---|---|---|---|
| VER-001 | Manual test | Send Discord command, observe response | Response received within 30s |
| VER-002 | Manual test | Inspect configured `authorised_user_id`; send same command from configured account and from a different Discord account | Response received only for the configured account; no response for any other account; Hermes logs "unauthorised" |
| VER-003 | Automated recovery test | Force repeated Hermes process terminations; record timestamps of each restart | Restart intervals conform to 5s (±2s), 15s (±3s), 30s (±5s), 60s (±10s), then every 60s (±10s); final recovery within 60s of last termination |
| VER-004 | Automated (CI) | Measure wall-clock playbook time; inspect Hermes binary and declared Python/system dependencies; assert systemd unit exists and is enabled; rotate vault token, re-run playbook, confirm authentication with replacement token | Wall-clock ≤10 min; binary, Python deps, system pkgs present; systemd unit exists and is enabled; replacement token authenticates successfully |
| VER-005 | Automated (CI) | Run playbook twice, compare changed counts | Second run: 0 changed |
| VER-006 | Automated script | Scan tracked repo for credential patterns, Discord message samples, and user IDs; scan `journalctl -u hermes` normal logs for same; inspect vault-encrypted token file ownership and mode | Zero credential/secret matches in repo and logs; zero Discord message content or user IDs in logs; vault file owned by root with mode 0400 or stricter |
| VER-007 | Automated (CI) | Run `ufw status verbose` on provisioned VM | Only OpenSSH + outbound HTTPS |
| VER-008 | Automated script | Verify logs older than 14 days are compressed and files older than 30 days are absent from /var/log/hermes/ | Zero uncompressed files older than 14 days; zero files older than 30 days |
| VER-009 | Automated script | Curl health endpoint when Hermes is healthy (200) and when discord API is unavailable (503) | HTTP 200 when Hermes is healthy and Discord is reachable; HTTP 503 when Hermes is running but Discord dependency is unavailable; endpoint unreachable (connection refused) when Hermes process is down |
| VER-010 | Document review | Inspect docs for coverage of all config keys, install, start/stop, upgrade, health check, secret rotation, backup, rebuild | All topics covered; every config key has type, default, change effect |

### Step 16 — Draft intended documentation

#### Configuration reference (illustrative excerpt)

| Key | Purpose | Type | Required | Default | Allowed | Security | Change effect |
|---|---|---|---|---|---|---|---|
| `discord_token` | Discord bot token | string | yes | — | valid Discord bot token | Must be vault-encrypted | Redeploy (vault update + playbook re-run) |
| `authorised_user_id` | Discord user ID allowed to interact | string | yes | — | valid Discord snowflake | Controls access | Service restart |
| `health_port` | Health check HTTP port | integer | no | 9100 | 1024–65535 | — | Service restart |
| `log_level` | Hermes log verbosity | string | no | info | debug, info, warn, error | — | Service restart |
| `log_dir` | Log file directory | string | no | /var/log/hermes | valid absolute path | — | Service restart |

#### Operations guide (illustrative excerpt)

**Installation:** `ansible-playbook -i hosts playbook.yml --ask-vault-pass`

**Start/Stop:** `systemctl start hermes` / `systemctl stop hermes`

**Health check:** `curl http://localhost:9100/health`

**Upgrade:** Update playbook's `hermes_version` var; re-run playbook.

**Secret rotation:** Edit vault file: `ansible-vault edit vars/vault.yml`

**Backup:** Minimal state (config only): `tar czf hermes-config.tar.gz /etc/hermes/`

**Rebuild:** Provision new CX22, update `hosts` inventory, run playbook.

#### Troubleshooting guide (illustrative excerpt)

| Symptom | Likely cause | Diagnosis | Fix |
|---|---|---|---|
| No response from Hermes | Bot not running | `systemctl status hermes` | `systemctl start hermes` |
| "Unauthorised" in logs | Wrong user | Check `authorised_user_id` in config | Update config, restart service |
| Ansible fails with "decryption failed" | Wrong vault password | `ansible-vault view vars/vault.yml` | Check `.vault_pass` file |
| Health check connection refused | Hermes process crashed or not yet started | `systemctl status hermes` | `systemctl start hermes`; check logs for failure cause |
| Health check returns 503 | Hermes running but Discord API unreachable | `journalctl -u hermes -n 50` | Check network and Discord API status |

### Step 17 — Use documentation gaps to discover missing requirements

During the operations guide, documenting "secret rotation" revealed that no
requirement existed for the human to be able to rotate the Discord token without
manual VPS access. Added OPS-004.

| ID | Statement | Provenance |
|---|---|---|
| OPS-004 | The Ansible playbook shall support token rotation by re-running with an updated vault file. | design-decision |

### Step 18 — Produce wireframes

Not applicable — this is an infrastructure deployment with no UI.

### Step 19 — Requirements quality review

**Critical (0):** None found.

**Warning (1):** NFR-004 (playbook completes in under 10 minutes) — this is
environment-dependent and may fail on slower VPS models. Changed priority to
"nice-to-have" and added note that it's a design goal, not a hard requirement.

**Suggestion (1):** Consider adding a pre-flight check (FR-014) that verifies
the target host has sufficient disk space and the correct OS version before
applying changes.

### Step 20 — Produce requirements baseline

The complete traceability package was consolidated (see Baseline Phase).

---

## Phase 3 — Review (quality gate only; guided validation skipped)

Since the operating mode is **autonomous**, the analyst does not produce a
functional validation package for human review. The quality gate was performed
as part of Step 19. All critical findings were resolved; warnings and
suggestions were recorded.

The conductor is informed that the requirements baseline is ready for
implementation. The human will be interrupted only if a Class C or D decision
arises during implementation.

---

## Phase 4 — Baseline

### Traceability chain (summary)

```
OBJ-001  Deploy maintainable Hermes on VPS, Discord-accessible, Ansible-automated
  HC-001  Discord messages receive useful responses
    FR-001  systemd deployment
       SC-003  Auto-restart after crash within 60s       → VER-003  Recovery test
       SC-014  systemd unit present/enabled  → VER-004  CI run
    FR-002  Discord slash-command bot
      SC-001  Command response within 30s   → VER-001  Manual test
    FR-003  Bot token authentication
      SC-017  Auth via configured token     → VER-001  Manual test
    FR-012  Install all dependencies
      SC-013  Binary, Python deps, system pkgs  → VER-004  CI run
    NFR-001  Reject unauthorised users
      BR-001  Authorised user by config ID
      SC-002  No response to unauthorised   → VER-002  Manual test
      SC-012  Authorised user in config     → VER-002  Manual test
    NFR-002  Auto-restart after failure
      BR-002  Exponential backoff (5s–60s)
      SC-003  Recovery within 60s           → VER-003  Recovery test
      SC-015  Exponential backoff (5s–60s+) → VER-003  Recovery test
    NFR-005  Secure token storage
      SC-006  No secrets in repo or journal → VER-006  Scan script
      SC-016  Vault file not world-readable → VER-006  Scan script
    NFR-006  No Discord content in logs
      SC-020  No Discord content in logs     → VER-006  Scan script
    OPS-002  Health endpoint
      SC-009  HTTP 200 when healthy         → VER-009  Curl test
      SC-010  HTTP 503 when Discord unavailable → VER-009  Curl test
    DOC-001  Configuration/ops documentation
      SC-019  Documentation covers all keys/ops   → VER-010  Document review

  HC-002  One-command clean VPS provisioning
    FR-001  systemd deployment
       SC-014  systemd unit present/enabled  → VER-004  CI run
    FR-012  Install all dependencies
      SC-013  Binary, Python deps, system pkgs  → VER-004  CI run
    NFR-003  Idempotent playbook
      SC-005  Second run: 0 changed         → VER-005  CI idempotency check
    NFR-004  Playbook completes in <10 min
      SC-011  Measured completion time      → VER-004  CI syntax + run
    OPS-003  UFW configuration
      SC-007  UFW: only SSH + HTTPS         → VER-007  CI check
    DOC-001  Configuration/ops documentation
      SC-019  Documentation covers all keys/ops   → VER-010  Document review

  HC-003  Authorised access, credential secrecy, restricted network, log privacy
    NFR-001  Reject unauthorised users
      SC-002  No response to unauthorised   → VER-002  Manual test
      SC-012  Authorised user in config     → VER-002  Manual test
    NFR-005  Secure token storage
      SC-006  No secrets in repo or journal → VER-006  Scan script
      SC-016  Vault file not world-readable → VER-006  Scan script
    NFR-006  No Discord content in logs
      SC-020  No Discord content in logs     → VER-006  Scan script
    OPS-003  UFW configuration
      SC-007  UFW: only SSH + HTTPS         → VER-007  CI check

  HC-004  Repeatable routine operations and maintainability
    OPS-001  Log rotation
      BR-003  Log retention: 14d compress, 30d delete
      SC-008  Logs: 14d compress, 30d delete  → VER-008  Script
    OPS-004  Token rotation support
      SC-018  Token rotation via vault re-run    → VER-004  CI run
    DOC-001  Configuration/ops documentation
      SC-019  Documentation covers all keys/ops   → VER-010  Document review

  DOC-001: Every HC contributes to the need for documentation
    HC-001  (config reference for Discord interaction)
    HC-002  (install/backup/rebuild procedures)
    HC-003  (vault, firewall, authorisation procedures)
    HC-004  (log management, token rotation procedures)
```

### Autonomous decisions recorded

| DEC-ID | Decision | Class | Rationale |
|---|---|---|---|
| DEC-001 | Health port 9100 | A | Standard unused port |
| DEC-002 | systemd as process manager | A | Ships with Ubuntu |
| DEC-003 | logrotate: 14d compress, 30d delete | A | Fits CX22 disk |
| DEC-004 | Authorised user via config file | B | More flexible than hardcoded |
| DEC-005 | Ansible Vault for secret storage | C | Escalated; human approved |

### Documentation completeness gate

- [x] OBJ-001 represented in requirements
- [x] BR-001–BR-003 documented
- [x] All requirements traceable (see traceability chain)
- [x] Every mandatory FR, NFR, OPS, DOC, and BR has at least one SC
- [x] Every SC maps to at least one VER
- [x] Configuration reference documents every supported key with change effect
- [x] Operations guide covers install, start/stop, upgrade, health, secrets,
      backup, rebuild
- [x] Troubleshooting guide covers common failure modes
- [x] Known limitations documented (single-user, no HA, no monitoring dashboard)
- [x] All autonomous decisions recorded (DEC-001–DEC-005)
- [x] Human-confirmed decision identifiable (DEC-005)
- [x] No contradictions between artefacts

### Known limitations

- Single-user only; no multi-user authorisation system.
- No monitoring dashboard — relies on systemd status and health endpoint.
- No automatic backup — documented manual procedure only.
- Playbook completion time depends on Hetzner VPS performance and network speed.

---

## Example summary

This example demonstrates the complete analyst workflow in autonomous mode for
an infrastructure deployment project with no UI. The analyst:

1. Conducted a focused high-level Q&A (6 questions).
2. Produced a confirmed objective brief (OBJ-001, HC-001–HC-004).
3. Performed all 20 discovery steps, including domain research (Step 4),
   entity modelling (Step 6), exception analysis (Step 9),
   discovery-category applicability records (Step 7), and
   documentation-gap-driven requirement discovery (Step 17).
4. Classified 5 decisions (A/B/C), resolved 4 autonomously, escalated 1 (C) to
   the human with a bounded recommendation.
5. Produced **4 functional requirements**, **6 non-functional requirements**,
   **4 operational requirements**, **1 documentation requirement**,
   **3 business rules**, **20 detailed success criteria**, and
   **10 verification methods**.
6. Applied provenance labels to every requirement.
7. Reviewed the full set (0 critical, 1 warning, 1 suggestion).
8. Established full traceability from objective through to verification.
9. Did not produce a validation package (autonomous mode).

---

## Requirement inventory summary

| Category | Count | IDs |
|---|---|---|
| FR (functional) | 4 | FR-001–FR-003, FR-012 |
| NFR (non-functional) | 6 | NFR-001–NFR-006 |
| OPS (operational) | 4 | OPS-001–OPS-004 |
| DOC (documentation) | 1 | DOC-001 |
| BR (business rule) | 3 | BR-001–BR-003 |
| SC (success criterion) | 20 | SC-001–SC-020 |
| VER (verification) | 10 | VER-001–VER-010 |
| **Total requirement/rule/SC/VER identifiers** | **48** | |

### SC/VER mapping coverage

Every FR, NFR, OPS, DOC, and BR identifier maps to at least one SC and at least
one VER:

| Category | Mapped to SC | Mapped to VER |
|---|---|---|
| FR-001 | SC-003, SC-014 | VER-003, VER-004 |
| FR-002 | SC-001 | VER-001 |
| FR-003 | SC-017 | VER-001 |
| FR-012 | SC-013 | VER-004 |
| NFR-001 | SC-002, SC-012 | VER-002 |
| NFR-002 | SC-003, SC-015 | VER-003 |
| NFR-003 | SC-005 | VER-005 |
| NFR-004 | SC-011 | VER-004 |
| NFR-005 | SC-006, SC-016 | VER-006 |
| NFR-006 | SC-020 | VER-006 |
| OPS-001 | SC-008 | VER-008 |
| OPS-002 | SC-009, SC-010 | VER-009 |
| OPS-003 | SC-007 | VER-007 |
| OPS-004 | SC-018 | VER-004 |
| DOC-001 | SC-019 | VER-010 |
| BR-001 | SC-002, SC-012 | VER-002 |
| BR-002 | SC-015 | VER-003 |
| BR-003 | SC-008 | VER-008 |

All 18 identifiers (4 FR + 6 NFR + 4 OPS + 1 DOC + 3 BR) map to at least one SC
and one VER. All 20 SCs map to at least one VER. Complete traceability is
established.
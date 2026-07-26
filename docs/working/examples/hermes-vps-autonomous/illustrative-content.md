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
OBJ-001: Deploy a Hermes AI agent on a single Hetzner CX22 VPS,
         accessible via Discord, with fully automated Ansible-based
         provisioning, appropriate for personal use.
```

**Problem statement:** Manual Hermes deployment is error-prone and
non-reproducible. A one-command rebuild is required.

**Beneficiaries:** Single user (the human).

**High-level success criteria:**
- HC-001: A Discord message to Hermes receives a useful response.
- HC-002: A clean VPS can be fully provisioned with a single Ansible run.
- HC-003: Secrets are absent from the git repository and normal logs.

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

Recorded as HC-001 through HC-003 (see Objective Brief above).

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
| FR-004 | The system shall reject Discord interactions from unauthorised users. | risk-control |
| FR-005 | The system shall restart Hermes automatically after unexpected failure. | domain-practice |
| FR-006 | The Ansible playbook shall be idempotent — running it multiple times produces the same result. | explicitly-requested |
| FR-007 | The Ansible playbook shall complete in under 10 minutes on a clean CX22. | design-decision |
| FR-008 | The system shall rotate Hermes and system logs to prevent disk exhaustion. | domain-practice |
| FR-009 | The system shall expose Hermes health via a local HTTP health endpoint. | design-decision |
| FR-010 | The Ansible playbook shall configure the Uncomplicated Firewall (UFW) to allow only SSH and outbound HTTPS. | risk-control |
| FR-011 | The system shall store the Discord bot token in a secure location, not in the playbook repository. | explicitly-requested |
| FR-012 | The system shall include an Ansible playbook that installs all dependencies (Python, system packages, Hermes binary). | explicitly-requested |

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
| Hermes process crashes | systemd restarts with backoff; health endpoint returns 503 during restart |
| Network outage | Hermes fails to connect to Discord API; retries with backoff; health endpoint returns 502 |
| Unauthorised Discord user sends a command | Hermes ignores the command; no response sent |

### Step 10 — Identify contradictions and gaps

No contradictions found. One gap identified: FR-004 (reject unauthorised users)
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
| SC-003 | After `systemctl stop hermes`, the service becomes active again within 60 seconds without manual intervention | HC-001 | VER-003 |
| SC-004 | `ansible-playbook playbook.yml` on a clean CX22 completes with exit code 0 | HC-002 | VER-004 |
| SC-005 | Running `ansible-playbook playbook.yml` twice produces identical changed=0 output on the second run | HC-002 | VER-005 |
| SC-006 | No secrets appear in `git ls-files` or in `journalctl -u hermes` output | HC-003 | VER-006 |
| SC-007 | UFW status shows only OpenSSH and outbound HTTPS as allowed | HC-003 | VER-007 |
| SC-008 | Log files older than 30 days are absent from /var/log/hermes/ | HC-002 | VER-008 |
| SC-009 | The health endpoint returns HTTP 200 within 5 seconds of Hermes starting | HC-001 | VER-009 |
| SC-010 | The health endpoint returns HTTP 503 when Hermes is stopped | HC-001 | VER-003 |
| SC-011 | Ansible playbook completes in under 10 minutes (measured) | HC-002 | VER-004 |
| SC-012 | Hermes config file contains the authorised user ID | HC-001 | VER-002 |
| SC-013 | Hermes binary is installed to /usr/local/bin/hermes | HC-002 | VER-004 |
| SC-014 | systemd unit file is present and enabled | HC-002 | VER-004 |
| SC-015 | Hermes restarts with exponential backoff after crash (5s, 15s, 30s, 60s) | HC-001 | VER-003 |
| SC-016 | Vault-encrypted token file is not readable by non-root users | HC-003 | VER-006 |
| SC-017 | The Hermes bot authenticates with Discord using the configured token and responds to a `/ask` command | HC-001 | VER-001 |
| SC-018 | After updating the token in the vault file and re-running the playbook, the bot authenticates with the new token | HC-002 | VER-004 |

### Step 15 — Define verification methods

| VER | Method | What to check | Pass criteria |
|---|---|---|---|
| VER-001 | Manual test | Send Discord command, observe response | Response received within 30s |
| VER-002 | Manual test | Send command from unauthorised Discord account | No response; Hermes logs "unauthorised" |
| VER-003 | Automated recovery test | Kill Hermes process, measure time to recovery | Service active within 60s |
| VER-004 | Automated (CI) | Run `ansible-playbook --syntax-check`, then against test VM | Exit 0, all tasks pass |
| VER-005 | Automated (CI) | Run playbook twice, compare changed counts | Second run: 0 changed |
| VER-006 | Automated script | Scan repo for token patterns, scan journalctl for secrets | Zero matches |
| VER-007 | Automated (CI) | Run `ufw status verbose` on provisioned VM | Only OpenSSH + outbound HTTPS |
| VER-008 | Automated script | List files in /var/log/hermes/ older than 30 days | Zero files |
| VER-009 | Automated script | Curl health endpoint after service start | HTTP 200 within 5s |

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
| Health check returns 503 | Service starting or crashed | `journalctl -u hermes -n 50` | Check logs, verify config |

### Step 17 — Use documentation gaps to discover missing requirements

During the operations guide, documenting "secret rotation" revealed that no
requirement existed for the human to be able to rotate the Discord token without
manual VPS access. Added FR-013.

| ID | Statement | Provenance |
|---|---|---|
| FR-013 | The Ansible playbook shall support token rotation by re-running with an updated vault file. | design-decision |

### Step 18 — Produce wireframes

Not applicable — this is an infrastructure deployment with no UI.

### Step 19 — Requirements quality review

**Critical (0):** None found.

**Warning (1):** FR-007 (playbook completes in under 10 minutes) — this is
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
OBJ-001  Deploy Hermes on VPS, Discord-accessible, Ansible-automated
  HC-001  Discord messages receive useful responses
    FR-001  systemd deployment
      SC-001  Command response within 30s  → VER-001  Manual test
      SC-003  Auto-restart within 60s       → VER-003  Recovery test
      SC-009  Health endpoint 200           → VER-009  Curl test
      SC-010  Health endpoint 503 on stop   → VER-003  Recovery test
      SC-015  Exponential backoff           → VER-003  Recovery test
    FR-002  Discord slash-command bot
      SC-001  Command response within 30s   → VER-001  Manual test
    FR-003  Bot token authentication
      SC-017  Auth via configured token          → VER-001
    FR-004  Reject unauthorised users
      BR-001  Authorised user by config ID
      SC-002  No response to unauthorised   → VER-002
      SC-012  Authorised user in config     → VER-002
    FR-005  Auto-restart after failure
      BR-002  Exponential backoff (5s–60s)
      SC-003  Recovery within 60s           → VER-003
      SC-015  Exponential backoff           → VER-003
    FR-009  Health endpoint
      SC-009  HTTP 200 when running         → VER-009  Curl test
      SC-010  HTTP 503 when stopped         → VER-003  Recovery test
    FR-013  Token rotation support
      SC-018  Token rotation via vault re-run    → VER-004

  HC-002  One-command clean VPS provisioning
    FR-006  Idempotent playbook
      SC-005  Second run: 0 changed         → VER-005  CI idempotency check
    FR-007  Playbook completes in <10 min
      SC-011  Measured completion time      → VER-004  CI syntax + run
    FR-012  Install all dependencies
      SC-013  Binary in /usr/local/bin      → VER-004  CI run
      SC-014  systemd unit present/enabled  → VER-004  CI run
    FR-010  UFW configuration
      SC-007  UFW: only SSH + HTTPS         → VER-007  CI check
    FR-008  Log rotation
      BR-003  Log retention: 14d compress, 30d delete
      SC-008  No logs older than 30 days    → VER-008  Script

  HC-003  Secrets absent from repo and logs
    FR-011  Secure token storage (Ansible Vault)
      SC-006  No secrets in repo or journal → VER-006  Scan script
      SC-016  Vault file not world-readable → VER-006  Scan script
    FR-004  Reject unauthorised users
      SC-002  No response to unauthorised   → VER-002  Manual test
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
- [x] Every mandatory FR has at least one SC
- [x] Every SC has a VER
- [x] Configuration reference documents every supported key
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
2. Produced a confirmed objective brief (OBJ-001, HC-001–HC-003).
3. Performed all 20 discovery steps, including domain research (Step 4),
   entity modelling (Step 6), exception analysis (Step 9), and
   documentation-gap-driven requirement discovery (Step 17).
4. Classified 5 decisions (A/B/C), resolved 4 autonomously, escalated 1 (C) to
   the human with a bounded recommendation.
5. Produced 13 functional requirements, 3 business rules, 18 detailed success
   criteria, and 9 verification methods.
6. Applied provenance labels to every requirement.
7. Reviewed the full set (0 critical, 1 warning, 1 suggestion).
8. Established full traceability from objective through to verification.
9. Did not produce a validation package (autonomous mode).
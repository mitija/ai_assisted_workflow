# Worked Example B: Breathing Exercise Application (Guided Mode)

> **Framework element in context.** Illustrative fictional content is presented
> as project material. Framework requirements (phases, artefact types, quality
> gates, identifier conventions) are the process being demonstrated. The project
> details are entirely fictional.

---

## Phase 1 — Intake

### Initial Q&A (illustrative)

**Analyst:** What problem are you solving?

**Human:** I want a simple breathing exercise app similar to existing ones like
Prana Breath or Breathe+. I want to guide users through configurable breathing
sessions with a visual guide. No account needed — just open and breathe.

**Analyst:** Who is it for?

**Human:** Anyone who wants a quick breathing exercise — stressed workers,
meditation beginners, people with anxiety. Should be usable without
instructions.

**Analyst:** What does success look like?

**Human:**
- I can pick a breathing pattern, start a session, and follow the visual guide.
- The app works on my phone's browser without downloading anything.
- Sessions can be paused and resumed.
- It's accessible — works with screen readers.
- I can see my session history.

**Analyst:** What are the important constraints?

**Human:** Mobile-first PWA. No backend — everything local in the browser. Free,
no ads. Offline-capable after first load.

**Analyst:** What's explicitly out of scope?

**Human:** User accounts, social features, payments, coach-led sessions, video
content, native mobile apps.

**Analyst:** What operating mode do you want?

**Human:** Guided mode, please. This is a new product and I want to review the
functional direction before you start building.

### Objective Brief (produced by analyst)

```
OBJ-001: Create a mobile-first breathing exercise PWA that guides
         users through configurable breathing sessions with visual
         cues, support for pause/resume, and local session history.
```

**Problem statement:** Existing breathing apps are good but many require
accounts, have ads, or are not usable offline. Users want a simple,
privacy-respecting alternative.

**Beneficiaries:** General public — stressed workers, meditation beginners,
people with anxiety.

**High-level success criteria:**
- HC-001: A user can select a pattern, start a session, and follow the guide.
- HC-002: The app works on a phone browser without installation.
- HC-003: Sessions can be paused and resumed.
- HC-004: The app is accessible to screen-reader users.
- HC-005: Session history is available locally.

**Constraints:** Mobile-first PWA, fully client-side (no backend), free, no ads,
offline-capable.

**Scope boundaries:** Browser-based only. Single-user per device. No accounts.

**Explicit exclusions:** User accounts, social features, payments, coach-led
sessions, video content, native mobile apps.

**Known integrations:** None. Standalone app.

**Assumptions:** Modern browser with Service Worker support. Touch or mouse
input. English language initially.

**Selected operating mode:** Guided

### Human confirmation

The human confirmed the objective brief. Phase 1 complete.

---

## Phase 2 — Discovery (20-step process)

### Step 1 — Frame the objective

The core outcome: a privacy-respecting, offline-capable PWA that lets any user
follow guided breathing exercises with configurable patterns, visual cues, and
session history — all without an account.

### Step 2 — Capture high-level success criteria

Recorded as HC-001 through HC-005 (see Objective Brief).

### Step 3 — Inspect existing evidence

Inspected: no existing codebase, no prior requirements. Domain research was
required.

### Step 4 — Research domain conventions

Researched common breathing patterns (box breathing, 4-7-8, physiological sigh),
existing breathing apps' UX patterns, WCAG accessibility guidelines for
screen-reader support, and PWA requirements (service worker, manifest, offline
caching).

### Step 5 — Identify actors, stakeholders and external systems

| Actor / System | Role | Interaction |
|---|---|---|
| User (primary) | Exercises breathing | Selects pattern, starts/pauses/stops session, views history |
| Browser | Runtime environment | Renders PWA, manages local storage, service worker |
| Screen reader | Assistive technology | Announces phase transitions and remaining time |

No external systems — fully client-side.

### Step 6 — Model entities, states and lifecycles

**BreathingPattern:** id, name, phases (sequence of inhale/hold/exhale/rest
with durations), description, category

**Session:** pattern, startedAt, phases (recorded actual timing per phase),
status (completed / paused / interrupted), completedAt

**Breathing phase lifecycle:** `inhale → hold → exhale → rest → [repeat]`

**Session lifecycle:** `ready → active → paused → active → ... → completed`

**App states:** `loading → ready → configuring → active → paused → completed`

### Step 7 — Generate candidate requirements

| ID | Statement | Provenance |
|---|---|---|
| FR-001 | The app shall provide a library of preset breathing patterns (box, 4-7-8, physiological sigh, simple). | explicitly-requested |
| FR-002 | Each breathing pattern shall define a sequence of phases with type (inhale/hold/exhale/rest) and duration in seconds. | domain-practice |
| FR-003 | The user shall be able to select a breathing pattern and start a session. | explicitly-requested |
| FR-004 | The app shall display a visual guide showing the current phase and its remaining time. | inferred-context |
| FR-005 | The app shall play an optional audio cue at each phase transition. | domain-practice |
| FR-006 | The user shall be able to pause and resume a session. | explicitly-requested |
| FR-007 | When a session is paused, the visual guide shall show a paused state with the current phase displayed. | design-decision |
| FR-008 | The app shall record completed sessions locally (pattern used, duration, date). | explicitly-requested |
| FR-009 | The app shall display a session history screen showing past sessions. | explicitly-requested |
| FR-010 | The app shall function offline after the first load. | explicitly-requested |
| FR-011 | The app shall announce phase transitions via screen reader (aria-live region). | explicitly-requested |
| FR-012 | The app shall support both touch (tap to start/pause) and keyboard (space to start/pause, escape to stop). | inferred-context |
| FR-013 | The app shall provide a visual countdown animation (expanding/contracting circle) mapped to the current breath phase. | domain-practice |
| FR-014 | The user shall be able to stop a session early, which records it as interrupted. | design-decision |
| FR-015 | The app shall show a completion screen with the session summary (pattern, duration, phases completed). | design-decision |

### Step 8 — Define business rules

| ID | Rule | Rationale | Provenance |
|---|---|---|---|
| BR-001 | A session must have completed at least one full breath cycle to be recorded as completed. Fewer cycles are recorded as interrupted. | Prevents accidental taps from creating meaningless history entries | design-decision |
| BR-002 | When a session is paused and then resumed, the current phase restarts from the beginning (remaining time resets to the full phase duration). | More natural for breathing — inhale always starts from the beginning of the inhale phase | human-requested-change |
| BR-003 | Audio cues are disabled by default; the user must opt in. | Avoids startling users; accessibility consideration | domain-practice |
| BR-004 | At most one session can be active at a time. Starting a new session while one is active prompts to end the current session first. | Prevents overlapping sessions and data ambiguity | design-decision |
| BR-005 | Session history is stored in localStorage and persists across browser sessions. | No backend; localStorage is the standard client-side option | domain-practice |
| BR-006 | A pattern with a total cycle time exceeding 120 seconds must show a warning before starting. | Some users may find long cycles challenging; informed consent | design-decision |

### Step 9 — Analyse exceptions, failures, recovery and edge cases

| Scenario | Expected behaviour |
|---|---|
| User closes browser during active session | Session is lost (no auto-save during active session); history unaffected |
| User navigates away and back | PWA maintains state via in-memory model; if browser killed, session is lost |
| localStorage is full | App shows a warning; oldest session history entries are purged to make room |
| Screen reader is active | aria-live region announces each phase transition with phase name |
| User resizes browser mid-session | Visual guide re-centres; layout adapts responsively |
| User starts session, immediately taps pause | Pause is honoured; session timer stops at ~0 elapsed |
| All patterns completed zero times | History screen shows "No sessions yet" empty state with guidance |
| Browser does not support Service Workers | App still works online; offline capability is degraded gracefully |

### Step 10 — Identify contradictions and gaps

Found one gap: no requirement for empty states on the history screen. Added
FR-016. Also noted that FR-004 (visual guide) and FR-013 (countdown animation)
could be merged — but they address different aspects (display of phase info vs
animation style), so kept separate.

| ID | Statement | Provenance |
|---|---|---|
| FR-016 | The history screen shall show an empty-state message when no sessions exist. | discovered-gap |

### Step 11 — Classify decisions

| Decision | Class | Rationale |
|---|---|---|
| Animation style (circle expansion vs linear bar) | A | Reversible, cosmetic; both convey the same info |
| Default audio: on or off | B | Affects first-run UX but easily changed |
| Pause behaviour: freeze vs restart phase | C | Material UX difference; personal preference matters |
| Session history storage limit | B | Must fit localStorage; exact number is adjustable |
| Colour palette (calming blues vs greens) | A | Reversible, cosmetic |
| Data persistence approach (localStorage vs IndexedDB) | B | Both work; localStorage is simpler for small data |

### Step 12 — Resolve non-blocking decisions (Class A and B)

| DEC | Decision | Rationale | Alternative |
|---|---|---|---|
| DEC-001 | Animation style: expanding/contracting circle | Most common in breathing apps; intuitive sense of lung expansion | Linear progress bar |
| DEC-002 | Default audio: off | Avoids startling; user opts in | Audio on by default |
| DEC-003 | Storage: localStorage | Simpler API; data volume is tiny (< 100 KB) | IndexedDB (more complex, overkill) |
| DEC-004 | Colour palette: calm blues (#1a5276 → #85c1e9 gradient) | Blue is associated with calm; works for both light/dark modes | Greens, purples |

### Step 13 — Escalate consequential decisions (Class C)

**DEC-005 — Pause-resume behaviour**

**Question:** When a paused session is resumed, where should it continue from?

**Recommendation:** Continue from the exact point in the current phase (freeze
behaviour). This is the most natural user expectation — pausing freezes time.

**Alternatives:**
1. Restart from the beginning of the current phase (simpler but may feel
   jarring — user loses progress within the phase)
2. Restart the entire session from the beginning (safest but wasteful)

**Human response:** "Freeze makes sense. Continue from the exact point."

### Step 14 — Define detailed success criteria

| SC | Statement | Maps to | Verification |
|---|---|---|---|
| SC-001 | User can select any preset pattern and start a session with one tap. | HC-001 | VER-001 |
| SC-002 | The visual guide shows the correct current phase name and remaining seconds. | HC-001 | VER-002 |
| SC-003 | The circle animation expands during inhale and contracts during exhale. | HC-001 | VER-003 |
| SC-004 | Tapping pause resets the current phase to 0 and shows the paused state. | HC-003 | VER-004 |
| SC-005 | After pause, tapping resume restarts the current phase from the beginning. | HC-003 | VER-004 |
| SC-006 | Audio cue plays at each phase transition when enabled; no audio when disabled. | HC-001 | VER-005 |
| SC-007 | Session can be paused and resumed at least 10 times in a single session without error. | HC-003 | VER-004 |
| SC-008 | Completed session appears in history within 1 second of completion. | HC-005 | VER-006 |
| SC-009 | Interrupted session appears in history as "interrupted" with partial data. | HC-005 | VER-006 |
| SC-010 | History empty state shows a helpful message when no sessions exist. | HC-005 | VER-006 |
| SC-011 | Screen reader announces "Inhale", "Hold", "Exhale", "Rest" at phase transitions. | HC-004 | VER-007 |
| SC-012 | App loads and works with no network connection after first visit. | HC-002 | VER-008 |
| SC-013 | App can be added to home screen on supported browsers. | HC-002 | VER-008 |
| SC-014 | Starting a second session while one is active shows a confirmation prompt. | HC-001 | VER-009 |
| SC-015 | Keyboard space starts/pauses; escape stops the session. | HC-004 | VER-010 |
| SC-016 | Patterns with cycle > 120s show a warning before session starts. | HC-001 | VER-011 |
| SC-017 | Session is recorded as "interrupted" when user stops before completing one full cycle. | HC-005 | VER-006 |
| SC-018 | Session is recorded as "completed" when user completes at least one full cycle and reaches the end. | HC-005 | VER-006 |
| SC-019 | Visual guide is centered and responsive (works at 320px–1200px width). | HC-002 | VER-002 |
| SC-020 | localStorage full triggers warning and oldest entries are purged. | HC-005 | VER-006 |

### Step 15 — Define verification methods

| VER | Method | What to check | Pass criteria |
|---|---|---|---|
| VER-001 | Manual test | Select pattern → tap start → session begins | Session starts within 1 tap of pattern selection |
| VER-002 | Visual inspection | Check phase display, remaining time, responsive layout | Correct phase/time shown at all widths 320–1200px |
| VER-003 | Visual inspection | Watch circle animation through a full cycle | Expands during inhale, contracts during exhale |
| VER-004 | Manual test | Pause, wait 5s, resume; repeat 10 times | Phase restarts from beginning each time |
| VER-005 | Manual test | Toggle audio on/off; start session | Audio plays when on, silent when off |
| VER-006 | Automated unit test | Complete session → check history; interrupt → check history; empty → check display | Correct status, data, and empty state |
| VER-007 | Automated test | Check aria-live region content during phase transitions | Correct phase name announced |
| VER-008 | Automated test | Load page, disconnect network, reload | App renders and functions |
| VER-009 | Manual test | Start session, tap start again | Confirmation prompt appears |
| VER-010 | Manual test | Press space → session starts; space → pauses; escape → stops | Correct behaviour |
| VER-011 | Manual test | Select long pattern (>120s cycle) → start | Warning shown before session begins |

### Step 16 — Draft intended documentation

#### User guide (illustrative excerpt)

**Starting a session:**
1. Open BreatheEasy in your browser.
2. Choose a breathing pattern from the library.
3. Tap "Start" to begin.
4. Follow the expanding circle — inhale as it grows, exhale as it shrinks.
5. Tap the screen (or press Space) to pause; tap again to resume.
6. Tap "Stop" (or press Escape) to end the session early.

**Session history:**
Your completed and interrupted sessions are stored on this device only. Tap the
history icon to view past sessions. Completed sessions show the pattern, date,
and duration. Interrupted sessions are marked with a note.

**Audio cues:**
Audio is off by default. Toggle it in settings before starting a session.

#### Configuration reference — breathing patterns (illustrative excerpt)

| Pattern | Phases | Total cycle | Description |
|---|---|---|---|
| Box (4-4-4-4) | inhale:4s, hold:4s, exhale:4s, rest:4s | 16s | Classic box breathing for focus |
| 4-7-8 | inhale:4s, hold:7s, exhale:8s | 19s | Relaxation breath |
| Physiological Sigh | inhale:3s, inhale:2s, exhale:7s | 12s | Quick stress reduction |
| Simple (4-6) | inhale:4s, exhale:6s | 10s | Gentle basic pattern |

#### Troubleshooting guide (illustrative excerpt)

| Symptom | Likely cause | Diagnosis | Fix |
|---|---|---|---|
| App doesn't load offline | Service worker not registered | Check Application > Service Workers in DevTools | Reload while online first |
| History is empty | No sessions completed | Complete a session | Normal behaviour |
| Screen reader silent | aria-live not supported | Test with NVDA/VoiceOver | Check browser support |
| Animation stutters | Weak device or many tabs | Close other tabs | Degraded but functional |

### Step 17 — Use documentation gaps to discover missing requirements

Writing the troubleshooting guide revealed that no requirement existed for
graceful degradation when the animation API is unavailable (e.g., older
browsers). Added FR-017. Additionally, documenting responsive breakpoints
revealed no explicit requirement for responsive rendering across device widths
— added FR-018.

| ID | Statement | Provenance |
|---|---|---|
| FR-017 | The app shall show a text-based phase indicator (phase name + remaining seconds) as a fallback if animation rendering fails. | discovered-doc-gap |
| FR-018 | The app shall render correctly and be usable at screen widths from 320px to 1200px. | discovered-doc-gap |

### Step 18 — Produce wireframes

```
┌──────────────────────────┐
│  BreatheEasy              │
│                           │
│  Choose your pattern      │
│                           │
│  ┌─────────────────────┐  │
│  │ ○ Box (4-4-4-4)     │  │
│  │   Classic 16s cycle │  │
│  ├─────────────────────┤  │
│  │ ○ 4-7-8             │  │
│  │   Relaxation 19s    │  │
│  ├─────────────────────┤  │
│  │ ○ Physiological     │  │
│  │   Sigh 12s          │  │
│  ├─────────────────────┤  │
│  │ ○ Simple (4-6)      │  │
│  │   Gentle 10s        │  │
│  └─────────────────────┘  │
│                           │
│  [ Start ]                │
└──────────────────────────┘
  Pattern selection screen
```

```
┌──────────────────────────┐
│  BreatheEasy     [≡]     │
│                           │
│                           │
│       ╭───────╮          │
│      ╱  Inhale  ╲        │
│     │    3s     │         │
│      ╲         ╱         │
│       ╰───────╯          │
│                           │
│  ○─────●─────────○       │
│  Inhale Hold  Exhale Rest│
│                           │
│  [ ⏸ Pause ]  [ ⏹ Stop ]│
└──────────────────────────┘
  Active session screen
```

```
┌──────────────────────────┐
│  BreatheEasy     [≡]     │
│                           │
│       ╭───────╮          │
│      ╱ Paused  ╲         │
│     │  Inhale  │         │
│     │   2s/3s  │         │
│      ╲         ╱         │
│       ╰───────╯          │
│                           │
│  [ ▶ Resume ] [ ⏹ Stop ]│
└──────────────────────────┘
  Paused session screen
```

```
┌──────────────────────────┐
│  BreatheEasy     [≡]     │
│                           │
│     ✓ Session Complete!  │
│                           │
│   Pattern: 4-7-8         │
│   Duration: 3m 48s       │
│   Cycles: 12             │
│                           │
│  [ New Session ]         │
│  [ View History ]        │
└──────────────────────────┘
  Completion screen
```

```
┌──────────────────────────┐
│  BreatheEasy     [≡]     │
│                           │
│  Session History         │
│                           │
│  ┌─────────────────────┐  │
│  │ Today               │  │
│  │ 4-7-8  ·  3m 48s    │  │
│  │ 10:30 AM · Completed│  │
│  ├─────────────────────┤  │
│  │ Yesterday           │  │
│  │ Box  ·  2m 40s      │  │
│  │ 8:15 PM · Interrupted│ │
│  └─────────────────────┘  │
│                           │
│  [ Back ]                 │
└──────────────────────────┘
  History screen (populated)
```

```
┌──────────────────────────┐
│  BreatheEasy     [≡]     │
│                           │
│  Session History         │
│                           │
│       ╭─────────╮        │
│      ╱  No sessions      │
│     │   yet. Start       │
│     │   your first       │
│     │   breathing        │
│     │   exercise!        │
│      ╲                 ╱ │
│       ╰─────────╯        │
│                           │
│  [ Start Breathing ]     │
└──────────────────────────┘
  History screen (empty state)
```

### Step 19 — Requirements quality review

**Critical (0):** None found.

**Warning (3):**
1. FR-004 and FR-013 partially overlap (both describe visual elements of the
   guide). Re-clarified: FR-004 covers display of phase info, FR-013 covers the
   animation style. Kept separate.
2. SC-003 does not specify direction (expand for inhale, contract for exhale)
   — added.
3. FR-014 (stop early) has no requirement for user confirmation before stopping.
   Added that behaviour to FR-014.

**Suggestion (2):**
1. Consider adding a "rounds" or "cycles" configuration option.
2. Consider adding a "cooldown" phase after session completion.

### Step 20 — Produce requirements baseline

Consolidated all artefacts in preparation for the guided validation package.

---

## Phase 3 — Review (guided mode: validation package)

### Functional Validation Package (proposal — shown as presented to the human)

#### Refined functional outcome

BreatheEasy is a mobile-first PWA that lets users select from preset breathing
patterns, follow an animated visual guide through each phase, pause and resume
sessions, optionally enable audio cues, and review their session history — all
offline, without an account, and with screen-reader support.

#### Scope boundaries

**In scope:** Pattern library, animated visual guide, pause/resume, session
history, accessibility (screen reader, keyboard), offline PWA, responsive
design.

**Out of scope:** Accounts, social sharing, payments, coach-led sessions, video,
native apps, custom pattern creation (v1), analytics, notifications.

#### Main user journeys

1. **Quick session:** Open app → select pattern → start → follow guide →
   complete → see summary → view history.
2. **Interrupted session:** Open app → select pattern → start → pause (phone
   call) → resume → stop early → see interrupted entry in history.
3. **Accessible session:** Screen reader on → select pattern → start → hear
   phase announcements → complete → hear summary.
4. **Offline session:** Load app while online → disconnect → start pattern →
   complete → history stored locally.

#### Key business rules (as proposed)

- BR-001: Minimum one full breath cycle for "completed" status.
- BR-002: Pause freezes time; resume continues from exact point. *(overridden by human — see propagation below)*
- BR-003: Audio off by default.
- BR-004: Only one active session at a time.
- BR-005: Session history in localStorage.
- BR-006: Long-pattern warning (>120s cycle).

#### Important exceptions

- Browser close during session: session lost (acceptable for v1).
- localStorage full: warning + oldest entries purged.
- No network: app functions normally (cached via service worker).

#### Significant assumptions

- Modern browser with Service Worker, requestAnimationFrame, and
  localStorage support.
- Touch or keyboard input available.
- English-only for v1.

#### Decisions made autonomously (Class A/B)

| DEC | Decision | Rationale |
|---|---|---|
| DEC-001 | Expanding/contracting circle animation | Industry standard for breathing apps |
| DEC-002 | Audio off by default | User opt-in avoids startling |
| DEC-003 | localStorage for history | Simple, sufficient for data volume |
| DEC-004 | Calm blue colour palette | Evidence-based association with calm |

#### Decisions requiring confirmation (as proposed)

| DEC | Question | Human response |
|---|---|---|
| DEC-005 | Pause freezes vs restarts phase | Freeze (continue from exact point) |

#### Low-fidelity wireframes

(See Step 18 above — five wireframes: pattern selection, active session, paused
session, completion screen, history populated, history empty state.)

#### Detailed success-criteria coverage

| HC | Covered by SCs | Count |
|---|---|---|
| HC-001 | SC-001, SC-002, SC-003, SC-006, SC-014, SC-016, SC-019 | 7 |
| HC-002 | SC-012, SC-013, SC-019 | 3 |
| HC-003 | SC-004, SC-005, SC-007 | 3 |
| HC-004 | SC-011, SC-015 | 2 |
| HC-005 | SC-008, SC-009, SC-010, SC-017, SC-018, SC-020 | 6 |

#### High-level traceability summary

```
OBJ-001  Breathing exercise PWA
  HC-001  User can follow a session
    → FR-001 (pattern library), FR-002 (phase sequence),
      FR-003 (start session), FR-004 (visual guide),
      FR-005 (audio cues), FR-013 (animation)
      → SC-001–SC-003, SC-006, SC-014, SC-016
  HC-002  Works on phone browser
    → FR-010 (offline PWA)
      → SC-012, SC-013, SC-019
  HC-003  Pause and resume
    → FR-006 (pause/resume), FR-007 (paused state)
      → SC-004, SC-005, SC-007
  HC-004  Accessible
    → FR-011 (screen reader), FR-012 (keyboard/touch)
      → SC-011, SC-015
  HC-005  Session history
    → FR-008 (record sessions), FR-009 (history display),
      FR-016 (empty state)
      → SC-008–SC-010, SC-017, SC-018, SC-020
```

#### Explicit exclusions and limitations

- No custom pattern creation (v1 uses presets only).
- Session in progress is lost if browser is closed (no auto-save).
- English only (no i18n in v1).
- No dark mode configuration (uses system preference only).
- No session statistics or trends.

### Human review decision

**Human response:** "Approved with changes. I want pause to restart the current
phase from the beginning, not freeze it. I changed my mind — starting from the
beginning of the phase feels more natural for breathing exercises."

### Propagate feedback

The analyst identified and updated every affected artefact:

| Artefact | Change |
|---|---|
| BR-002 | Changed from "exact point" to "beginning of current phase" |
| FR-004 / FR-007 | Updated pause description to reflect phase restart |
| SC-004 | "Pause freezes the session timer" → "Pause resets the current phase to 0" |
| SC-005 | "Continue from exact point" → "Resume from beginning of current phase" |
| SC-007 | Removed "preserves elapsed time" assertion |
| User guide | Updated "Pause and Resume" section |
| Active session wireframe | Updated pause annotation |
| Traceability links | Updated to reflect changed SC-004, SC-005 |
| Decisions record | Added note: DEC-005 overridden by human during validation |

### Updated BR-002

```
BR-002: When a session is paused and then resumed, the current phase
        restarts from the beginning (remaining time resets to the phase
        duration).
        Rationale: More natural for breathing — inhale always starts
        from the beginning of the inhale phase.
        Provenance: human-requested-change (post-validation)
```

### Consistency check after propagation

All six cross-artefact checks passed. No contradictions introduced.

### Final approval

**Human response:** "Approved. Proceed."

---

## Phase 4 — Baseline

### Traceability chain (summary)

```
OBJ-001  BreatheEasy PWA
  HC-001  User can follow a session
    FR-001  Pattern library (4 presets)
      BR-006  Warning if cycle > 120s
      SC-001  Select and start with one tap       → VER-001
      SC-016  Warning shown for long patterns      → VER-011
    FR-002  Phase sequence with durations
      (covered by SC-001, SC-002)
    FR-003  Start session
      BR-004  Only one active session at a time
      SC-001  One-tap start                       → VER-001
    FR-004  Visual guide (phase + remaining time)
      SC-002  Correct phase and time              → VER-002
      SC-019  Responsive 320–1200px               → VER-002
    FR-005  Optional audio cues
      BR-003  Audio off by default
      SC-006  Audio on/off honoured               → VER-005
    FR-006  Pause and resume
      BR-002  Phase restarts on resume
      SC-004  Pause resets current phase           → VER-004
      SC-005  Resume from phase beginning          → VER-004
      SC-007  Can pause/resume 10+ times           → VER-004
    FR-007  Visual paused state
      SC-004  Paused state shown                   → VER-004
    FR-013  Circle animation
      SC-003  Expand/contract mapped to phase      → VER-003
    FR-014  Stop early → interrupted
      SC-017  Interrupted if <1 cycle              → VER-006
    FR-015  Completion screen
      SC-018  Completed session recorded           → VER-006
    FR-017  Text fallback for animation
      (covered by SC-002: phase name + time)

  HC-002  Works on phone browser (PWA)
    FR-010  Offline-capable
      SC-012  Works offline                       → VER-008
      SC-013  Add to home screen                  → VER-008
    FR-018  Responsive design
      SC-019  Works at 320–1200px                  → VER-002

  HC-003  Pause and resume
    FR-006  Pause/resume (restart phase)
      BR-002  Phase restarts on resume
      SC-004  Pause resets phase                  → VER-004
      SC-005  Resume from phase beginning         → VER-004
      SC-007  10+ pause/resume cycles             → VER-004

  HC-004  Accessible
    FR-011  Screen reader announcements
      SC-011  aria-live phase names               → VER-007
    FR-012  Touch + keyboard input
      SC-015  Space = pause, Esc = stop           → VER-010

  HC-005  Session history
    FR-008  Record sessions locally
      SC-008  Completed in history within 1s      → VER-006
      SC-009  Interrupted with partial data       → VER-006
      SC-017  <1 cycle = interrupted              → VER-006
      SC-018  1+ cycle = completed                → VER-006
    FR-009  History display
      SC-008  Completed entry                     → VER-006
      SC-009  Interrupted entry                   → VER-006
    FR-016  Empty state
      SC-010  Helpful empty message               → VER-006
    BR-005  localStorage persistence
      SC-020  Warning + purge on storage full      → VER-006
      (covered by SC-008, SC-009)
```

### Decisions recorded

| DEC-ID | Decision | Class | Status |
|---|---|---|---|
| DEC-001 | Expanding/contracting circle animation | A | Autonomous |
| DEC-002 | Audio off by default | B | Autonomous |
| DEC-003 | localStorage for history | B | Autonomous |
| DEC-004 | Calm blue colour palette | A | Autonomous |
| DEC-005 | Pause: restart current phase (freeze → overridden) | C | Human confirmed (updated post-validation) |

### Validation decision

**Result:** Approved with changes (pause behaviour overridden).

**Feedback propagation:** Completed — BR-002, FR-004, FR-007, SC-004, SC-005,
SC-007, user guide, wireframe annotations, and traceability all updated
consistently.

### Documentation completeness gate

- [x] OBJ-001 represented in requirements
- [x] BR-001–BR-006 documented (BR-002 updated post-validation)
- [x] All requirements traceable (see traceability chain)
- [x] Every mandatory FR has at least one SC
- [x] Every SC has a VER
- [x] User guide covers all main workflows
- [x] Configuration reference documents all breathing patterns
- [x] Troubleshooting guide covers common failure modes
- [x] Known limitations documented
- [x] All autonomous decisions recorded (DEC-001–DEC-004)
- [x] Human-confirmed decisions identifiable (DEC-005, validation override)
- [x] No contradictions between artefacts (cross-checked after propagation)

### Known limitations

- Session in progress is lost if browser/tab is closed.
- Custom pattern creation deferred to v2.
- English only (no i18n).
- Dark mode follows system preference (no manual toggle).
- No session statistics or trends (raw history only).

---

## Example summary

This example demonstrates the complete analyst workflow in guided mode for a
UI-heavy application with accessibility requirements. The analyst:

1. Conducted a focused high-level Q&A (9 questions).
2. Produced a confirmed objective brief (OBJ-001, HC-001–HC-005).
3. Performed all 20 discovery steps, including domain research (Step 4),
   entity/session modelling (Step 6), exception analysis (Step 9), and
   documentation-gap-driven requirement discovery (Step 17).
4. Produced 18 requirements, 6 business rules, 20 success criteria, and 11
   verification methods.
5. Applied provenance labels to every requirement.
6. Produced 6 ASCII wireframes (pattern selection, active session, paused,
   completion, history populated, history empty).
7. Reviewed the full set (0 critical, 3 warnings, 2 suggestions).
8. Created a curated functional validation package for human review.
9. Received "approved with changes" — the human overrode the pause-behaviour
   decision.
10. Propagated the feedback across all 11 affected artefacts (BR-002, FR-004,
    FR-007, SC-004, SC-005, SC-007, user guide, wireframe, traceability links,
    decisions record).
11. Confirmed consistency after propagation — no contradictions introduced.
12. Established full traceability from objective through verification.
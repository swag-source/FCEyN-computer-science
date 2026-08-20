# Study Structure — Teoría de los Lenguajes (recursada)

## Context

Single course, second pass. The syllabus is already familiar: this is **not** a first-contact plan, and treating it like one is the main way to waste the advantage. Constraints:

- **Class:** attending **prácticas only** (no teóricas). The práctica is the weekly anchor and the main forcing function for problem-solving.
- **Study budget:** ~8-10h/week of deliberate work outside class.
- **Exams:** 2 parciales + recuperatorio + final.
- **Core rule (carried over, still the metric that matters):** for *each* exam, that exam's syllabus must be **Green** (§8) **7 days before the date**. The last week is pure past-exam practice, never first-pass learning.

Dates below are relative weeks, with **Week 1 = 17-23 Aug 2026** as the working assumption for the 2°C 2026. Pin real dates as soon as the cátedra publishes them and shift phase boundaries accordingly — the phase *order* is what's load-bearing, not the week numbers.

---

## 1. What changes because you've already taken this course

| | First pass | This pass |
|---|---|---|
| Bottleneck | Understanding the definitions | **Recall speed + proof construction under time pressure** |
| Right ratio | ~50% reading / 50% practice | **~85% practice from week 1** |
| First move on a topic | Read the teórica, then try problems | **Try the problems cold, read only what the attempt exposes** |
| Main failure mode | Getting lost | **False familiarity** — "I know this" from recognition, not from being able to produce it |

**The recursante trap, explicitly:** recognition ≠ production. You will read a pumping-lemma proof and feel it's obvious, then fail to construct one for a new language under 40 minutes of exam pressure. Every topic in this plan is graded on *what you can produce from a blank page*, never on whether it looks familiar.

**Three concrete consequences:**
1. **Diagnostic first, plan second.** Week 1 is a cold past parcial (§4, Phase 0). What survived from last time is unknown until measured, and half this plan's value is discovering which third of the syllabus actually needs the hours.
2. **Never skip a guía exercise because you solved it last year.** Solve it again from scratch, or explicitly mark it Green after solving *one variant* of it cold. Those are the only two allowed options.
3. **You can afford depth on the hard third.** The time you save on DFA/NFA mechanics goes to the bottlenecks (§3), not to finishing early.

---

## 2. Topic map — strictly linear chain, split by exam

```
Definición de lenguaje formal + Jerarquía de Chomsky        (orientation)
   │
┌──┴─────────────────── PARCIAL 1 ──────────────────────────┐
│                                                            │
│  Lenguajes regulares: AFD → AFND → expresiones regulares   │  ◄── must be automatic
│     │                                                      │
│  Lenguajes NO regulares + Lema de bombeo (regular)         │  ◄── BOTTLENECK #1
│     │                                                      │
│  Lenguajes libres de contexto → autómatas de pila (AP)     │
│     │                                                      │
│  Lenguajes determinísticos (DCFL)                          │  ◄── subtlety layer
│     │                                                      │
│  Lenguajes NO libres de contexto + Lema de bombeo (LC)     │  ◄── BOTTLENECK #2
└────────────────────────────────────────────────────────────┘
   │
┌──┴─────────────────── PARCIAL 2 ──────────────────────────┐
│                                                            │
│  Máquinas de Turing (determinísticas)                      │
│     │                                                      │
│  Funciones parcialmente computables → Tesis de Church      │
│     │                                                      │
│  Lenguaje S++ y codificación de programas                  │  ◄── formalism shift
│     │                                                      │
│  Intérprete universal                                      │
│     │                                                      │
│  Halting problem + Diagonalización                         │  ◄── BOTTLENECK #3
│     │                                                      │
│  Lenguajes computables y computablemente enumerables       │  ◄── synthesis
└────────────────────────────────────────────────────────────┘
   │
FINAL = both blocks + the connections between them (§6, Phase 5)
```

**Confirm the split with the cátedra in Week 1.** Some years Parcial 1 stops at the pumping lemma for regulars and Parcial 2 absorbs the whole CFL block. If that's the case, shift Phase 2 one exam later — everything else in this plan holds unchanged.

The chain is genuinely cumulative: weak AFD/AFND fluency multiplies the cost of every later topic, and a shaky grasp of "reducción" in the halting block makes the computable/c.e. synthesis unlearnable rather than merely hard.

---

## 3. Risk classification

**🔴 High risk — these get the protected hours, never let them slip inside the 1-week buffer:**

- **Lema de bombeo (regular y libre de contexto).** The classic "I understand it, I can't apply it" topic. The failure is never the statement of the lemma — it's picking the right word `w`, handling *every* case of the adversary's decomposition, and not silently assuming the pumping constant. Needs many *new* languages, not re-reading old proofs.
- **Halting problem + diagonalización.** Abstract proof technique. Needs enough worked variants that the *shape* of the argument (assume decider → build contradictory program → apply to itself) becomes reflex.
- **Computables vs. computablemente enumerables.** Synthesis topic and reliably exam-heavy: c.e. but not computable, closure properties, complement arguments, reductions. Depends on everything before it.
- **DCFL / non-context-freeness subtleties.** Knowing *why* a language is not deterministic (and not just not context-free) is a distinct skill from the pumping lemma, and it decays fast without practice.

**🟡 Medium risk:**

- **Autómatas de pila** — construction skill, mechanical once the pattern is there, but the equivalence with grammars needs real reps.
- **Máquinas de Turing + funciones parcialmente computables** — new-ish formalism, more mechanical than it looks once you've built 3-4 machines.
- **S++ / codificación de programas / intérprete universal** — heavy notation, low conceptual difficulty. Danger is notational sloppiness under pressure, not misunderstanding.

**🟢 Lower risk (verify, don't invest):**

- **Jerarquía de Chomsky** — orientation. Should cost one session, ever.
- **AFD / AFND / expresiones regulares** — assume this is your strongest area from last time, but *verify it in Week 1 rather than assuming*. If the diagnostic shows it's not automatic, it is instantly 🔴 and Phase 1 doubles in length: everything downstream is priced off this fluency.
- **Tesis de Church** — conceptual, discussable, low mechanical load.

---

## 4. Roadmap

### Phase 0 — Week 1 (17-23 Aug): diagnostic, not study

The single highest-leverage week. Do not start "reviewing from the beginning."

1. Get past parciales and finales (cátedra page, classmates, previous years). Build `notes/parciales/`.
2. **Take one full past Parcial 1 cold, timed, no notes.** It will go badly in places. That's the data.
3. Grade it against §8's Red/Yellow/Green and fill in the tracker (§7) for every topic in §2.
4. Do the same for a past Parcial 2 — untimed, and just *attempt* it. You're mapping which computability topics evaporated, not scoring yourself.
5. Confirm with the cátedra: exam dates, the exact P1/P2 split, and whether the final is written, oral, or both.

**Output of Week 1:** a per-topic Red/Yellow/Green map. Phases 1-4 below get re-weighted against it — Green topics get maintenance reps only, Red topics get the deep blocks.

### Phase 1 — Weeks 2-4: bloque regular

Regulares → AFD/AFND → expresiones regulares → lenguajes no regulares + lema de bombeo.

- Weeks 2-3 compress the mechanical part hard: conversions (AFND→AFD, regex↔autómata), minimization, closure constructions. If the diagnostic showed this Green, **two sessions total**, then move on.
- Reinvest the saved time in **week 4 = pumping lemma (regular), a full week for one topic.** Bottleneck #1 gets a disproportionate allocation on purpose.

### Phase 2 — Weeks 5-7: bloque libre de contexto

Gramáticas libres de contexto → autómatas de pila → determinísticos → no libres de contexto + lema de bombeo (LC).

- Week 5: gramáticas + AP construction, both directions of the equivalence.
- Week 6: DCFL — what determinism buys you (closure under complement) and what it costs.
- Week 7: pumping lemma para LC + closure-property arguments. **Bottleneck #2.**

### Weeks ~7-8: Parcial 1 consolidation

Per the core rule: syllabus Green by the **end of Week 6**, wherever Parcial 1 actually lands. The final 7 days are timed past parciales only — full papers, exam conditions, then error-log every mistake (§5). No new material. No re-reading teóricas.

### Phase 3 — Weeks 9-11: computabilidad, primera mitad

Máquinas de Turing → funciones parcialmente computables → Tesis de Church.

This is the formalism shift, and it's where the recursada advantage is largest — you already know where this is going. Build machines by hand early (Week 9), don't let it stay abstract.

### Phase 4 — Weeks 12-14: computabilidad, segunda mitad

S++ y codificación de programas → intérprete universal → halting problem → diagonalización → computables y c.e.

- Week 12: S++ / codificación / intérprete universal. Mechanical, notation-heavy, moves fast.
- Week 13: **halting + diagonalización. Bottleneck #3, full week.**
- Week 14: computables vs. c.e. — reductions, closure, complement arguments. This is where the whole course integrates.

### Weeks ~14-15: Parcial 2 consolidation

Same rule: Green by end of Week 13. Final week = timed past parciales + error log.

### Phase 5 — Final prep (post-parciales / turno de examen)

The final is not "both parciales again" — it's the **connections**, which neither parcial tests:

- **Classification drills.** Given an arbitrary language, place it in the hierarchy and *prove* the placement. This single exercise type integrates the entire course and should be the backbone of final prep.
- Closure-property tables reproduced from memory for each class (regular / LC / DCFL / computable / c.e.), including which operations *break* which class and why.
- The proof techniques side by side: when do you reach for pumping vs. closure properties vs. reduction vs. diagonalization? Being able to *choose* the technique is the actual final-exam skill.
- If the final is **oral**: rehearse out loud, without notes, against a whiteboard. Include "why is this hypothesis necessary?" and "give me a counterexample if we drop it" — the standard oral follow-ups.

**Recuperatorios** land in/around Weeks 16-17 if needed. If you take one, that week's plan is: error log for that parcial → targeted repair of only the Red topics → one fresh timed paper.

---

## 5. Weekly structure (~9h, steady state)

The práctica is the spine. Everything else hangs off it.

| Slot | Time | Type | What happens |
|---|---|---|---|
| **Práctica (class)** | fixed | Attend | Attempt problems live. Mark every exercise you couldn't start unaided — that list drives the week. |
| **Same night** | 20-30 min | Capture | Write up what got solved *in class* into `notes/practica/`, in your own words. Not transcription. Cheapest retention win of the week. |
| **Práctica + 1 day** | ~1h | **Retrieval** | Redo, from a blank page, the two problems you couldn't start in class. No notes on the first attempt. |
| **Midweek** | ~1.5h | **Deep block** | The week's hardest topic. New constructions, proofs built from scratch. Schedule this when your energy is actually good — it's the block that carries the phase. |
| **Late week** | ~1.5h | **Problem set** | Volume over depth: many short exercises across the current phase's topics. |
| **Weekend AM** | ~3h | **Main block** | Split: ~90 min hard/new work, break, ~90 min mixed problems including one topic from an *earlier* phase (spaced review, §7). |
| **Weekend PM/eve** | ~1.5h | **Review + checkpoint** | Cold recall of the week, spaced-review touchpoints, error log, checkpoint (§7). In consolidation weeks this becomes a timed exam simulation instead. |

**≈ 9h/week.** In the 7 days before any exam, the whole budget converts to timed past papers + error-log repair. Nothing else.

### The error log — do not skip this

One file: `notes/errores.md`. Every mistake on a practice problem or past exam gets one line: **what I got wrong → why (concept gap? notation slip? misread? time?) → the corrected idea in one sentence.**

For a recursante this is worth more than any set of notes, because your errors are now *specific and repeating*, not diffuse. Re-read it before every exam. Patterns show up within three weeks — most people find they have four or five recurring mistakes, not fifty.

### Active techniques (the only things that count as studying)

Construct AFDs/AFNDs/regex for a language *description* you haven't seen; convert between all three representations; minimize; prove regularity and non-regularity on **new** languages every time; build gramáticas and APs in both directions of the equivalence; prove non-context-freeness; construct Turing machines by hand; write and encode S++ programs; reproduce the diagonalization argument from scratch on a blank page; build reductions to prove non-computability; classify arbitrary languages in the hierarchy with proof.

**Rule for the whole plan:** if a session produced nothing — no proof, no automaton, no solved problem, no explanation spoken aloud without notes — it wasn't a study session. It was reading, and reading is exactly the failure mode a second pass is most vulnerable to.

---

## 6. Repo workflow

The plan and the notes live in the same branch on purpose. Suggested layout:

```
notes/
  teorica/     ← per-class conceptual notes (Clase 1 already here)
  practica/    ← solved guías, one file per guía
  parciales/   ← past exams + your timed attempts, with grades
  errores.md   ← the error log (§5) — single file, append-only
```

Commit per session, small and incremental — per the README's convention. The commit log doubles as an honest record of how much real work happened each week, which is useful input for the Sunday checkpoint.

---

## 7. Tracker, spaced review, checkpoint

**Per-topic cycle:** Learn/refresh → retrieval within 3 days → practice within a week → **revisit 2-3 weeks later** → timed practice in the final week before its exam.

**Tracker:** one table (a note in this repo is fine) — `Topic | Status (R/Y/G) | Last practiced | Revisit due | Exam (P1/P2/Final)`. Updated once a week, at the checkpoint. No app, no algorithm.

**Weekly checkpoint (15-20 min, weekend), in writing:**

1. What can I now produce from a blank page that I couldn't last week?
2. Which topics moved status? Which moved *backwards*?
3. Am I ahead or behind the "Green 1 week before" line for the next exam?
4. What does the error log say — any repeat offender showing up a third time?
5. How many hours were real practice vs. reading? (If reading > 25%, correct next week.)
6. Priority for next week: one topic, named.

---

## 8. Mastery criteria

**🔴 Red** — Recognize it, explain it roughly with notes open. Cannot solve a representative problem unaided.

**🟡 Yellow** — Explain it from memory. Solve the *standard* problem, but stall on a variation or run out of time. **For a recursante, Yellow is the default state of anything you haven't actively produced this term** — familiarity reads as Green and almost never is.

**🟢 Green** — Explain from memory, unprompted. Solve a representative problem *and* a variation, at exam speed. Identify why a plausible-looking wrong answer fails (a bad word choice in a pumping proof, an AP that isn't deterministic, a reduction pointing the wrong way). Connect it to at least one earlier topic it depends on.

Only Green counts toward the 1-week-early rule.

---

## 9. Recovery protocol

**Cut in this order:** late-week problem set → weekend PM block (never the checkpoint itself, just shorten it) → the current phase's 🟢 topics.

**Never cut:** práctica attendance, the 20-30 min same-night capture, the weekly checkpoint, and whichever 🔴 topic is active that week.

**Recovering 1-2 lost weeks:** don't cram it into one heroic weekend — proof-construction skill doesn't build that way. Extend the midweek and late-week blocks by ~30 min for 2-3 weeks and convert one weekend AM into a catch-up block. **Never recover time by eating the 7-day pre-exam buffer** — that buffer is what converts Yellow into Green, and spending it is how a "prepared" exam turns into a failed one.

**Unsustainability signal:** two consecutive checkpoints reporting "behind" with no realistic catch-up slot, or a 🔴 topic still Red inside its exam's final week. The response is to *narrow scope deliberately* — accept a thin pass on 🟢 topics and defend the bottlenecks — not to add hours and hope.

---

## Immediate next steps (Week 1)

- [ ] Confirm exam dates, the P1/P2 topic split, and the final's format (written / oral / both). Then pin every phase boundary in §4 to real dates.
- [ ] Collect past parciales and finales into `notes/parciales/`.
- [ ] **Take one past Parcial 1 cold and timed.** This is the week's actual deliverable.
- [ ] Attempt a past Parcial 2 untimed, to map what survived from the computability half.
- [ ] Fill the tracker (§7) with all topics from §2, honestly graded against §8 — anything you haven't produced this term starts Yellow at best.
- [ ] Create `notes/errores.md` and log the diagnostic's mistakes as its first entries.
- [ ] Re-weight Phases 1-4 against the diagnostic and note the changes here.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Machine-checked **TLAPS deductive safety proofs** for the Vortex DSE default late-tolerant C-slot admission model. This is one slice of the Vortex DSE public formal bundle — see `vasilisnasopoulos-stack` for how all slices fit together.

## Running the proofs

```sh
tlapm --toolbox 0 0 specs/Vortex_DSE_CSlot_Proofs.tla
```

Expected output: `All 194 obligations proved.`

TLAPS must be installed separately. These are unbounded deductive proofs, not model-checking runs — they hold for any `Nodes`, `MsgIDs`, and finite `MaxSlot`, not just small enumerated instances.

## Spec structure

Two files, intended to be read in order:

- **`specs/Vortex_DSE_CSlot.tla`** — the model: constants, variables, actions, invariants, and fairness.
- **`specs/Vortex_DSE_CSlot_Proofs.tla`** — the TLAPS proof module; extends the model and proves two theorems.

### Model (`Vortex_DSE_CSlot.tla`)

**State:** `current_slot` (monotonic integer), `network` (set of `{id, cslot}` records — unordered, models arbitrary reorder/delay), `processed[n]` (RAM — lost on crash), `persisted[n]` (mmap snapshot — survives crash), `node_state[n]`.

**Actions:**
- `Submit(id)` — stamps `cslot = current_slot` at emission time; delivers later (nondeterministically).
- `Process(n, m)` — admission gate: `m.cslot ≤ current_slot`. Late messages admitted into their own earlier slot; nothing dropped.
- `Crash(n)` / `Rejoin(n)` — crash loses RAM; rejoin restores `processed[n] := persisted[n]`.
- `DuplicateInject(id, fake_cslot)` — adversarial replay with arbitrary cslot; the gate still holds.
- `Tick` — advances `current_slot` by 1.

**Safety invariants:** `TypeInvariant`, `NoFutureAdmission` (headline), `ExactlyOncePerNode`, `NoPhantomProcess`, `PersistedReflectsReality`, `DecisionLocalityOnly`.

**Liveness (`LiveSpec`):** `SF(Tick)`, `WF(Rejoin(n))`, `SF(Process(n))` → yields `EventualAdmission` (every message in the network is eventually admitted by every up node).

### Proof module (`Vortex_DSE_CSlot_Proofs.tla`)

Proves two theorems via the standard **inductive invariant pattern** — Init ⇒ Inv, then Inv ∧ [Next]_vars ⇒ Inv', then PTL closes the temporal argument:

- **`TypeCorrect`**: `Spec ⇒ □TypeInvariant`
- **`NoFutureAdmissionCorrect`**: `Spec ⇒ □NoFutureAdmission`

**Key design choice — strengthened invariant:** `NoFutureAdmission` alone is not inductive because `Rejoin` sets `processed[n] := persisted[n]`, and nothing in `NoFutureAdmission` constrains `persisted`. The proof uses:

```tla
SafeInv == TypeInvariant /\ NoFutureAdmission /\ PersistedSafe
```

`PersistedSafe` mirrors `NoFutureAdmission` over `persisted`. The two safety conjuncts close mutually: `Crash` feeds `PersistedSafe` from `NoFutureAdmission`; `Rejoin` feeds `NoFutureAdmission` from `PersistedSafe`.

## What this repo does NOT prove

- Liveness (`EventualAdmission`) — stated in `LiveSpec` but not TLAPS-proved here.
- The strict same-slot admission variant (lives in `vortex-dse-cslot-spec`).
- Agreement / Merkle layer (lives in `vortex-merkle-agreement`).
- Any composition between this slice and the next layer.

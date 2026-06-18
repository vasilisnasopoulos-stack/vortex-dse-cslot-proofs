> **Vortex DSE formal surface** · [Proofs (default + TLAPS)](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) · [Strict spec + TLC](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) · [Merkle agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) · [Profile](https://github.com/vasilisnasopoulos-stack)
>
> Production C engine is **not** public. This repo is the **default late-tolerant model + TLAPS proofs**. Strict variant → spec repo.

> **Vortex public research bundle**
>
> This repository is one part of the public Vortex DSE verification bundle.
>
> [Spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) · [Proofs](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) · [Merkle Agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement)

# Vortex DSE — Formal Verification Index

> **Part of one machine:** this repo checks the **admission layer** (default
> C-slot model, `m.cslot ≤ current_slot`) only. It connects to
> [merkle-agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement)
> in the stack, but there is no composed proof linking them yet.
> [How the parts connect →](https://github.com/vasilisnasopoulos-stack/blob/main/SLICES.md)

This repository is the reviewer-facing entry point for the public Vortex DSE formal artifacts. It separates **deductive proofs**, **bounded model checking**, and **executable reference behavior** so every claim can be traced to its verification method and scope.

## Architecture at a glance

```text
Transaction
    ↓
C-slot admission
    ↓
Local processed set
    ↓
Freeze
    ↓
Reconcile views
    ↓
Merkle-equality confirmation
    ↓
Commit an identical per-slot input set
```

The public work is currently modular: admission, crash/rejoin safety, and per-slot agreement are specified and checked in separate artifacts. A single end-to-end composed proof is explicitly future work.

## Public repositories

| Repository | Role | Verification status |
|---|---|---|
| **vortex-dse-cslot-proofs** ← you are here | Late-tolerant C-slot admission; deductive safety proofs | TLAPS: `[]TypeInvariant`, `[]NoFutureAdmission`; all 194 obligations proved |
| [vortex-dse-cslot-spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | Strict C-slot admission, clock skew, Byzantine timestamp/origin spoofing, executable reference | TLC bounded checks; JavaScript reference scenarios |
| [vortex-merkle-agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) | Per-slot input-set agreement: Freeze → Reconcile → Commit | TLC + Apalache bounded checks under declared assumptions |

## Claims matrix

| Claim | Status | Method | Scope |
|---|---|---|---|
| Type-correctness | Proved | TLAPS | Arbitrary nodes, message ids, and arbitrary finite `MaxSlot ∈ Nat` |
| No future admission | Proved | TLAPS | Arbitrary nodes, message ids, and arbitrary finite `MaxSlot ∈ Nat` |
| Strict same-slot admission | Checked | TLC | Configured finite instances (see spec repo) |
| Exactly once per node | Checked | TLC | Configured finite instances |
| Persistence does not invent processed ids | Checked | TLC | Configured finite instances |
| Safety under bounded clock skew and Byzantine origin/timestamp spoofing | Checked | TLC | Configured finite adversarial instance |
| Per-slot committed-set agreement | Checked | TLC + Apalache | Under the Merkle agreement assumptions and configured finite instances |
| Eventual commit/agreement | Checked | Temporal model checking | Under declared fairness assumptions |
| Full crash-safe, cross-slot, non-atomic end-to-end protocol | **Not yet proved** | — | Future composed refinement |
| Global consensus | **Not claimed by these artifacts** | — | Out of scope of the current public proof bundle |

## What is deductively proven here

Machine-checked **TLAPS** proofs for the Vortex DSE deterministic late-tolerant C-slot admission model. Unlike model checking, which verifies a property only on enumerated finite instances, these proofs hold for every parameter choice satisfying the declared assumptions: any node set, any message-id set, and any finite slot horizon `MaxSlot ∈ Nat`.

| Property | Statement | Status |
|---|---|---|
| Type-correctness | `Spec => []TypeInvariant` | proved by TLAPS |
| No future admission | `Spec => []NoFutureAdmission` | proved by TLAPS |

`tlapm` reports:

```text
All 194 obligations proved.
```

`NoFutureAdmission` means that no node admits an id unless there is a real network record for that id whose C-slot is present or past:

```text
m.cslot <= current_slot
```

Late messages remain admissible into their original earlier slot; only future-dated admission is barred.

## Proof structure

`NoFutureAdmission` is not inductive by itself because `Rejoin` restores:

```tla
processed[n] := persisted[n]
```

The strengthened invariant is:

```tla
SafeInv == TypeInvariant /\ NoFutureAdmission /\ PersistedSafe
```

`PersistedSafe` requires every id in the crash-recovery snapshot to have a present-or-past network witness. The proof closes mutually:

- `Crash` establishes `PersistedSafe'` from pre-state `NoFutureAdmission`.
- `Rejoin` establishes `NoFutureAdmission'` from pre-state `PersistedSafe`.

This is standard conjunctive inductive strengthening, not circular reasoning.

The proof follows the usual invariant pattern:

```text
Init => Inv
Inv /\ [Next]_vars => Inv'
---------------------------
Spec => []Inv
```

## Declared limits

Only the two TLAPS theorems above are deductively proven in this repository. The following are not claimed here as unbounded deductive theorems:

- `ExactlyOncePerNode`
- `PersistedReflectsReality`
- liveness properties such as `TickProgress`, `EventualRejoin`, and `EventualAdmission`
- composed admission + agreement + crash/rejoin + cross-slot replay protection
- refinement of atomic reconciliation into the full multi-round Bloom/Merkle wire protocol

"Unbounded over the parameters" means arbitrary parameter values with a finite slot domain `0..MaxSlot`; it does not mean an infinite slot horizon.

## Files

- `specs/Vortex_DSE_CSlot.tla` — late-tolerant C-slot model.
- `specs/Vortex_DSE_CSlot_Proofs.tla` — TLAPS proof module.

## Reproduce

Install [TLAPS](https://github.com/tlaplus/tlapm), then run:

```sh
tlapm --toolbox 0 0 specs/Vortex_DSE_CSlot_Proofs.tla
```

Expected result:

```text
All 194 obligations proved.
```

## Suggested reviewer path

1. Read this claims matrix and scope statement.
2. Inspect `specs/Vortex_DSE_CSlot.tla` for the transition system.
3. Inspect `specs/Vortex_DSE_CSlot_Proofs.tla` for the deductive invariant proof.
4. Continue to the strict-admission repository for bounded adversarial checks and executable behavior.
5. Continue to the Merkle-agreement repository for the per-slot committed-set agreement layer.
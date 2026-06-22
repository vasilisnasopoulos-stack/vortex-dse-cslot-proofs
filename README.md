> **Vortex DSE public verification bundle**
>
> [Proofs](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) · [Strict spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) · [Merkle agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement)

# Vortex DSE — Formal Verification Index

This repository is the reviewer-facing entry point for the public Vortex DSE formal artifacts.
It packages the **default late-tolerant admission model** and its TLAPS proofs.

## Why this repo matters

If you want the strongest safety story, start here.
This repo proves the core admission properties of the default model, while the other public repos cover the strict variant and the per-slot agreement layer.

## Public repositories

| Repository | Role | What it proves / checks |
|---|---|---|
| **vortex-dse-cslot-proofs** ← you are here | Late-tolerant C-slot admission; deductive safety proofs | TLAPS: `[]TypeInvariant`, `[]NoFutureAdmission`; all 194 obligations proved |
| [vortex-dse-cslot-spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | Strict C-slot admission, clock skew, Byzantine timestamp/origin spoofing, executable reference | TLC bounded checks; JavaScript reference scenarios |
| [vortex-merkle-agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) | Per-slot input-set agreement: Freeze → Reconcile → Commit | TLC + Apalache bounded checks under declared assumptions |

## TL;DR

- This repo is the **default** admission model.
- It is **late-tolerant**: `m.cslot ≤ current_slot`.
- It is verified with **TLAPS**, not just bounded model checking.
- The strict same-slot variant lives in the spec repo.
- The agreement layer lives in the Merkle repo.

## What is deductively proven here

Machine-checked **TLAPS** proofs for the Vortex DSE deterministic late-tolerant C-slot admission model.
The two proven theorems are:

- `Spec => []TypeInvariant`
- `Spec => []NoFutureAdmission`

`tlapm` reports:

```text
All 194 obligations proved.
```

## What this repo is not

- Not the strict same-slot admission variant.
- Not the per-slot agreement layer.
- Not a full public end-to-end consensus proof.
- Not the production C engine.

## Proof structure

`NoFutureAdmission` is not inductive by itself because `Rejoin` restores:

```tla
processed[n] := persisted[n]
```

The strengthened invariant is:

```tla
SafeInv == TypeInvariant /\ NoFutureAdmission /\ PersistedSafe
```

## Files

- `specs/Vortex_DSE_CSlot.tla` — late-tolerant C-slot model.
- `specs/Vortex_DSE_CSlot_Proofs.tla` — TLAPS proof module.

## Reproduce

```sh
tlapm --toolbox 0 0 specs/Vortex_DSE_CSlot_Proofs.tla
```

Expected result:

```text
All 194 obligations proved.
```

## Suggested reviewer path

1. Read the TL;DR.
2. Inspect `specs/Vortex_DSE_CSlot.tla`.
3. Inspect `specs/Vortex_DSE_CSlot_Proofs.tla`.
4. Continue to the strict-admission repo.
5. Continue to the Merkle-agreement repo.

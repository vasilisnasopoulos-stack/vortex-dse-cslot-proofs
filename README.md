# vortex-dse-cslot-proofs

> **Vortex DSE formal specs** — [profile index](https://github.com/vasilisnasopoulos-stack) · navigation:
>
> | Repository | Role |
> |---|---|
> | **vortex-dse-cslot-proofs** ← *you are here* | TLAPS proofs — default (late-tolerant) admission |
> | [vortex-dse-cslot-spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | Strict admission + Byzantine skew + JS reference impl |
> | [vortex-merkle-agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) | Per-slot Merkle agreement (Freeze → Reconcile → Commit) |

Machine-checked **TLAPS** proofs for the Vortex DSE deterministic **C-slot
admission** model.

This repository contains the TLA+ specification together with **deductive,
machine-checked proofs** (TLAPS, the TLA+ Proof System). Unlike model checking
(TLC / Apalache), which verifies a property only on the specific finite
instances it enumerates, these proofs hold for **all** parameter values — any
set of nodes, any set of message ids, and any finite slot horizon
`MaxSlot \in Nat` — each in a single proof.

## What is proven (machine-checked theorems)

| Property | Statement | Status |
|---|---|---|
| Type-correctness | `Spec => []TypeInvariant` | proved (TLAPS) |
| No future admission (headline safety) | `Spec => []NoFutureAdmission` | proved (TLAPS) |

`tlapm` reports **all 194 obligations proved**.

`NoFutureAdmission`: no node ever admits a message whose C-slot has not yet been
reached (the admission gate is `m.cslot <= current_slot`, and `current_slot` is
monotone). Late messages are still admitted into their own earlier slot — only
*future-dated* admission is barred.

### Proof technique (honest note on circularity)

`NoFutureAdmission` is **not inductive on its own**: the `Rejoin` action
restores `processed[n] := persisted[n]`, and the bare property says nothing
about `persisted`, so the Rejoin step cannot close. We therefore prove the
strengthened invariant

```
SafeInv == TypeInvariant /\ NoFutureAdmission /\ PersistedSafe
```

where `PersistedSafe` gives every id in the crash-recovery snapshot a
present-or-past network witness. The two safety conjuncts close **mutually**
(standard conjunctive inductive strengthening — *not* a theorem assuming
itself): `Crash` establishes `PersistedSafe'` from the pre-state
`NoFutureAdmission`, and `Rejoin` establishes `NoFutureAdmission'` from the
pre-state `PersistedSafe`. Because `NoFutureAdmission` is a conjunct of
`SafeInv`, `Spec => []SafeInv` projects onto `Spec => []NoFutureAdmission`.

## Scope — what is NOT a theorem here

To be precise: only the two properties above are TLAPS-proven. Everything else
about the model — `ExactlyOncePerNode`, `PersistedReflectsReality`, and **all
liveness** (`TickProgress`, `EventualRejoin`, `EventualAdmission`) — is
established by **bounded model checking** only, not by deductive proof. The only
assumption beyond the spec itself is `MaxSlot \in Nat`. "Unbounded over the
parameters" means an **arbitrary finite** `MaxSlot`, **not** an infinite slot
horizon: each instance still has the finite slot domain `0..MaxSlot`.

## Files

- `specs/Vortex_DSE_CSlot.tla` — the model (default, late-tolerant C-slot
  admission; matches the reference implementation).
- `specs/Vortex_DSE_CSlot_Proofs.tla` — the TLAPS proofs.

## Reproduce

Install [TLAPS](https://github.com/tlaplus/tlapm), then:

```
tlapm --toolbox 0 0 specs/Vortex_DSE_CSlot_Proofs.tla
```

Expected output: `All 194 obligations proved.`

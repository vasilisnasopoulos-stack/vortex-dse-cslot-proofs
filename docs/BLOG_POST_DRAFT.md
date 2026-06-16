# We proved a consensus-free admission rule holds under crashes and Byzantine replay

*Draft blog post — publish on Substack, dev.to, Medium, or discuss.tlapl.us*

---

## The problem

Distributed systems usually solve "who may process this message when?" with
consensus: leaders, quorums, votes. That works, but it is expensive and fragile
in adversarial networks.

Vortex DSE takes a different path: **deterministic C-slot admission**. Each
message carries a content-derived temporal bucket `C_slot`. Each node runs a
**local, O(1) gate** — no leader, no quorum, no vote:

```
admit(m, node)  iff  m.cslot <= node.current_slot
```

Late messages are **not dropped** (they land in their own earlier slot). Only
**future-dated** admission is forbidden — you cannot admit a message whose slot
has not happened yet.

This matches the default production C build. A stricter variant (`m.cslot =
current_slot`, one slot late → permanent reject) exists as an opt-in TTL window.

The question: does this gate remain safe when the network reorders messages
arbitrarily, delays them forever, crashes nodes, and an adversary replays
messages with fake slot stamps?

## Why model checking is not enough

We first verified the spec with TLC (explicit-state model checking): 8,084,795
states generated, 608,477 distinct, **0 errors** — for a small instance (2
nodes, 2 messages, `MaxSlot = 4`).

That is strong evidence, but it is **not a proof for all parameters**. A
different `MaxSlot`, more nodes, or more messages might break a property that
held in the enumerated instance.

For the headline safety property — **NoFutureAdmission** — we wanted a
**deductive proof** that holds for any finite set of nodes, any finite set of
message ids, and any finite slot horizon.

## The result

Using TLAPS (the TLA+ Proof System):

```
Spec => []NoFutureAdmission
Spec => []TypeInvariant
```

`tlapm` reports: **all 194 obligations proved**.

"No future admission" means: whenever a node has admitted message id `x`, there
exists a network record for `x` whose `cslot` is at most the current slot index.
Combined with monotonic `current_slot`, admitted messages always correspond to
present-or-past slots — never the future.

Repository: https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs

## The proof trick (for formal-methods readers)

`NoFutureAdmission` is **not inductive on its own**.

The `Rejoin` action restores `processed[n] := persisted[n]`, but
`NoFutureAdmission` says nothing about `persisted`. The Rejoin step cannot
close.

We prove a strengthened invariant instead:

```
SafeInv == TypeInvariant /\ NoFutureAdmission /\ PersistedSafe
```

where `PersistedSafe` requires the same witness for every id in the mmap snapshot.

The two safety conjuncts close **mutually**:

- **Crash:** `persisted[n] := processed[n]` — pre-state `NoFutureAdmission` gives
  post-state `PersistedSafe`
- **Rejoin:** `processed[n] := persisted[n]` — pre-state `PersistedSafe` gives
  post-state `NoFutureAdmission`

This is standard conjunctive inductive strengthening — not circular reasoning.
Because `NoFutureAdmission` is a conjunct of `SafeInv`, temporal induction on
`SafeInv` projects onto `Spec => []NoFutureAdmission`.

## What we do NOT claim

Honest scope matters:

- Only `TypeInvariant` and `NoFutureAdmission` are TLAPS-proven in the proofs
  repo. Other invariants (`ExactlyOncePerNode`, liveness, etc.) are bounded
  model-checking results only.
- The **agreement layer** (Freeze → Reconcile → Commit, MerkleAgreement) lives
  in a separate spec, verified by TLC + Apalache:
  https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement
- Full **composition** (late-tolerant admission × agreement × crash during AE)
  is future work.
- The strict admission variant and Byzantine clock-skew extension are in:
  https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec

## Reproduce in 30 seconds

```sh
git clone https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs.git
cd vortex-dse-cslot-proofs
tlapm --toolbox 0 0 specs/Vortex_DSE_CSlot_Proofs.tla
```

Expected output: `All 194 obligations proved.`

(Requires [TLAPS](https://github.com/tlaplus/tlapm) installed.)

## What's next

- Composed spec linking admission, agreement, and crash recovery
- Ports to Lean / Coq / Isabelle (the spec is small and uses only `Naturals` +
  `FiniteSets`)
- TLAPS proofs for additional invariants

Open an issue on GitHub if you are working on a port or have modeling questions.

---

*Vasilis Nasopoulos · Apache-2.0 · Part of the Vortex DSE formal spec series*

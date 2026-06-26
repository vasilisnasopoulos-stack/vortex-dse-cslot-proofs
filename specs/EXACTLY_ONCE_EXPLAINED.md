# Exactly-once admission proof, in plain English

This proof shows that a node never admits the same message more than once.

That remains true even in the difficult cases the model allows:

- messages can arrive late,
- the network can reorder delivery,
- an attacker can replay or duplicate old messages,
- a node can crash and later rejoin.

In other words, once a message id has already been admitted by a node, that same node cannot admit it again later.

## What is proved formally

The proof establishes:

```tla
Spec => []StrictExactlyOnce
```

This means that in every reachable state of the system, the exactly-once property always holds.

## Why this matters

Exactly-once admission is a core safety guarantee.

It means the admission logic is protected against:
- accidental double-processing,
- replayed messages,
- duplicate network delivery,
- state restoration after crash/rejoin.

Without this property, the same message could be counted or processed multiple times by the same node, which would break deterministic behavior.

## How the proof works

The proof is machine-checked in TLAPS.

It uses an inductive invariant that shows:

- `processed[n]` only contains valid message ids,
- `persisted[n]` also remains clean,
- restoring state on `Rejoin` cannot introduce a duplicate,
- replay injection does not bypass the admission guard.

The key idea is that the `Process` action only allows admission when the message id is not already in `processed[n]`.

## What this proof does not claim

This proof does **not** show:
- agreement between different nodes,
- full consensus,
- liveness by itself,
- the strict same-slot admission rule.

It proves a narrower but important safety property: **no node admits the same message twice**.

## File

The proof lives in:

- `specs/Vortex_DSE_CSlot_ExactlyOnce_Proof.tla`

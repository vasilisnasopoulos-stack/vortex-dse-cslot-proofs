# Show HN: Machine-checked proofs of consensus-free slot admission (TLAPS, 194/194)

**Title (HN):** Show HN: Machine-checked proofs of consensus-free slot admission (TLAPS)

**URL:** https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs

---

**Post text (paste as first comment on your submission):**

I formalized a deterministic per-slot admission rule for a distributed system
design (Vortex DSE) that deliberately avoids leader election, quorum, and voting.

Each node admits a message locally with an O(1) gate: `m.cslot <= current_slot`.
The message keeps its own content-derived C-slot; late delivery is tolerated
(admitted into its own earlier slot), but future-dated admission is forbidden.

The hostile environment includes: arbitrary network reordering (network modeled as
a set), unbounded delivery delay, node crash/rejoin with mmap snapshot only, and
adversarial replay with arbitrary fake cslot stamps.

Main machine-checked result (TLAPS, not bounded model checking):

    Spec => []NoFutureAdmission

for arbitrary finite `Nodes`, `MsgIDs`, and `MaxSlot ∈ Nat` — 194/194 obligations
proved in a single deductive proof.

The proof required conjunctive strengthening (`PersistedSafe`) because
`NoFutureAdmission` alone is not inductive across the `Rejoin` action
(`processed := persisted`).

Related repos (layered specs, all reproducible):

- Strict admission variant + Byzantine clock-skew extension + JS reference impl:
  https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec
  (TLC: 8M states, 0 errors)

- Per-slot Merkle agreement layer (Freeze → Reconcile → Commit):
  https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement

Index / navigation: https://github.com/vasilisnasopoulos-stack (after profile
README is set up)

Happy to answer modeling questions. Scope is deliberately honest — liveness and
full layer composition are not TLAPS-proven here.

---

**Tips:**
- Submit Tuesday–Thursday morning US time for best HN visibility
- Post the comment immediately after submitting (HN culture)
- Reply quickly to first 2 hours of comments

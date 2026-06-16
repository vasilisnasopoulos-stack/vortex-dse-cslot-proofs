# TLA+ community announcement (discuss.tlapl.us / Google Group)

**Subject:** TLAPS proofs: crash + replay tolerant C-slot admission (`NoFutureAdmission`, 194/194)

---

Hi all,

I would like to share a TLAPS proof development for a distributed admission gate
that may be of interest to the community.

**Setting:** finite `Nodes`, `MsgIDs`, `MaxSlot ∈ Nat`. Network is a **set**
(arbitrary reordering). Actions include Submit, Process (local admission gate),
Crash/Rejoin (mmap snapshot), DuplicateInject (adversarial replay with arbitrary
fake `cslot`), and Tick (monotone slot advance).

**Admission gate (default / late-tolerant):** `m.cslot <= current_slot`.

**Proved (TLAPS, single deductive proof per theorem):**

- `Spec => []TypeInvariant`
- `Spec => []NoFutureAdmission`

`tlapm`: all **194 obligations proved**.

**Non-inductive headline:** `NoFutureAdmission` alone fails on `Rejoin`. We prove
`SafeInv == TypeInvariant /\ NoFutureAdmission /\ PersistedSafe` instead; Crash
and Rejoin close the two safety conjuncts mutually.

Repo: https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs

Related bounded model-checking specs (strict variant, Byzantine skew, Merkle
agreement layer) are linked from the profile index:
https://github.com/vasilisnasopoulos-stack

Feedback on proof structure or suggestions for strengthening welcome.

Best,
Vasilis Nasopoulos

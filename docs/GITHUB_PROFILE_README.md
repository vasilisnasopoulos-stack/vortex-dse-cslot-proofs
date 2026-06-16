# Vasilis Nasopoulos

Formal specifications and machine-checked proofs for **Vortex DSE** — a
deterministic, **consensus-free** per-slot admission and agreement design.

> No leader · no quorum · no vote · local O(1) admission gate

**Headline results:** `194` TLAPS obligations proved · `8M+` TLC states explored ·
`0` counterexamples (bounded runs)

---

## Start here

| Repository | Admission rule | Verification | Best for |
|---|---|---|---|
| [**vortex-dse-cslot-proofs**](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) | **Default (late-tolerant):** `m.cslot ≤ current_slot` | **TLAPS** (deductive, unbounded over parameters) | The strongest result — `[]NoFutureAdmission` proved for any finite `Nodes`, `MsgIDs`, `MaxSlot` |
| [**vortex-dse-cslot-spec**](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | **Strict:** `m.cslot = current_slot` | TLC + Apalache + JS reference impl | Strict variant, Byzantine clock-skew extension, reproducible logs |
| [**vortex-merkle-agreement**](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) | Strict admission + AE phase | TLC + Apalache | Per-slot **MerkleAgreement** — identical `committed_set` across nodes |

**Which admission variant?** The **production default** C build is late-tolerant
(late messages admitted into their own slot). The **strict** rule (`=` not `≤`)
is the opt-in TTL window. See the table above.

---

## System at a glance

```
Producer stamps C_slot
        │
        ▼
  [network — unordered SET, unbounded delay, replay]
        │
        ▼
  Node admits iff m.cslot ≤ current_slot   ← Phase 1: Admission (local, deterministic)
        │
        ▼
  Freeze → Reconcile (union) → Commit      ← Phase 2–4: Agreement Extension
        │
        ▼
  All live nodes: identical committed_set  ← MerkleAgreement
```

**Modeled adversaries:** arbitrary reordering, unbounded delay, crash/rejoin
(mmap snapshot), adversarial duplicate injection with fake `cslot` (and, in the
Skew spec, fake origin).

---

## What is formally established

| Property | Where | Method |
|---|---|---|
| `Spec => []NoFutureAdmission` (default build) | [cslot-proofs](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) | **TLAPS** — unbounded over parameters |
| `Spec => []TypeInvariant` | [cslot-proofs](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) | **TLAPS** |
| Strict C-slot + 6 safety invariants | [cslot-spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | TLC — 8.08M states |
| Byzantine origin + bounded clock skew | [cslot-spec/Skew](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | TLC — 96K states |
| `MerkleAgreement` per slot | [merkle-agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) | TLC + Apalache |

Honest scope: layers are verified **separately** today. Full composition
(admission × agreement × crash during AE) is acknowledged future work. See each
repo's README for what is *not* claimed.

---

## Quick reproduce

**TLAPS proofs (headline result):**
```sh
git clone https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs.git
cd vortex-dse-cslot-proofs
tlapm --toolbox 0 0 specs/Vortex_DSE_CSlot_Proofs.tla
# Expected: All 194 obligations proved.
```

**TLC model checking (strict admission):**
```sh
git clone https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec.git
cd vortex-dse-cslot-spec
java -jar tla2tools.jar -workers auto -config specs/Vortex_DSE_CSlot_tiny.cfg specs/Vortex_DSE_CSlot.tla
```

**Reference implementation (10 scenarios):**
```sh
node ref_impl/cslot_ref.mjs   # inside vortex-dse-cslot-spec
```

---

## Contact & citation

Open an issue on any repo for modeling questions or porting help.

```bibtex
@misc{nasopoulos2026vortexdse,
  author       = {Nasopoulos, Vasilis},
  title        = {Vortex DSE Formal Specifications: Temporal Admission and
                  Per-Slot Merkle Agreement},
  year         = {2026},
  howpublished = {\url{https://github.com/vasilisnasopoulos-stack}}
}
```

---

*Apache-2.0 · TLA+ / TLAPS / TLC / Apalache*

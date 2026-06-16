# README navigation blocks for sibling repos

Apply the block below to the **top** of each sibling repository's `README.md`
(immediately after the `# title` line). These changes could not be pushed
automatically from the agent environment.

## vortex-dse-cslot-spec

Insert after `# Vortex DSE — C-Slot Strict Admission`:

```markdown
> **Vortex DSE formal specs** — [profile index](https://github.com/vasilisnasopoulos-stack) · navigation:
>
> | Repository | Role |
> |---|---|
> | [vortex-dse-cslot-proofs](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) | TLAPS proofs — default (late-tolerant) admission |
> | **vortex-dse-cslot-spec** ← *you are here* | Strict admission + Byzantine skew + JS reference impl |
> | [vortex-merkle-agreement](https://github.com/vasilisnasopoulos-stack/vortex-merkle-agreement) | Per-slot Merkle agreement (Freeze → Reconcile → Commit) |
```

## vortex-merkle-agreement

Insert after `# Vortex DSE — Merkle Agreement (per-slot input-set agreement)`:

```markdown
> **Vortex DSE formal specs** — [profile index](https://github.com/vasilisnasopoulos-stack) · navigation:
>
> | Repository | Role |
> |---|---|
> | [vortex-dse-cslot-proofs](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs) | TLAPS proofs — default (late-tolerant) admission |
> | [vortex-dse-cslot-spec](https://github.com/vasilisnasopoulos-stack/vortex-dse-cslot-spec) | Strict admission + Byzantine skew + JS reference impl |
> | **vortex-merkle-agreement** ← *you are here* | Per-slot Merkle agreement (Freeze → Reconcile → Commit) |
```

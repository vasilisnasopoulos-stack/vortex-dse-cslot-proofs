# GitHub profile setup (one-time)

The agent cannot create the special profile repository from this environment.
Run these steps once from your machine (takes ~2 minutes).

## 1. Profile README (shows on github.com/vasilisnasopoulos-stack)

```sh
# Create the profile repo (name MUST match your username exactly)
mkdir vasilisnasopoulos-stack && cd vasilisnasopoulos-stack
curl -o README.md https://raw.githubusercontent.com/vasilisnasopoulos-stack/vortex-dse-cslot-proofs/main/docs/GITHUB_PROFILE_README.md
git init && git add README.md
git commit -m "Add profile README"
gh repo create vasilisnasopoulos-stack --public --source=. --push
# Or create the empty repo on GitHub UI, then: git remote add origin ... && git push -u origin main
```

After push, visit https://github.com/vasilisnasopoulos-stack — the README renders
as your profile page.

## 2. GitHub profile fields (Settings → Profile)

| Field | Suggested value |
|---|---|
| **Name** | Vasilis Nasopoulos |
| **Bio** | Formal specs for Vortex DSE — consensus-free C-slot admission. TLAPS proofs + TLC model checking. |
| **Website** | https://github.com/vasilisnasopoulos-stack |

## 3. Pin repositories (your profile → Customize pins)

Pin these two (in order):

1. `vortex-dse-cslot-proofs` — headline TLAPS result
2. `vortex-dse-cslot-spec` — strict variant + reference impl

## 4. Repository topics (already set by agent if PRs merged; otherwise per repo → Settings → Topics)

**vortex-dse-cslot-proofs:** `tla-plus`, `formal-verification`, `tlaps`, `distributed-systems`, `model-checking`

**vortex-dse-cslot-spec:** `tla-plus`, `formal-verification`, `distributed-systems`, `model-checking`, `byzantine-fault-tolerance`

**vortex-merkle-agreement:** `tla-plus`, `formal-verification`, `distributed-systems`, `merkle-tree`, `model-checking`

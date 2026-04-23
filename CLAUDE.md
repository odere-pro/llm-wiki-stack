# llm-wiki-stack — plugin repo

Source of the `llm-wiki-stack` Claude Code plugin: a **four-layer stack** (Data · Skills · Agents · Orchestration) that turns an Obsidian vault into a provenance-tracked wiki, following [Andrej Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

The **contract** is [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md). Every skill, agent, and hook binds to it. **Terminology** is [`docs/VOCABULARY.md`](./docs/VOCABULARY.md); every user-visible string conforms.

## Dev-time vs. runtime

This tree is the plugin source — contributor view. Users never see it directly. When a user installs the plugin via the same-repo marketplace, Claude Code copies the plugin into its plugin cache and loads specific subtrees as session context:

| Subtree                                                                              | Loaded as runtime context? | How it reaches the user                                                                             |
| ------------------------------------------------------------------------------------ | -------------------------- | --------------------------------------------------------------------------------------------------- |
| `skills/`                                                                            | Yes                        | Each becomes `/llm-wiki-stack:<name>`.                                                              |
| `agents/`                                                                            | Yes                        | Each becomes `@<name>` / `Agent(...)`.                                                              |
| `hooks/hooks.json` + `scripts/`                                                      | Yes                        | Hooks fire on the user's tool-call lifecycle; `${CLAUDE_PLUGIN_ROOT}` resolves to the plugin cache. |
| `rules/`                                                                             | Yes                        | Path-scoped guidance loaded when the user edits matching paths.                                     |
| `example-vault/`                                                                     | No (not auto-loaded)       | Copied once by the onboarding wizard: `/llm-wiki-stack:llm-wiki` duplicates it into `vault/`.       |
| `docs/`, `tests/`, `.github/`, root `CLAUDE.md`, `NOTICE`, `LICENSE`, `CHANGELOG.md` | No                         | Present in the plugin cache on disk but never loaded as session context.                            |

This root `CLAUDE.md` is contributor guidance for editing the plugin source. It does not ship into user sessions.

## Four-layer stack

Per [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §4:

| Layer                   | Directory                                | Responsibility                                                                                                                                                                                                                                                                                        | Spec §         |
| ----------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Layer 1 — Data          | `example-vault/`                         | Immutable `raw/`, LLM-maintained `wiki/`, and the **schema** at `example-vault/CLAUDE.md` (`schema_version: 1`). Passive — all enforcement sits in Layer 4.                                                                                                                                           | §3, §5, §6, §7 |
| Layer 2 — Skills        | `skills/`                                | **12 single-responsibility capabilities.** 8 plugin-authored `llm-wiki-*` (ingest, query, lint, fix, status, synthesize, index, and the `llm-wiki` onboarding wizard), plus plugin-authored `obsidian-graph-colors`, plus 3 MIT-licensed `obsidian-*` reference skills from `kepano/obsidian-skills`. | §4, §8         |
| Layer 3 — Agents        | `agents/`                                | **3 multi-step executors** that compose skills: `llm-wiki-ingest-pipeline` (the **default verb**), `llm-wiki-lint-fix`, `llm-wiki-analyst`.                                                                                                                                                           | §4, §10        |
| Layer 4 — Orchestration | `hooks/hooks.json`, `scripts/`, `rules/` | Hooks on `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `SubagentStop`. Implementations in `scripts/`. Path-scoped declarative guidance in `rules/`.                                                                                                                                | §4, §9         |

[`docs/architecture.md`](./docs/architecture.md) explains the model in prose.

## Authorities

Two files govern every edit in this repo:

- **Schema** — [`example-vault/CLAUDE.md`](./example-vault/CLAUDE.md) defines the `schema_version`, the six allowed `type` values (`source`, `entity`, `concept`, `synthesis`, `index`, `log`), every frontmatter field, and every MOC invariant. Skill and agent prose that contradicts it MUST be corrected to match. On install, the onboarding wizard copies this file to the user's `vault/CLAUDE.md`, where it takes over the authoritative role for their sessions.
- **Vocabulary** — [`docs/VOCABULARY.md`](./docs/VOCABULARY.md) is the canonical term list. Two registers: **technical** (docs, skills, agents, scripts, schema) and **discoverability** (README tagline, `plugin.json` description, GitHub About — SEO surfaces only). The registers do not mix. If an edit introduces a new concept, add the term to `docs/VOCABULARY.md` first with a rationale, then use it. Enforced by [`scripts/validate-docs.sh`](./scripts/validate-docs.sh) locally and in CI.

## Where to look

| Doing                                                          | Primary source                                                                                                                                                          |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Implementing or editing a skill                                | [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §4, §8; existing SKILL.md files in `skills/`                                                                         |
| Implementing or editing an agent                               | [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §4, §10                                                                                                              |
| Writing or changing a hook script                              | [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §9; [`hooks/hooks.json`](./hooks/hooks.json) (scripts and wiring are coupled); existing tests under `tests/scripts/` |
| Writing frontmatter                                            | [`example-vault/CLAUDE.md`](./example-vault/CLAUDE.md); [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §6; templates in `example-vault/_templates/`                 |
| Writing user-facing prose (README, skill descriptions, guides) | [`docs/VOCABULARY.md`](./docs/VOCABULARY.md); user-guide voice in `docs/llm-wiki/`                                                                                      |
| Security and threat model                                      | [`docs/security.md`](./docs/security.md); [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §14                                                                        |
| Testing — tiers, fixtures, smoke                               | [`tests/README.md`](./tests/README.md); [`docs/SPECIFICATION.md`](./docs/SPECIFICATION.md) §13 (Tier 0–4)                                                               |
| Release automation                                             | `.github/release-please-config.json`, `.github/release-drafter.yml`                                                                                                     |

## Local workflows

| Command                                   | Purpose                                                                            |
| ----------------------------------------- | ---------------------------------------------------------------------------------- |
| `scripts/validate-docs.sh`                | Vocabulary enforcement. Run before every commit on this repo.                      |
| `scripts/verify-ingest.sh example-vault/` | Structural verification of the reference vault against the schema.                 |
| `bats tests/scripts/`                     | Tier 1 — Bats unit tests, one per script. Requires `bats-core` + `jq`.             |
| `bash tests/smoke/fresh-install.sh`       | Tier 2 — end-to-end smoke. Skips if the `claude` CLI is absent.                    |
| `pre-commit run --all-files`              | Tier 0 — static checks (`shellcheck`, `markdownlint`, `gitleaks`, `lychee`, etc.). |

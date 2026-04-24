# Changelog

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning follows [SemVer](https://semver.org/spec/v2.0.0.html).

## [0.2.0](https://github.com/odere-pro/llm-wiki-stack/compare/v0.1.0...v0.2.0) (2026-04-24)


### Features

* **agents:** 3 Layer 3 agents (per spec §4, §10) ([7024c65](https://github.com/odere-pro/llm-wiki-stack/commit/7024c6570983cad855ff869499f81ca232c359ad))
* **config:** add .claude/llm-wiki-stack/settings.json for persistent vault path ([b351d18](https://github.com/odere-pro/llm-wiki-stack/commit/b351d18ba07b6046fc9b2c8dd6d148707338ffbf))
* **onboarding:** idempotent vault scaffolding, empty starter template, plain-markdown export ([c01d98e](https://github.com/odere-pro/llm-wiki-stack/commit/c01d98eb63e2b1c0bc07267cc6cc24f9e3d65ce8))
* **orchestration:** Layer 4 hooks, scripts, path-scoped rules (per spec §4, §9) ([b5ff088](https://github.com/odere-pro/llm-wiki-stack/commit/b5ff088103ed0f3e57bf389f5235724060e2327f))
* **plugin:** manifest and same-repo marketplace (per spec §1) ([ab6e05c](https://github.com/odere-pro/llm-wiki-stack/commit/ab6e05c3f9e76b874f6e0edf275bbfb2431f48f5))
* **skills:** 12 Layer 2 skills (per spec §4, §8) ([95e365c](https://github.com/odere-pro/llm-wiki-stack/commit/95e365c710ca1929d9b4ee94cb64a63bdb8e6e10))
* **skills:** add llm-wiki-markdown export skill + fix hooks.json envelope ([225b6eb](https://github.com/odere-pro/llm-wiki-stack/commit/225b6eb44ad953e1f3bebcb4a63aa90d05dc20a9))
* **skills:** add llm-wiki-markdown export skill + fix hooks.json envelope ([d3eee3e](https://github.com/odere-pro/llm-wiki-stack/commit/d3eee3e44709ac671bc08977ffa50d644d5ee59b))
* **tests:** install-deps.sh + run-tests.sh — one-command local dev workflow ([8eb2e0b](https://github.com/odere-pro/llm-wiki-stack/commit/8eb2e0b07c74b4b37288823e8deb040d39b2a1d0))
* **vault:** example vault with schema_version 1 (per spec §6-§7) ([38a3703](https://github.com/odere-pro/llm-wiki-stack/commit/38a370375a0a628e76bdc7ca3de1f6f9f93b8955))


### Bug Fixes

* **docs:** correct relative path to README in vault-example getting-started ([9cd42ad](https://github.com/odere-pro/llm-wiki-stack/commit/9cd42ad46db0caa065b220000865bb02be895b4a))
* **tests:** repair Tier 0 + Tier 2 tooling drift ([d01c366](https://github.com/odere-pro/llm-wiki-stack/commit/d01c366a13afd38a31f0598fd2831fc308e41f3f))


### Refactoring

* **agent:** llm-wiki-analyst — apply best-practices redesign ([3b67af6](https://github.com/odere-pro/llm-wiki-stack/commit/3b67af68a32352351a7dbaa58d66a7b1e0137f44))
* **agents:** close 10 findings from agent validation review ([c1dd97e](https://github.com/odere-pro/llm-wiki-stack/commit/c1dd97e2a4c0dccfb936a0959a7d27c890fd0a76))
* **agents:** tighten llm-wiki-ingest-pipeline against agent best practices ([22edd56](https://github.com/odere-pro/llm-wiki-stack/commit/22edd56bc12fb9a0ec0583b826e4714cdb104558))
* **agents:** tighten llm-wiki-lint-fix against agent best practices ([06fb4a6](https://github.com/odere-pro/llm-wiki-stack/commit/06fb4a60220d7fec73ef16da96d11964c1d16623))
* **scripts:** add dual CLI/hook mode to validation scripts ([d7def5d](https://github.com/odere-pro/llm-wiki-stack/commit/d7def5d2e7d4087bf1575e2b00d722f0736f28dc))
* **scripts:** respect LLM_WIKI_VAULT env var and CLAUDE_PLUGIN_ROOT ([e98ce3f](https://github.com/odere-pro/llm-wiki-stack/commit/e98ce3fa44f63ef78e79380da63bc523232c0521))


### Documentation

* expand root CLAUDE.md for accuracy; README readability, SEO, and doc index ([a6b9207](https://github.com/odere-pro/llm-wiki-stack/commit/a6b92073a5a48b3d4900e44c13a8b1df2c64d27c))
* **install:** add local install, update, and uninstall guide ([94e6929](https://github.com/odere-pro/llm-wiki-stack/commit/94e692963223f75b8ee4b1c7b8b3aea03d79108a))
* **llm-wiki:** rewrite index as a short map; markdownlint spec tables ([e42799e](https://github.com/odere-pro/llm-wiki-stack/commit/e42799e05ea7eaaf1a7219ec142335a879b49b9a))
* **security:** cross-link threat model with its test evidence ([45d8fff](https://github.com/odere-pro/llm-wiki-stack/commit/45d8fffafdab925ac2108d31a012bda6ec101e85))
* SEO — expand plugin.json keywords; add TODOs for banner + screenshot ([cdc492e](https://github.com/odere-pro/llm-wiki-stack/commit/cdc492eff3878c177664dfda927be6b43a76f34f))
* **spec:** SPECIFICATION.md — authoritative contract for llm-wiki-stack ([6adc37d](https://github.com/odere-pro/llm-wiki-stack/commit/6adc37db8b4422e83d16f649463d2a1e591c7bcb))
* vocabulary, architecture, security, and user guides (per spec §2, §14) ([42e7a1f](https://github.com/odere-pro/llm-wiki-stack/commit/42e7a1f531f009f4dfead1331d7d4fd8197e3b63))


### CI

* drop Python across ci.yml and smoke workflows — keep a single shell stack ([d1ccf6a](https://github.com/odere-pro/llm-wiki-stack/commit/d1ccf6a180c5dc185c9b6559f11f98eb2c1b0253))
* replace yq/Python frontmatter check with pure-awk ([84eef3f](https://github.com/odere-pro/llm-wiki-stack/commit/84eef3f928bd27a2f9e4317414a4b6c68c1e1d12))
* Tier 0–4 test harness, release automation, pre-commit (per spec §13) ([315f82a](https://github.com/odere-pro/llm-wiki-stack/commit/315f82a04dadf5dffde4b6fa8139cc1c4de5399a))


### Tests

* tighten mutation-resistant Bats suite ([013dc3e](https://github.com/odere-pro/llm-wiki-stack/commit/013dc3e849ecc3e5382e9063750a37f52396f81d))
* tighten mutation-resistant Bats suite, add fail-safe assertion helpers ([95ce11c](https://github.com/odere-pro/llm-wiki-stack/commit/95ce11ce0e5e84897f7fd7322251db22ef78ed5d))


### Chores

* compact root CLAUDE.md; fix three SC2034s so Tier 0 CI passes ([b9c985b](https://github.com/odere-pro/llm-wiki-stack/commit/b9c985b199d4a21e3c2fdc5359013c53a8216a31))
* editor tooling — recommended VS Code extensions ([dcdc918](https://github.com/odere-pro/llm-wiki-stack/commit/dcdc9185966f64808c38dca83c06f9bcfcf68b1d))
* init — governance, license, and top-level README (per spec §1) ([58dfff4](https://github.com/odere-pro/llm-wiki-stack/commit/58dfff4bc6f56abcab183678faaff9e6415f8ca6))
* **vscode:** remove gitlens from recommended extensions ([aa2d29c](https://github.com/odere-pro/llm-wiki-stack/commit/aa2d29c93e6ee6c5c1d9ba8ba97ede962709ae2a))

## [Unreleased]

### Changed

- **Skill rename (clean-room rewrite).** The eight adapted skills have been
  retired and replaced with fresh, independently-authored implementations
  under new names:
  - `second-brain` → `llm-wiki` (onboarding entry point)
  - `second-brain-ingest` → `llm-wiki-ingest`
  - `second-brain-query` → `llm-wiki-query`
  - `second-brain-lint` → `llm-wiki-lint`
  - `second-brain-fix` → `llm-wiki-fix`
  - `second-brain-status` → `llm-wiki-status`
  - `vault-synthesize` → `llm-wiki-synthesize`
  - `vault-index` → `llm-wiki-index`

  Each new `SKILL.md` was authored from `docs/SPECIFICATION.md`,
  `docs/architecture.md`, `docs/vault-example/CLAUDE.md`, and the Karpathy LLM
  Wiki gist — the previously-adapted content was not consulted during the
  rewrite. Mechanical 5-gram Jaccard similarity between each new file and
  its predecessor is below 0.02.

- **Vocabulary.** `second-brain`, `second brain`, `vault-synthesize`, and
  `vault-index` are retired from the vocabulary and flagged by
  `scripts/validate-docs.sh` as banned strings outside `CHANGELOG.md`,
  `docs/VOCABULARY.md`, and the test surface.
- **Attribution.** `NOTICE` rewritten to credit only the Karpathy pattern
  (public design) and `kepano/obsidian-skills` (MIT, bundled unmodified).
  Prior third-party attribution for skills that have since been replaced
  by clean-room originals has been removed.
- **New file.** `THIRD_PARTY_LICENSES.md` — full license text of every
  bundled third-party component.

### Removed

- `skills/second-brain/`, `skills/second-brain-ingest/`,
  `skills/second-brain-query/`, `skills/second-brain-lint/`,
  `skills/second-brain-fix/`, `skills/second-brain-status/`,
  `skills/vault-synthesize/`, `skills/vault-index/` — replaced by the
  renamed, rewritten skills listed above.

## [0.1.0] — 2026-04-18

Initial release as a Claude Code plugin.

- **Plugin distribution.** `.claude-plugin/plugin.json` and same-repo marketplace.
- **Layer 1 — Data.** `docs/vault-example/` with authoritative schema (`docs/vault-example/CLAUDE.md`, `schema_version: 1`), five frontmatter templates, a small sticky reference vault demonstrating sources, indexes, and two topic folders.
- **Layer 2 — Skills.** 11 skills: `second-brain`, `second-brain-ingest`, `second-brain-query`, `second-brain-lint`, `second-brain-fix`, `vault-synthesize`, `vault-index`, `graph-colors`, `obsidian-markdown`, `obsidian-bases`, `obsidian-cli`.
- **Layer 3 — Agents.** 3 agents: `wiki-ingest-pipeline`, `wiki-lint-fix`, `wiki-analyst`.
- **Layer 4 — Orchestration.** 10 hook scripts wired through `hooks/hooks.json`; 4 path-scoped rules in `rules/`.
- **Docs.** `SPECIFICATION.md`, `VOCABULARY.md`, `SEO.md`, `architecture.md`, `security.md`, `comparison.md`, and the user guide set in `docs/llm-wiki/`.
- **Governance.** `LICENSE` (Apache 2.0), `NOTICE`, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.

### Schema

`schema_version: 1`. Authoritative rules live in `docs/vault-example/CLAUDE.md`; contract summary in `docs/SPECIFICATION.md`.

### Known limitations

See `docs/security.md` — no cryptographic provenance, no hook-script sandboxing, no secret scanning on ingest, confidence scores are the LLM's opinion, topic-tree placement relies on LLM judgement.

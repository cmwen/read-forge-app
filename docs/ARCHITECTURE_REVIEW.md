# ReadForge — Technical Architecture Review

**Created**: December 6, 2025
**Author**: Architect agent

## Executive summary

Overall assessment: 7.5 / 10 — a strong product vision and UX foundation, but several architectural gaps need resolving before full implementation. Three critical blockers and a set of high-priority issues must be addressed to make the MVP realistic and robust.

This review summarizes critical risks, recommended architecture, and prioritized next steps to move from design to implementation.

---

## Critical blockers (must resolve before implementation)

1. Flutter vs. native reading experience
- Problem: ReadForge is a text-heavy e‑reader with precise selection, highlights, and long-form rendering requirements. Flutter can implement these features but will require careful prototyping; native Android (Kotlin/Jetpack Compose) will provide stronger text primitives out of the box.
- Action: Prototype reader in Flutter immediately (1 week). If prototype shows unacceptable UX or performance, pivot to native or hybrid.

2. Missing database architecture
- Problem: Requirements reference SQLite/Drift but the repo has no DB dependency or schema. A clear schema, migration strategy and normalized data model are required.
- Action: Choose a DB (Drift recommended) and design schema, migrations and repository interfaces before feature work.

3. Intent Bridge workflow specification
- Problem: Core UX depends on Android Intent sharing, but there is no technical spec for intent filters, deep links, clipboard handling, or state recovery if the app is backgrounded or killed.
- Action: Produce a state machine and an `ARCHITECTURE_INTENT_WORKFLOW.md` describing intent handling, deep link routes, clipboard interaction policy, and recovery states.

---

## High-priority concerns and recommended fixes

4. Normalize and lazy-load the data model
- Store metadata in the DB; keep large chapter content in files (Markdown/TXT) and load on demand. Use normalized tables for chapters, highlights, notes, bookmarks.

5. State management
- Recommendation: `riverpod` for type safety, testability and scalability. Define ViewModels/use-cases per feature (LibraryViewModel, ReaderViewModel, PromptViewModel).

6. Token and context window management
- Implement a conservative token estimator for MVP (word-count heuristic). Plan provider-specific tokenizers for later (tiktoken/wasm). Create `TokenEstimator` and a context builder that prioritizes recent chapters.

7. TOC parsing
- Use a pragmatic approach: (a) best-effort automated parse, (b) present a parsed preview and editable list to the user, (c) log failures to guide improvements. Avoid brittle regex-only parsing for MVP.

8. Storage layout
- Recommended on-disk layout:
```
/files/books/{book-id}/
  - cover.jpg
  - context.json
  /chapters/{chapter-id}.md
/exports/
```
- Store content files separate from DB and reference paths in the DB.

9. Reader implementation
- Prototype strategies: chunked PageView or HTML/XHTML-based rendering with `flutter_widget_from_html` or RichText with custom spans. Validate pagination, selection, and highlights with real long chapters.

10. API keys & security
- Use `flutter_secure_storage` backed by Android Keystore. Add `SECURITY.md` describing threat model, key lifecycle, and privacy rules (no telemetry by default, no key leakage in logs).

11. Export formats
- MVP: JSON export only. Defer EPUB/Markdown generation to v1.1/v1.5.

---

## Non-functional requirements and performance

- Add concrete NFRs where missing: performance budgets (library load, chapter render), storage quotas, and battery goals.
- Use SQLite FTS5 or equivalent for fast full-text search. Add indexing for common queries.
- Lazy-load and paginate lists (library, chapters, search results) and implement an in-memory active-book cache.

---

## Recommended architecture (high-level)

Layered Clean Architecture:

- Presentation: Flutter widgets + Riverpod providers/ViewModels
- Domain: Entities and use-cases (CreateBook, GeneratePrompt, AddHighlight, ExportBook)
- Data: Repositories, Drift/Isar DB, file storage adapter, secure storage adapter

Suggested directories under `lib/`:
```
lib/
├── app/
├── core/
├── features/
│   ├── library/
│   ├── book_detail/
│   ├── reader/
│   ├── editor/
│   ├── generation/
│   └── settings/
└── shared/
```

---

## Missing documentation (create these before or alongside implementation)

- `ARCHITECTURE.md` — System diagrams, layer responsibilities, tradeoffs.
- `ARCHITECTURE_DATA_LAYER.md` — ERD, schema, DDL, migration strategy, repository contracts.
- `ARCHITECTURE_INTENT_WORKFLOW.md` — State machine, Intent filter config, deep link routing, clipboard policy.
- `SECURITY.md` — Threat model, key storage, encryption, privacy rules.
- `TESTING_STRATEGY.md` — Test pyramid, critical-path tests, performance benchmarks.

---

## Roadmap & prioritized actions (short-term)

Week 0 (shakedown)
- Create above architecture docs (3–5 days)
- Add DB dependency (Drift) and initial schema draft

Week 1 (validation)
- Reader prototype with 5–10k-word chapter (1 week)
- Intent workflow tests with ChatGPT/Claude mobile apps (3 days)

Week 2 (foundation)
- Implement normalized schema and repositories
- Configure Riverpod and core providers
- Implement file-storage layout and JSON import/export

Week 3+ (MVP build)
- Library UI and book creation
- TOC prompt generation and paste/parse preview
- Chapter editor paste/save flow
- Reader with basic highlights/bookmarks

Estimated revised timeline for MVP: 12–15 weeks (includes architecture and prototyping).

---

## Quick wins (low-effort, high-impact)

- Add `flutter_secure_storage` now and store preferences securely.
- Add a small prototype reader demo with sample text to validate performance.
- Implement best-effort TOC parsing + editable preview to avoid blocking users.

---

## Final notes

ReadForge's product and UX thinking are very strong — the technical work here is primarily about selecting the right primitives (DB, storage layout, reader approach) and proving assumptions via short prototypes. If prototypes are green, the existing product requirements and UX docs give an excellent roadmap for feature development.

If you want, I can:
- Create the missing documentation files (`ARCHITECTURE.md`, `ARCHITECTURE_DATA_LAYER.md`, `ARCHITECTURE_INTENT_WORKFLOW.md`, `SECURITY.md`) with initial content templates, or
- Implement a minimal reader prototype and add `drift` to `pubspec.yaml` and a starter schema.

Which of these should I do next?

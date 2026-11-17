# Architectural & Design Decisions Log (DECISIONS.md)

### ADR 001: Clean Architecture with Feature-First Organization
- **Status**: Accepted
- **Context**: The app features complex domain rules (10-dimensional compatibility, pairwise match vectors, conditional chat unlocks, multi-step onboarding).
- **Decision**: Feature-first folder layout (`features/<name>/presentation|application|domain|data`). All Firebase dependencies reside exclusively in the `data/` layer behind domain repository interfaces.
- **Consequences**: Easy unit testing with mocks, zero leaking of Firebase SDK types into UI widgets.

### ADR 002: Server-Side Vector Computation & KVKK Blind Compatibility Engine
- **Status**: Accepted (Updated for Strict KVKK Compliance)
- **Context**: Displaying personal behavioral scores, psychological archetypes, or radar chart comparisons of either the user or matched candidates creates profiling and data-exposure risks under KVKK (Law No. 6698 Articles 4, 5, 6, and 11) and GDPR.
- **Decision**:
  1. **Zero-Knowledge / Black-Box Test Processing**: Raw answers stay in `users/{uid}/answers/{scenarioId}` and computed vectors are written to an isolated, write-only `privateVectors/{uid}` collection (`allow read: if false;` on client).
  2. **No Personal or Candidate Test Score Disclosure**: Neither the user's own test results (10-dimension scores, radar charts, archetypes) nor matched candidates' test results are ever displayed in the UI.
  3. **Blind Harmony & Neutral House Rules Output**: The system exposes only verified hard-filter matches, a high-level friction tier (e.g., *High Harmony • Low Friction*), anonymous verified harmony categories, and neutral *Shared House Rules* before chat. Users can reset and anonymize their test vector at any time (KVKK Article 7 & 11 Right to Erasure).
- **Consequences**: Full KVKK compliance, zero psychological profiling exposure, anti-tampering, and complete privacy between matched roommates.

### ADR 003: Riverpod (Code Generation) & GoRouter Auth Guards
- **Status**: Accepted
- **Context**: State management needs to be reactive, type-safe, and seamlessly synchronized with authentication and onboarding status.
- **Decision**: Use `flutter_riverpod` + `riverpod_annotation`. `go_router` uses a reactive `refreshListenable` derived from `authNotifier` to handle redirects (Unauthenticated -> Login, Unverified -> Verify Email, Incomplete Onboarding -> Onboarding Step, Completed -> Discover Feed).
- **Consequences**: Bulletproof navigation without routing race conditions.

### ADR 004: Bilingual First-Class Support (Turkish & English)
- **Status**: Accepted
- **Context**: Primary target market is Turkey (students & young professionals), with international expansion readiness.
- **Decision**: Default locale is Turkish (`tr`), with English (`en`) supported via Flutter `l10n` ARB files. All scenario text, explanations, and UI labels are dual-authored.
- **Consequences**: No hardcoded strings anywhere in the UI.

### ADR 005: Client-Side Image Pre-Processing
- **Status**: Accepted
- **Context**: Storing large, uncompressed camera photos incurs bandwidth, storage, and rendering costs.
- **Decision**: Profile photos are resized to max 1080px width/height and compressed to JPEG 80% prior to Cloud Storage upload.
- **Consequences**: Fast uploads, lower Firebase Storage costs, smooth card feed rendering.

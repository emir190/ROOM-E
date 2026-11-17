# ADR-001: Clean Architecture with Feature-First Organization

**Date:** 2026-11-15 
**Author:** İsmail Uğur (2411011043)  
**Milestone:** P1  
**Tool and model used:** Antigravity (Gemini 3.8 Flash)

## Context
The Roomie app required scalable architecture supporting 10-dimensional compatibility analysis, authentication, onboarding, and offline capabilities. We needed a clean directory structure that completely decouples domain models and business logic from external libraries like Firebase SDK and Flutter UI widgets to prevent architectural rot and allow unit testing.

## Prompt
```
Design a scalable Flutter Clean Architecture structure with feature-first organization for Roomie. Ensure domain entities, repositories, application state, and presentation layers are strictly separated, keeping Firebase dependencies confined to the data layer.
```

## Result
The AI generated a feature-first modular directory hierarchy (`lib/features/{auth,onboarding,scenarios,matching}`) separating `domain/`, `data/`, `application/`, and `presentation/`. Domain repository interfaces (`AuthRepository`, `ScenarioRepository`) use Result types (`Success`/`Error`), while Firebase implementations (`AuthRepositoryImpl`, `OnboardingRepositoryImpl`) encapsulate all Firebase SDK calls.
Commit: `694394c` (feat(phase-1): initialize flutter project, theme, router, l10n, auth and onboarding)

## Rejected suggestion(s) — at least one
The AI initially suggested placing Firebase Firestore snapshot listeners and data serialization logic directly inside Riverpod presentation controllers to reduce boilerplate. I rejected this suggestion because exposing Firestore types (`DocumentSnapshot`, `QuerySnapshot`) inside the UI/presentation layer violates Clean Architecture principles, tightly couples the frontend to Firebase, and prevents writing clean mock unit tests without mocktail Firebase stubs.

## Verification
Verified through automated unit tests in `test/features/auth/auth_controller_test.dart` and `test/features/onboarding/onboarding_controller_test.dart` using mocktail repository stubs with 100% test pass rate (`flutter test`), ensuring zero Firebase runtime crashes when repositories are mocked.

## What I learned
Enforcing strict layer boundaries via repository interfaces makes both mocking and unit testing significantly easier, and shields UI widgets from backend SDK changes.

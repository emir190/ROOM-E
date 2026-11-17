# ADR-003: Riverpod State Management and GoRouter Auth Guards

**Date:** 2026-11-15  
**Author:** İsmail Uğur (2411011043)  
**Milestone:** P1  
**Tool and model used:** Antigravity (Gemini 3.8 Flash)

## Context
The app navigation flow depends strictly on authentication state, email verification status, and completion of the multi-step onboarding questionnaire. Manual navigation (`Navigator.push`) creates race conditions, back-button loop bugs, and vulnerability to deep-links bypassing onboarding or email verification screens.

## Prompt
```
Configure GoRouter navigation with declarative authentication guards synchronized to Riverpod auth state. Handle transitions between login, email verification, onboarding wizard, and main discover feeds without route race conditions.
```

## Result
Configured `GoRouter` in `lib/core/router/app_router.dart` with a central `redirect` callback that watches `authControllerProvider`. A `Listenable` adapter notifies GoRouter whenever authentication status or profile completeness changes, automatically redirecting unauthenticated users to `/login`, unverified users to `/verify-email`, and incomplete profiles to `/onboarding`.
Commit: `694394c` (feat(phase-1): initialize flutter project, theme, router, l10n, auth and onboarding)

## Rejected suggestion(s) — at least one
The AI suggested placing `Navigator.pushReplacementNamed` inside button `onPressed` handlers after each successful authentication API call. I rejected this approach because imperative navigation scatters authorization logic across multiple UI files, fails to protect against browser/deep-link URL direct navigation, and introduces flash of unauthenticated content when auth tokens expire asynchronously.

## Verification
Automated widget and router tests verify that initial unauthorized state directs to `/login`, while setting mock auth credentials automatically routes the tester to the home dashboard (`DiscoverFeedScreen`) without manual push calls.

## What I learned
Centralizing route authorization in GoRouter's declarative `redirect` engine guarantees that security boundaries cannot be bypassed by UI-level navigation mistakes or Android back-button stacks.

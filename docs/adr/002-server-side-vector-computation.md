# ADR-002: Server-Side Compatibility Vector & KVKK Privacy Protection

**Date:** 2026-11-15  
**Author:** İsmail Uğur (2411011043)  
**Milestone:** P1  
**Tool and model used:** Antigravity (Gemini 3.8 Flash)

## Context
Roommate matching requires evaluating sensitive personal habits (cleanliness, sleep schedules, guest frequency, noise levels). Calculating match scores and comparing answers client-side on the user's phone would require downloading candidates' raw survey responses, creating a severe KVKK/GDPR privacy violation and allowing users to tamper with scoring algorithms.

## Prompt
```
Architect the data storage and scoring workflow for roommate compatibility in Firestore. Ensure raw personal survey answers remain private to each student under KVKK/GDPR, while public feeds only expose sanitized lifestyle vectors and aggregate match percentages.
```

## Result
A two-tier collection structure was adopted: private answers and sensitive profiles reside in `users/{uid}/answers/{scenarioId}` accessible only by the owner (`request.auth.uid == userId`). Cloud Functions compute the 10-dimensional profile vector and publish aggregated scores to `matches/{pairId}` and sanitized summaries to `publicProfiles/{uid}`.
Commit: `a6f760c` (feat(phase-2): scenario test models, 32 bilingual seeds, test flow, radar chart and archetype analysis)

## Rejected suggestion(s) — at least one
The AI suggested storing all survey responses directly inside each user's root `users/{uid}` document and using Firestore field masks to filter them on client read. I rejected this because Firestore rules cannot partially grant read permissions to select fields within a single document; once a client has read access to a document, all fields are exposed in network packets, which would breach user privacy.

## Verification
Verified by drafting declarative Firestore security rules in `firestore.rules` and testing in Firebase Rules Playground: read requests from unauthenticated or foreign UIDs to `/users/{userId}/answers/{scenarioId}` are explicitly denied (`Simulated write/read denied`), while authenticated owners can read/write successfully.

## What I learned
Firestore security rules operate at document granularity, making subcollection isolation (`users/{uid}/answers`) the only secure way to separate private sensitive survey data from public discovery fields.

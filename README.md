# Roomie

[![CI](https://github.com/Lufi735/roomiesync/actions/workflows/ci.yml/badge.svg)](https://github.com/Lufi735/roomiesync/actions/workflows/ci.yml)

A roommate matching and compatibility mobile application built with Flutter, Firebase, and AI.

---

## 📌 P1 Demo Links & Deliverables

- **GitHub Repository**: [Lufi735/roomiesync](https://github.com/Lufi735/roomiesync)
- **CI / Actions (Green CI Run)**: [GitHub Actions Workflows](https://github.com/Lufi735/roomiesync/actions)
- **GitHub Issues & Planning Board**: [GitHub Issues Board](https://github.com/Lufi735/roomiesync/issues) · [Projects Board](https://github.com/Lufi735/roomiesync/projects)

### 📄 Architecture Decision Records (docs/adr/)
All ADRs follow the course template including Context, Prompt, Result, Rejected Suggestion, Verification, and What I Learned:
1. [ADR-001: Clean Architecture with Feature-First Organization](docs/adr/001-clean-architecture-feature-first.md)
2. [ADR-002: Server-Side Compatibility Vector & KVKK Privacy Protection](docs/adr/002-server-side-vector-computation.md)
3. [ADR-003: Riverpod State Management and GoRouter Auth Guards](docs/adr/003-riverpod-and-gorouter-auth-guards.md)

---

## 👥 Team (El Comp · Team T09)
See [TEAM.md](TEAM.md) for full member details:
- **Kerem Babaoğlu** — Back End Lead (2411011038)
- **Emir Buğra Koçak** — QA & KVKK Lead (2411011070)
- **Orkun Kuzuoğlu** — AI & Prompt Lead (2411011089)
- **İsmail Uğur** — Front End Lead (2411011043)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.24+)
- Firebase CLI (`firebase-tools`)
- FlutterFire CLI (`flutterfire`)

### Setup & Run
```bash
# Clone the repository
git clone https://github.com/Lufi735/roomiesync.git
cd roomiesync

# Install dependencies
flutter pub get

# Configure Firebase credentials (for your environment)
flutterfire configure

# Run automated tests
flutter test

# Run app on emulator or physical phone
flutter run
```

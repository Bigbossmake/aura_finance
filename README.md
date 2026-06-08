<h1 align="center">
  <br>
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/ui/layout/app-bar-with-icon.png" alt="Aura Finance" width="120">
  <br>
  Aura Finance
  <br>
</h1>

<h4 align="center">Intelligent, secure, and beautiful personal finance manager built with <a href="https://flutter.dev" target="_blank">Flutter</a>.</h4>

<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter">
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  </a>
  <a href="https://pub.dev/packages/drift">
    <img src="https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite/Drift">
  </a>
  <a href="https://github.com/Bigbossmake/aura_finance/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License">
  </a>
</p>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#tech-stack">Tech Stack</a>
</p>

<br>

Aura Finance is a premium, offline-first personal finance application designed to help you take control of your money. With a stunning glassmorphic interface, AI-powered transaction categorization, and deep device integration (biometrics, local notifications), Aura feels like a native assistant right in your pocket.

## Key Features

✨ **Premium Glassmorphic UI**  
Experience a beautiful, modern design with custom animations, blurred overlays, and a dark theme that feels native and fluid.

🧠 **AI Transaction Categorization**  
No more manual tagging. Aura intelligently parses raw bank statements (e.g., "UBER *TRIP 09-12") and automatically assigns them to the correct category like `Transport` with a confidence score.

📊 **Budgets & Predictive Insights**  
Set monthly budgets for different categories. Aura tracks your spending in real-time and provides predictive insights, notifying you about upcoming recurring subscriptions.

🔐 **Secure by Design (Biometrics)**  
Your financial data is yours. The app uses FaceID / Fingerprint authentication via `local_auth` to ensure only you can access your dashboard. Data is stored completely offline using SQLite.

🌍 **Global Localization (20+ Languages)**  
Seamlessly switch between English, Russian, Spanish, French, German, Japanese, Chinese, and many more, straight from the dashboard.

📥 **Export to CSV**  
Easily export your transaction history to a CSV file and share it with your accountant or save it to your files via native sharing.

## Architecture

Aura Finance is built using **Clean Architecture** principles to ensure scalability and maintainability:

- **Domain Layer:** Contains business logic, models (`TransactionModel`, `BudgetModel`), and the `TransactionCategorizer`.
- **Data Layer:** Uses `Drift` (SQLite) for robust, type-safe offline storage.
- **Presentation Layer:** State is managed cleanly, using a component-based approach for complex UI elements like bottom sheets and animated charts.
- **Core Services:** Separated services for Notifications, Biometrics, and Localization.

## How To Use

To clone and run this application, you'll need [Git](https://git-scm.com) and [Flutter](https://flutter.dev/docs/get-started/install) installed on your computer.

From your command line:

```bash
# Clone this repository
$ git clone https://github.com/Bigbossmake/aura_finance.git

# Go into the repository
$ cd aura_finance

# Install dependencies
$ flutter pub get

# Run the app
$ flutter run
```

## Tech Stack

- **Framework:** Flutter & Dart
- **Local Database:** Drift (SQLite)
- **Security:** `local_auth`
- **Background Tasks & Notifications:** `flutter_local_notifications`, `timezone`
- **Data Export:** `path_provider`, `share_plus`
- **State Management:** `shared_preferences` (for onboarding state)
- **UI & Typography:** `google_fonts`

---

> Built with ❤️ by Bigbossmake & Antigravity.

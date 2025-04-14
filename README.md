# 🍽️ Restaurant App

A Flutter-based application that displays a list of restaurants, allows users to view detailed information, and save favorites locally. Built as part of the **IDCamp x Dicoding - Multi-Platform App Developer** scholarship program.

![Flutter](https://img.shields.io/badge/Built_with-Flutter-blue?logo=flutter)
![Provider](https://img.shields.io/badge/State_Management-Provider-brightgreen)
![Test Coverage](https://img.shields.io/badge/Testing-Unit_%7C_Widget_%7C_Integration-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## ✨ Features

- 🔍 Search for restaurants by keyword
- 📋 Browse a list of restaurants from a remote API
- 🍽️ View detailed restaurant information including menus and ratings
- ❤️ Mark restaurants as favorites (stored in local SQLite database)
- 🔔 Daily reminder notifications using Workmanager
- 🧪 Includes Unit, Widget, and Integration tests

---

## 🧰 Tech Stack

| Category         | Technology                         |
| ---------------- | ----------------------------------- |
| Framework        | Flutter                             |
| Language         | Dart                                |
| State Management | Provider                            |
| Local Storage    | SQLite                              |
| Notifications    | Workmanager                         |
| API              | [Dicoding Restaurant API](https://restaurant-api.dicoding.dev/) |
| Testing          | `flutter_test`, `integration_test`  |

---

## 📱 App Preview

| Home Page | Detail Page | Favorite Page |
| --------- | ----------- | -------------- |
| ![home_screen](https://github.com/user-attachments/assets/fc1db5c8-35aa-4cf9-9115-6e257cc2b2d9) | ![detail_screen](https://github.com/user-attachments/assets/93dd5115-1933-463f-8782-a47cd99886d9) | ![favourite_screen](https://github.com/user-attachments/assets/814d84f7-d450-4d32-9980-8ce7823f8e53) |

---

## 🧪 Testing Strategy

This app is well-tested to ensure performance and reliability:

- ✅ Unit Testing
- ✅ Widget Testing
- ✅ Integration Testing

---

## 🚀 Getting Started

To run the app locally:

```bash
git clone https://github.com/romydewantara/restaurant-app.git
cd restaurant-app
flutter pub get
flutter run
```

To run the tests:
```bash
flutter test
```

To run integration tests:
```bash
flutter test integration_test/
```

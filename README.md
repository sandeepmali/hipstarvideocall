# hipstarvideocall

video calling app

## Getting Started

# 📱 Meetify – Flutter One-to-One Video Calling Demo (AWS Chime SDK)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.7-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-lightgrey.svg)]()
[![AWS Chime](https://img.shields.io/badge/AWS%20Chime-Integrated-orange?logo=amazonaws)](https://aws.amazon.com/chime/)

---

## Overview

**Meetify** is a Flutter-based real-time **one-to-one video calling app** powered by **Amazon Chime SDK**.  
It demonstrates **clean architecture**, **BLoC state management**, **provider integration**, and a **mock login + user list system**.

This demo showcases how to connect a Flutter frontend with a local **Node.js AWS Chime backend** to manage meetings and real-time video connections.

---

## ✨ Features

✅ Splash screen and custom app icon  
✅ Login screen with validation (email & password)  
✅ Mock authentication using [ReqRes API](https://reqres.in/)  
✅ User list screen with avatar + name (fetched from fake REST API)  
✅ Cached user list (works offline via `SharedPreferences`)  
✅ One-to-one live video call using **Amazon Chime SDK**  
✅ App versioning & signing (custom keystore included)  
✅ Clean Architecture: separation of data, domain, and UI layers

---

##  Project Structure

lib/
│
├── main.dart # App entry point
│
├── bloc/ # State management (BLoC pattern)
│ ├── user_list/ # Handles user list states & logic
│ └── video_call/ # Manages video call & meeting state
│
├── data/ # Data layer (API + local)
│ ├── models/ # Data models (User, Meeting, etc.)
│ └── services/ # REST + AWS Chime integration
│
├── presentation/ # UI Layer
│ ├── pages/ # All screens (Splash, Login, etc.)
│ │ ├── splash_screen.dart
│ │ ├── login_screen.dart
│ │ ├── user_list_screen.dart
│ │ └── chime_meeting_screen.dart
│ └── widgets/ # Reusable UI components
│
├── utils/ # Helper functions & constants
│
└── assets/
└── aws_backend_server/
└── server.js # Local Node.js backend for AWS Chime


---

## Dependencies Used

| Package | Version | Description |
|----------|----------|-------------|
| `flutter_aws_chime` | ^1.1.0+1 | Integrate AWS Chime SDK for real-time calls |
| `flutter_webrtc` | ^0.12.6 | WebRTC handling for video/audio streams |
| `flutter_bloc` | ^9.0.0 | BLoC state management |
| `provider` | ^6.1.2 | Dependency injection |
| `equatable` | ^2.0.5 | Model equality & cleaner state updates |
| `http` | ^1.5.0 | REST API calls |
| `permission_handler` | ^11.3.0 | Camera & microphone permission requests |
| `shared_preferences` | ^2.3.3 | Local caching (offline user list) |

---

## Architecture Overview

This project follows the **Clean Architecture pattern**:

**Presentation Layer:**  
→ Flutter UI built using BLoC & Provider for state management.

**Domain Layer:**  
→ Business logic and use cases.

**Data Layer:**  
→ Handles all data sources (REST API, AWS Chime SDK, SharedPreferences).

Benefits:
- High modularity
- Easy unit testing
- Simplified maintenance

---

## 🖥️ How to Run the App

### 🔧 1. Clone Repository
```bash
git clone https://github.com/sandeepmali/hipstarvideocall.git
cd hipstarvideocall

2. Setup AWS Chime Backend (Node.js)

To establish a video call, the app needs meeting info from AWS Chime SDK.

Steps:

Ensure Node.js is installed on your system.

Navigate to the backend folder:

cd assets/aws_backend_server


Install dependencies (if required):

npm install


Run the backend:

node server.js


This starts a local server (default: http://localhost:3000).

Find your local IP address (e.g., 192.168.1.10) and update it in your Flutter app where the Chime API URL is defined.
The app will then fetch live meeting details from this backend.

3. Run Flutter App

Back to your Flutter project root:

flutter pub get
flutter run


Then:

Login using mock credentials from ReqRes API

(e.g., eve.holt@reqres.in / cityslicka)

The app will redirect to the User List Screen

Tap on a user → Start one-to-one video call

App Signing Configuration

Custom keystore generated under:

android/app/meetify-key.jks


Key Details (for demo only):

storePassword=android
keyPassword=android
keyAlias=meetify
storeFile=app/meetify-key.jks


Configured via key.properties and build.gradle.

App Versioning

Set in pubspec.yaml:

version: 1.2.3+5


Maps to:

Android → versionCode / versionName

iOS → Build & Version fields in Xcode

📸 Screenshots
Splash	Login	User List	Video Call

	
	
	

(You can capture and add screenshots in assets/screenshots/ folder.)

🧑‍💻 Developer Notes

Built with Flutter 3.35.7, Dart 3.x, Java 17

Debug and release signing configured

Local AWS Chime server integration for meetings

Extendable for group calls, chat, or notifications

Optimized for Android (tested) and iOS compatibility

🌐 Repository

🔗 GitHub Link: https://github.com/sandeepmali/hipstarvideocall
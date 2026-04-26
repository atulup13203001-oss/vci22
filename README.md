# Vimal Coaching Institute - Educational App

A professional educational course selling app built with Flutter and Firebase Realtime Database.

## Features

- **Course Management**: Admins can add, update, and delete courses.
- **Ebook Store**: Sell educational ebooks with PDF viewer integration.
- **Video Lectures**: Integrated YouTube player for unlisted course videos.
- **Payment Integration**: Razorpay and UPI payment support.
- **Realtime Database**: High-performance data syncing using Firebase Realtime Database.
- **Course Sharing**: Easily share course links and details with others.
- **Admin Panel**: Comprehensive dashboard for managing users, courses, and analytics.

## Tech Stack

- **Frontend**: Flutter (GetX for state management and routing)
- **Backend**: Firebase Auth, Realtime Database, Storage
- **Payments**: Razorpay
- **Media**: YouTube Player, PDFx

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Firebase Account
- Razorpay Account

### Setup

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. The Firebase configuration is already integrated in `lib/config/firebase_config.dart`.
4. Run the app using `flutter run`.

## Deployment (APK Building)

This project is configured with **GitHub Actions** to automatically build the APK.

1. Push your code to the `main` branch of your GitHub repository.
2. Go to the **Actions** tab in your GitHub repository.
3. The "Build APK" workflow will start automatically.
4. Once completed, you can download the `app-release.apk` from the artifacts section of the workflow run.

## License

This project is licensed under the MIT License.

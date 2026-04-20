# ImageFeed

ImageFeed is an iOS app for viewing and interacting with an image feed. The app includes OAuth authentication, a feed of images, a profile screen, and a full-screen image viewer.

## Features

- OAuth 2.0 authentication
- Authorization flow via WebView
- Image feed with remote data loading
- Full-screen image viewer
- Profile screen with user data and avatar
- Logout flow
- Network error handling
- Unit and UI tests

## Tech Stack

- Swift
- UIKit
- MVP
- OAuth 2.0
- WebKit
- URLSession
- Decodable / Codable
- UserDefaults
- Kingfisher
- XCTest (Unit and UI tests)

## Installation

1. Clone the repository:
   `git clone https://github.com/maximgv3/ImageFeed.git`

2. Open the project:
   `open ImageFeed.xcodeproj`

3. Run the app in Xcode.

## Architecture

The project is split into several feature modules:

- **Auth** — authentication flow, OAuth token handling, and WebView-based login
- **Feed** — image list, image loading, and single image screen
- **Profile** — profile data, avatar loading, and logout
- **Shared** — shared models, networking, alerts, and UI utilities

The app uses **MVP** in presentation logic and separates UI, business logic, and services.

## Testing

The project includes:

- Unit tests for WebView, feed logic, and profile presentation
- UI tests for main user flows

Run all tests in Xcode with `Cmd + U`.

## Result

This project demonstrates work with multi-screen UIKit applications, OAuth authorization, networking, image loading, modular project structure, and test coverage.

# CreditScore – Mobile Tech Task

## Overview

**CreditScore** is a small SwiftUI application that fetches a user’s credit score from a remote endpoint and displays it in a donut (circular) progress view. This project serves as a technical demonstration of:

- **SwiftUI** UI layouts
- **Combine** / async/await for data fetching
- **MVVM** design pattern
- **Dependency Injection** for testability
- **Unit Testing** with `XCTest`

## Requirements

- **Xcode 14 (or higher)** and Swift 5.7+
- iOS 16+ deployment target (can be adjusted as needed)

## How It Works

1. On launch, the `CreditScoreRootView` creates and observes a `CreditScoreViewModel`.
2. The app calls `fetchCreditScore()` from the `ViewModel`, which uses `CreditScoreNetworkService` to fetch the credit data from the provided endpoint.
3. The fetched score and maximum possible score are passed into `DonutView`, which draws a circular ring showing the completion percentage.
4. If a network error occurs, the user sees an error icon and a “Try Again” button.

## Architecture

The application follows the MVVM (Model-View-ViewModel) architecture pattern and SOLID principles:

- **Models** (`CreditScoreModel.swift`) define the data structures returned by the API.
- **ViewModels** (`CreditScoreViewModel.swift`) manage the app state, handling data fetching and error handling.
- **Views** (`CreditScoreRoottView.swift` and `CreditScoreRingView.swift`) display the current state and user interface.
- **Services** (`CreditScoreNetworkService.swift`) handle all network requests and data parsing.
- **Tests** (`CreditScoreTests.swift`) performs unit tests on crucial app functionality.

## Notable Features

- **Async/Await** for streamlined network calls.
- **Dependency Injection** via `NetworkServiceProtocol` so we can swap in a `MockNetworkService` in tests.
- **SwiftUI Previews** in `CreditScoreRingView` to quickly visualize multiple states of the donut ring.
- **Unit Tests** (`CreditScoreTests.swift`) that validate different scoring conditions and error scenarios.

## Testing

1. Open the project in Xcode.
2. Press **Command + U** (or go to `Product > Test`) to run all tests.
3. Check the log to ensure all tests pass.

Tests included:
- **`testMinimumScore()`** ensures a score of `0` is handled properly.
- **`testMaximumScore()`** ensures a score of `700` is handled properly.
- **`testTimeout()`** ensures timeouts are caught and produce the correct user error message.

## Future Improvements

- **More Detailed Error Handling**: Differentiate user‐facing messages for different network failures.
- **Additional UI States**: Show partial data or placeholders if partial data is available.
- **Refine Testing**: Use more advanced strategies (e.g., UI Testing with SwiftUI).

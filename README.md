# SwiftRetry

A lightweight, modern retry utility for Swift concurrency featuring exponential backoff and jitter support.

## Overview

`SwiftRetry` provides an intuitive async/await API to handle transient failures in network calls, database queries, and background tasks. Built natively for Swift 6 with strict concurrency safety.

## Requirements

- Swift 6.0+
- macOS 14.0+ / iOS 17.0+

## Installation

Add `SwiftRetry` to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/example/swift-retry.git", from: "1.0.0")
]
```

## Usage

### Basic Retry

```swift
import SwiftRetry

let data = try await retry(maxAttempts: 3, baseDelay: .seconds(1), backoffFactor: 2.0) {
    try await fetchData()
}
```

### Using Retry Policies

```swift
let response = try await retry(policy: .network) {
    try await client.sendRequest()
}
```

Available presets include `.network`, `.aggressive`, and `.conservative`.

### Error Handling

When all attempts fail, `SwiftRetry` throws a `RetryError` containing total attempts and the underlying error:

```swift
do {
    let result = try await retry { try await performTask() }
} catch let error as RetryError {
    print("Failed after \(error.attempts) attempts: \(error.lastError)")
}
```

## License

MIT License. See [LICENSE](LICENSE) for details.

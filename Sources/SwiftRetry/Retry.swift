import Foundation

/// Retries an asynchronous throwing operation using exponential backoff.
///
/// - Parameters:
///   - maxAttempts: The maximum number of attempts before throwing `RetryError`.
///   - baseDelay: The initial delay duration after the first failure.
///   - backoffFactor: Multiplier for exponential backoff on each subsequent attempt.
///   - jitter: Whether to introduce randomized jitter to the backoff delay.
///   - operation: The asynchronous throwing closure to execute.
/// - Returns: The value returned by `operation` upon success.
/// - Throws: `RetryError` if all attempts fail, or `CancellationError` if cancelled.
public func retry<T: Sendable>(
    maxAttempts: Int = 3,
    baseDelay: Duration = .seconds(1),
    backoffFactor: Double = 2.0,
    jitter: Bool = false,
    operation: @Sendable () async throws -> T
) async throws -> T {
    precondition(maxAttempts >= 1, "maxAttempts must be at least 1")
    var currentDelay = baseDelay
    var lastError: (any Error & Sendable)?

    for attempt in 1...maxAttempts {
        try Task.checkCancellation()
        do {
            return try await operation()
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            lastError = error
        }

        if attempt < maxAttempts {
            let sleepDelay = jitter ? currentDelay * Double.random(in: 0.5...1.0) : currentDelay
            try await Task.sleep(for: sleepDelay)
            currentDelay = currentDelay * backoffFactor
        }
    }

    throw RetryError(attempts: maxAttempts, lastError: lastError!)
}

/// Retries an asynchronous throwing operation using exponential backoff.
public func retry<T: Sendable>(
    maxAttempts: Int = 3,
    baseDelay: Duration = .seconds(1),
    backoffFactor: Double = 2.0,
    operation: @Sendable () async throws -> T
) async throws -> T {
    try await retry(
        maxAttempts: maxAttempts,
        baseDelay: baseDelay,
        backoffFactor: backoffFactor,
        jitter: false,
        operation: operation
    )
}

/// Retries an asynchronous throwing operation according to a `RetryPolicy`.
public func retry<T: Sendable>(
    policy: RetryPolicy,
    operation: @Sendable () async throws -> T
) async throws -> T {
    try await retry(
        maxAttempts: policy.maxAttempts,
        baseDelay: policy.baseDelay,
        backoffFactor: policy.backoffFactor,
        jitter: policy.jitter,
        operation: operation
    )
}

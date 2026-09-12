import Foundation

/// An error thrown when an operation fails after exhausting all retry attempts.
public struct RetryError: Error, Sendable, CustomStringConvertible {
    /// The total number of attempts executed before failing.
    public let attempts: Int

    /// The error encountered during the final attempt.
    public let lastError: any Error & Sendable

    /// Creates a new `RetryError`.
    /// - Parameters:
    ///   - attempts: Total number of attempts that were executed.
    ///   - lastError: The underlying error from the last failed attempt.
    public init(attempts: Int, lastError: any Error & Sendable) {
        self.attempts = attempts
        self.lastError = lastError
    }

    public var description: String {
        "RetryError(attempts: \(attempts), lastError: \(lastError))"
    }
}

import Foundation

/// Defines retry rules, delay progression, and jitter configuration.
public struct RetryPolicy: Sendable, Equatable {
    public var maxAttempts: Int
    public var baseDelay: Duration
    public var backoffFactor: Double
    public var jitter: Bool

    public init(
        maxAttempts: Int = 3,
        baseDelay: Duration = .seconds(1),
        backoffFactor: Double = 2.0,
        jitter: Bool = false
    ) {
        self.maxAttempts = maxAttempts
        self.baseDelay = baseDelay
        self.backoffFactor = backoffFactor
        self.jitter = jitter
    }

    /// Fast retries for low-latency operations.
    public static let aggressive = RetryPolicy(maxAttempts: 3, baseDelay: .milliseconds(100), backoffFactor: 1.5, jitter: true)

    /// Patient retries with longer intervals for background workloads.
    public static let conservative = RetryPolicy(maxAttempts: 5, baseDelay: .seconds(2), backoffFactor: 2.0, jitter: true)

    /// Standard backoff profile tuned for resilient network requests.
    public static let network = RetryPolicy(maxAttempts: 4, baseDelay: .seconds(1), backoffFactor: 2.0, jitter: true)
}

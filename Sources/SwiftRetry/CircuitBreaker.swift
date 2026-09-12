import Foundation

/// Actor-based circuit breaker to prevent cascading failures during retries.
public actor CircuitBreaker {
    public enum State: Sendable { case closed, open, halfOpen }

    private var failures = 0
    private var lastFailure: ContinuousClock.Instant?
    private(set) public var state: State = .closed

    private let threshold: Int
    private let resetAfter: Duration

    public init(threshold: Int = 5, resetAfter: Duration = .seconds(30)) {
        self.threshold = threshold
        self.resetAfter = resetAfter
    }

    public func canExecute() -> Bool {
        switch state {
        case .closed: return true
        case .open:
            if let last = lastFailure, ContinuousClock.now - last > resetAfter {
                return true
            }
            return false
        case .halfOpen: return true
        }
    }

    public func recordSuccess() {
        failures = 0
        state = .closed
    }

    public func recordFailure() {
        failures += 1
        lastFailure = .now
        if failures >= threshold { state = .open }
    }
}

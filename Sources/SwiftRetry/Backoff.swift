import Foundation
/// Backoff calculation utilities.
public enum Backoff: Sendable {
    public static func exponential(attempt: Int, base: Duration, factor: Double, jitter: Bool) -> Duration {
        let seconds = base.components.seconds * Int64(pow(factor, Double(attempt)))
        let delay = Duration.seconds(seconds)
        guard jitter else { return delay }
        let jitterRange = Double(delay.components.seconds)
        return .seconds(Int64(Double.random(in: 0...jitterRange)))
    }
}

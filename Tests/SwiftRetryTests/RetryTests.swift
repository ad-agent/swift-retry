import Testing
import SwiftRetry

private struct TestError: Error, Sendable {}
private actor Counter {
    var value = 0
    func increment() -> Int { value += 1; return value }
}

@Test func testSuccessfulRetry() async throws {
    let counter = Counter()
    let result = try await retry(maxAttempts: 3, baseDelay: .milliseconds(5)) {
        let count = await counter.increment()
        if count < 2 { throw TestError() }
        return "recovered"
    }
    #expect(result == "recovered")
    #expect(await counter.value == 2)
}

@Test func testRetryExhaustion() async {
    let counter = Counter()
    await #expect(throws: RetryError.self) {
        try await retry(maxAttempts: 3, baseDelay: .milliseconds(5)) {
            _ = await counter.increment()
            throw TestError()
        }
    }
    #expect(await counter.value == 3)
}

@Test func testCancellation() async {
    let task = Task {
        try await retry(maxAttempts: 5, baseDelay: .seconds(2)) {
            throw TestError()
        }
    }
    task.cancel()
    let result = await task.result
    #expect(throws: CancellationError.self) {
        try result.get()
    }
}

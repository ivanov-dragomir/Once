import XCTest
@testable import Once

private extension Once.Token {
    static let simple = Once.Token(rawValue: "simple")
    static let interval = Once.Token(rawValue: "interval")
}

final class OnceTests: XCTestCase {
    func testSimplePerformOnce() {
        Once.perform(.simple) { print("Perform once.") }
        Once.perform(.simple) { XCTFail() }
    }
    
    func testInterval() {
        Once.perform(.interval, per: .interval(5)) { print("Perform once every 5 seconds.") }
        sleep(3)
        Once.perform(.interval, per: .interval(5)) { XCTFail() }
    }

    static var allTests = [
        ("testSimplePerformOnce", testSimplePerformOnce), ("testInterval", testInterval),
    ]
}

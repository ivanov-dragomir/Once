import XCTest
@testable import Once

private extension Once.Token {
    static let test = Once.Token(rawValue: "test")
}

final class OnceTests: XCTestCase {
    func testSimplePerformOnce() {
        Once.perform(.test) { print("Perform once.") }
        Once.perform(.test) { XCTFail() }
    }
    
    func testInterval() {
        Once.perform(.test, per: .interval(5)) { print("Perform once every 5 seconds.") }
        sleep(3)
        Once.perform(.test, per: .interval(5)) { XCTFail() }
    }

    static var allTests = [
        ("testSimplePerformOnce", testSimplePerformOnce), ("testInterval", testInterval),
    ]
}

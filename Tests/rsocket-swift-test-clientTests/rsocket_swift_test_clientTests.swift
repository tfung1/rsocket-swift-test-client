import XCTest
@testable import rsocket_swift_test_client

final class rsocket_swift_test_clientTests: XCTestCase {
    func testRequestResponseMetadataDataSame() throws {
        XCTAssertEqual(try RequestResponseClient.requestResponse(metadata: "metadata", data: "data"), true)
    }
}

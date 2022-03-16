import XCTest
@testable import rsocket_swift_test_client

final class rsocket_swift_test_clientTests: XCTestCase {
    func testRequestResponseMetadataDataSame() throws {
        let metadata = "myMetadata"
        let data = "myData"
        let response = try RequestResponseClient.requestResponse(metadata: metadata, data: data)
        // Test if metadata and data are the same sent vs received from server and echo back
        let status = (response?.payload.data == data && response?.payload.metadata == metadata)
        XCTAssertEqual(status, true)
    }
}

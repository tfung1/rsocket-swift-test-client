import ArgumentParser
import Foundation
import ReactiveSwift
import RSocketCore
import RSocketNIOChannel
import RSocketReactiveSwift
import RSocketWSTransport
import NIOCore
import NIOFoundationCompat
import rsocket_swift_test_client

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        guard let url = URL(string: argument) else { return nil }
        self = url
    }
    public var defaultValueDescription: String { description }
}

struct RequestResponseClientExample: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "connects to an RSocket endpoint using WebSocket transport, requests a request / response with metadata (default: `metadata`) and data (default: `data`) and compares echo from server"
    )

    @Argument(help: "metadata passed")
    var metadata = "metadata"

    @Argument(help: "data passed")
    var data = "data"

    @Option
    var url = URL(string: "ws://localhost:7000/")!

    func run() throws {
        print("connecting to url=\(url)")
        let response = try RequestResponseClient.requestResponse(metadata: metadata, data: data)
        let status = (response?.payload.data == data && response?.payload.metadata == metadata)
        if (status && response != nil) {
            print("Success")
        } else {
            print("Failed")
        }
    }
}

RequestResponseClientExample.main()

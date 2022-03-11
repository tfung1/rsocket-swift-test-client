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
    var url = URL(string: "ws://localhost:7000/v1/webevents")!

    func run() throws {
        if (try RequestResponseClient.requestResponse(metadata: metadata, data: data)) {
            print("Success")
        } else {
            print("Failed")
        }
    }
}

RequestResponseClientExample.main()
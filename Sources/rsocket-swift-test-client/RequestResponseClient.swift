import ArgumentParser
import Foundation
import ReactiveSwift
import RSocketCore
import RSocketNIOChannel
import RSocketReactiveSwift
import RSocketWSTransport
import NIOCore
import NIOFoundationCompat

public struct RequestResponseClient {

    public static func requestResponse(metadata: String, data: String) throws -> Bool {
        let decoder = JSONDecoder()
        var status = false
        let url = URL(string: "ws://localhost:7000/")!

        do {
            let bootstrap = ClientBootstrap(
                transport: WSTransport(),
                config: .mobileToServer
                    .set(\.encoding.metadata, to: .messageXRSocketRoutingV0)
                    .set(\.encoding.data, to: .applicationJson)
            )
            let client = try bootstrap.connect(to: .init(url: url)).first()!.get()
            var response : RequestResponsePayload? = nil
            try client.requester.build(RequestResponse {
                Encoder()
                    .encodeStaticMetadata("metadata", using: RoutingEncoder())
                    .mapData(ByteBuffer.init(string:))
                Decoder()
                    .mapData { data -> String in
                        // pretty print json
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                        print("mapdata=\(String(decoding: data, as: UTF8.self))")
                        response = try decoder.decode(RequestResponsePayload.self, from: data)
                        return String(decoding: data, as: UTF8.self)
                    }
            }, request: data)
            .logEvents(identifier: "requestResponse")
            .wait()
            .get()
            print("response=\(String(describing: response))")
            // Test if metadata and data are the same sent vs received from server and echo back
            status = (response?.payload.data == data && response?.payload.metadata == metadata)
        } catch {
            print("error=\(error.localizedDescription)")
            throw ClientError.dataNotSame(message: "metadata or data not same as sent")
        }
        
        return status
    }
}

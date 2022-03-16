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
    
    /// Calls RSocket RequestResponse and validates the metadata and data echoed from the server is same as what as sent
    /// - Parameters:
    ///   - metadata: request/response metadata to be sent to server
    ///   - data: request/response data to be sent to server
    /// - Returns: true if metadata and data returned from server is same as what was sent, false otherwise
    public static func requestResponse(metadata: String, data: String) throws -> RequestResponsePayload? {
        let decoder = JSONDecoder()
        var response : RequestResponsePayload? = nil
        let url = URL(string: "ws://localhost:7000/")!

        do {
            let bootstrap = ClientBootstrap(
                transport: WSTransport(),
                config: .mobileToServer
                    .set(\.encoding.data, to: .applicationJson)
            )
            let client = try bootstrap.connect(to: .init(url: url)).first()!.get()
            try client.requester.build(RequestResponse {
                Encoder()
                    // metadata w/o encoding
                    .setMetadata(ByteBuffer(string: metadata))
                    .mapData(ByteBuffer.init(string:))
                Decoder()
                    .mapData { data -> String in
                        let strData = data.getString(at: 0, length: data.readableBytes, encoding: .utf8)
                        print("raw_response=\(String(describing: strData))")
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let data = try JSONSerialization.data(withJSONObject: json)
                        response = try decoder.decode(RequestResponsePayload.self, from: data)
                        return String(decoding: data, as: UTF8.self)
                    }
            }, request: data)
            .wait()
            .get()
            let encodedData = try JSONEncoder().encode(response)
            let jsonString = String(data: encodedData,
                                    encoding: .utf8)
            print("response=\(String(describing: jsonString))")
        } catch {
            throw ClientError.runtimeError(message: error.localizedDescription)
        }
        
        return response
    }
}

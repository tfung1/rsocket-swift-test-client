//
//  RequestResponsePayload.swift
//
//
//  Created by Tony Fung on 3/11/22.
//

import Foundation

public struct Payload : Codable {
    public var metadata: String? = nil
    public var data: String
}

/// Response format from backend test echo server
public struct RequestResponsePayload : Codable {
    public var date: String? = nil
    public var payload: Payload
}

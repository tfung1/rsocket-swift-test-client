//
//  ClientError.swift
//
//
//  Created by Tony Fung on 3/11/22.
//
import Foundation

public enum ClientError: Error {
    case dataNotSame(message: String)
    case runtimeError(message: String)
}

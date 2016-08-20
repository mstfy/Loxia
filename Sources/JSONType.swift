//
//  JSONCreatable.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

import Foundation

public protocol JSONType {
    associatedtype RawType
    static func cast(from: Any) throws -> RawType
    init(json: RawType) throws
}

extension JSONType {
    public static func cast(from: Any) throws -> Self {
        guard let value = from as? Self else {
            throw MapperError.typeMismatch(type(of: from))
        }
        
        return value
    }
    
    public init(json: Self) throws {
        self = json
    }
}

extension String: JSONType {}
extension Int: JSONType {}
extension Double: JSONType {}
extension Float: JSONType {}
extension Bool: JSONType {}

extension URL: JSONType {
    public init(json: String) throws {
        guard let url = URL(string: json) else {
            throw MapperError.typeMismatch(type(of: json))
        }
        
        self = url
    }

    public static func cast(from: Any) throws -> String {
        guard let value = from as? String else {
            throw MapperError.typeMismatch(type(of: from))
        }
        
        return value
    }
}

//
//  JSONCreatable.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

public protocol JSONType {
    associatedtype CastType
    static func cast(from: Any) throws -> CastType
    init(json: CastType) throws
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

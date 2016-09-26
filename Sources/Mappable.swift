//
//  JSONCreatable.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

public protocol Mappable {
    associatedtype RawType
    static func cast(from: Any) throws -> RawType
    init(json: RawType) throws
}

extension Mappable {
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

extension String: Mappable {}
extension Int: Mappable {}
extension Double: Mappable {}
extension Float: Mappable {}
extension Bool: Mappable {}

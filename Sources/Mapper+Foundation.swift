//
//  Mapper+Foundation.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 22.08.2016.
//
//

import Foundation

extension Mapper {
    public static func from(data: Data) throws -> Mapper {
        return Mapper(try JSONSerialization.jsonObject(with: data, options: []))
    }
}

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

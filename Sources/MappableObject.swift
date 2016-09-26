//
//  JSONObject.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

public protocol MappableObject: Mappable {}

extension MappableObject {
    public static func cast(from: Any) throws -> Mapper {
        return Mapper(from)
    }
}

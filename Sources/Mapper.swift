//
//  Mapper.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

public struct Mapper {
    let content: Any
    
    public init(_ content: Any) {
        self.content = content
    }
    
    func parse(for keys: [KeyType]) throws -> Any {
        var content = self.content

        for key in keys {
            switch key.key {
            case let .index(index):
                guard let array = content as? [Any] else {
                    throw MapperError.typeMismatch(type(of: content))
                }

                guard index < array.count else {
                    throw MapperError.notFound(key)
                }

                content = array[index]

            case let .key(key):
                guard let dictionary = content as? [String: Any] else {
                    throw MapperError.typeMismatch(type(of: content))
                }

                guard let obj = dictionary[key] else {
                    throw MapperError.notFound(key)
                }

                content = obj
            }
        }
        
        return content
    }
}

extension Mapper {
    public func get<T: Mappable>(_ keys: KeyType...) throws -> T {
        return try T(json: try T.cast(from: try parse(for: keys)))
    }
    
    public func get<T: Mappable>(_ keys: KeyType...) -> T? {
        return try? T(json: try T.cast(from: try parse(for: keys)))
    }
    
    public func get<T: Mappable>(_ keys: KeyType...) throws -> [T] {
        let value = try parse(for: keys)
        guard let arr = value as? [Any] else {
            throw MapperError.typeMismatch(type(of: value))
        }
        
        return try arr.map {
            try T(json: try T.cast(from: $0))
        }
    }
}

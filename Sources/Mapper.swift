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
    
    func parseFor(keys: [KeyType]) throws -> Any {
        return try keys.reduce(content) { (content: Any, keyType: KeyType) throws -> Any in
            switch keyType.key {
            case .index(let index):
                guard let array = content as? [Any] else {
                    throw MapperError.typeMismatch(type(of: content))
                }
                
                guard index < array.count else {
                    throw MapperError.notFound(keyType)
                }
                
                return array[index]
                
            case .key(let key):
                guard let dictionary = content as? [String: Any] else {
                    throw MapperError.typeMismatch(type(of: content))
                }
                
                guard let obj = dictionary[key] else {
                    throw MapperError.notFound(keyType)
                }
                
                return obj
            }
        }
    }
}

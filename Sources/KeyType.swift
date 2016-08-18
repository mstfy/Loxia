//
//  KeyType.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

public enum Key {
    case key(String)
    case index(Int)
}

public protocol KeyType {
    var key: Key { get }
}

extension String: KeyType {
    public var key: Key {
        return .key(self)
    }
}

extension Int: KeyType {
    public var key: Key {
        return .index(self)
    }
}

//
//  MapperError.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

public enum MapperError: Error {
    case typeMismatch(Any.Type)
    case notFound(KeyType)
}

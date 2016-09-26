//
//  MapperTests.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 18.08.2016.
//
//

import XCTest
@testable import Loxia

struct User: Equatable {
    let name: String
    let surname: String?
    let age: Int
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name &&
            lhs.surname == rhs.surname &&
            lhs.age == rhs.age
    }
}

extension User: MappableObject {
    init(json: Mapper) throws {
        name = try json.get("name")
        surname = json.get("surname")
        age = try json.get("age")
    }
}

class MapperTests: XCTestCase {
    func test_ItCanMapPrimitive() throws {
        let json = ["name": "john"]
        let mapper = Mapper(json)
        let name: String = try mapper.get("name")
        XCTAssertEqual(name, "john")
    }
    
    func test_ItCanMapOptionalPrimitive() {
        let json = ["name": "john"]
        let mapper = Mapper(json)
        let name: String? = mapper.get("name")
        XCTAssertEqual(name, "john")
        
        let surname: String? = mapper.get("surname")
        XCTAssertEqual(surname, nil)
    }
    
    func test_ItCanMapNestedPrimitive() throws {
        let json = ["users": [["name": "john"]]]
        let mapper = Mapper(json)
        let name: String = try mapper.get("users", 0, "name")
        XCTAssertEqual(name, "john")
    }
    
    func test_ItCanMapArrayOfPrimitives() throws {
        let json = ["names": ["john", "jack", "jill"]]
        let mapper = Mapper(json)
        let names: [String] = try mapper.get("names")
        XCTAssertEqual(names, ["john", "jack", "jill"])
    }
    
    func test_ItCanMapObject() throws {
        let json: [String: Any] = ["name": "john", "age": 21]
        let mapper = Mapper(json)
        let user: User = try mapper.get()
        let expectedUser = User(name: "john", surname: nil, age: 21)
        XCTAssertEqual(user, expectedUser)
    }
    
    func test_ItCanMapNestedObject() throws {
        let json: [String: Any] = ["users": [["name": "john", "age": 21]]]
        let mapper = Mapper(json)
        let user: User = try mapper.get("users", 0)
        let expectedUser = User(name: "john", surname: nil, age: 21)
        XCTAssertEqual(user, expectedUser)
    }
    
    func test_ItCanMapArrayOfUsers() throws {
        let json: [String: Any] = ["users": [
            ["name": "john", "age": 21],
            ["name": "jack", "surname": "shepherd", "age": 34]
        ]]
        let mapper = Mapper(json)
        let users: [User] = try mapper.get("users")
        let expectedUsers = [
            User(name: "john", surname: nil, age: 21),
            User(name: "jack", surname: "shepherd", age: 34)
        ]
        XCTAssertEqual(users, expectedUsers)
    }
}

## Features :sparkles:
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage) 
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

* Mapping JSON to objects
* Nested objects
* Custom types

## Getting Started

Loxia requires swift 3 (xcode 8 beta 6)

### Installation with Carthage

```
github "mstfy/Loxia"
```

### Installation with Swift Package Manager

To use Loxia as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
import PackageDescription

let package = Package(
    name: "HelloWorld",
    dependencies: [
        .Package(url: "https://github.com/mstfy/Loxia.git", majorVersion: 0)
    ]
)
```

## Usage

Let's assume we have following JSON:

``` JSON
{
    "users": [
        {
            "name": "Jack",
            "age": 21,
            "profilePhoto": "<some url>",
            "type": "Standard"
        },
        {
            "name": "John",
            "age": 25,
            "profilePhoto": null,
            "type": "Admin"
        }
    ]
}
```

### Creating a Mapper

Loxia uses `Mapper` type for json mapping. You can create `Mapper` in two ways. First you can create it with `Data` instance that contains json string

``` swift
let mapper = Mapper.from(data: jsonData)
```

The second way is to create it with one of the json types (`String`, `Int`, `Double`, `Float`, `Bool`, `Dictionary` and `Array`).
``` swift
let mapper = Mapper(json)
```

### Simple parsing

``` swift
let mapper = Mapper(json)
let firstUsersName: String = try mapper.get("users", 0, "name")
let firstUsersProfilePhoto: String? = mapper.get("users", 0, "profilePhoto")
```

So what's going on here?. Here is we call `Mapper`'s `get` method. There is bunch of `get` methods implemented in `Mapper`. Swift chooses right versions according to type that we are getting from json. This is called type inference. 

### Parsing objects

For the json written above let's assume we want to map it to following type:

``` swift
struct User {
    let name: String
    let age: Int
    let profilePhoto: URL?
    let type: String
}
```

Now we want to get array of `User` instances. To parse `User` at once `User` must be conform the `JSONType` protocol.

``` swift
import Loxia

extension User: JSONObjectType {
    init(json: Mapper) throws {
        name = try json.get("name")
        age = try json.get("age")
        profilePhoto = json.get("profilePhoto")
        type = try json.get("type")
    }
}
```

Now we can write the parsing code:

``` swift
let mapper = Mapper(json)
let users: [User] = try mapper.get("users")
```

### Parsing custom types

Let's write the more swifty version of our `User` type. This time we will store `type` as enum.

``` swift

enum UserType: {
    case standard, admin
}

struct User {
    let name: String
    let age: Int
    let profilePhoto: URL?
    let type: UserType
}
```

To convert json string to `UserType` It needs to conform `JSONType` protocol.

``` swift
extension UserType: JSONType {
    public init(json: String) throws {
        switch json {
            case "standard": self = .standard
            case "admin": self = .admin
            default: throw MapperError.typeMismatch(type(of: json))
        }
    }

    public static func cast(from: Any) throws -> String {
        guard let value = from as? String else {
            throw MapperError.typeMismatch(type(of: from))
        }
        
        return value
    }
}
```

Now we don't need to change `User`'s parsing code at all. Swift will call the right methods for us. 

### Supported Types

Loxia supports decoding all standard JSON types, like:

- `Bool`
- `Int`, `Double`, `Float`
- `String`
- `Array`
- `Dictionary`

It also supprts `URL` out of the box. For the `Date` you have to write it yourself. A sample implementation would look like this:

``` swift
extension Date: JSONType {
    public init(json: String) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/mm/dd"
        guard let date = formatter.date(from: json) else {
            throw MapperError.typeMismatch(type(of: json))
        }
        
        self = date
    }
    
    public static func cast(from: Any) throws -> String {
        guard let value = from as? String else {
            throw MapperError.typeMismatch(type(of: from))
        }
        
        return value
    }
}
```

### Debugging

If you want to get raw json string from `Mapper` you can use get only property `json`. And then you can log it to the console.

``` swift
let mapper = Mapper(json)
print(mapper.json)
```

If you get `Ambigious reference to member 'get'` then It means your type doesn't conform required `JSONType` or `JSONObjectType` protocol. Or swift's type inference can't infere which `get` method to call.




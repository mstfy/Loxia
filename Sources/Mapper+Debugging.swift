//
//  Mapper+Debugging.swift
//  Loxia
//
//  Created by Mustafa Yusuf on 22.08.2016.
//
//

import Foundation

extension Mapper {
    public var json: String {
        let jsonData = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
        return jsonData.flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
}

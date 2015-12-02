//
//  Utils.swift
//  Events
//
//  Created by Adam Venturella on 11/30/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

func uniqueId() -> String {
    return NSUUID().UUIDString
}


public func ==(lhs: UUID, rhs: UUID) -> Bool{
    return lhs.bytes == rhs.bytes
}

public struct UUID: Hashable, CustomStringConvertible{
    let bytes: [UInt8]

    public init(){
        let size = sizeof(uuid_t)
        var buffer = [UInt8].init(count: size, repeatedValue: 0x0)
        uuid_generate(&buffer)
        bytes = buffer
    }

    public var hashValue: Int{
        return hex.hashValue
    }

    public var hex: String{
        return bytes.map{
            return String(format:"%02x", $0)
            }
            .joinWithSeparator("")
    }

    public var description: String{
        let size = sizeof(uuid_string_t)
        let buffer = UnsafeMutablePointer<CChar>.alloc(size)
        let string: String

        uuid_unparse_lower(bytes, buffer)
        string = String.fromCString(buffer)!
        buffer.dealloc(size)

        return string
    }
    
}

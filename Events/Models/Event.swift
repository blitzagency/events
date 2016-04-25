//
//  Event.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

public struct Event{
    public let name: String
    public let publisher: Any
    public let data: Any?

    public init(name: String, publisher: Any, data: Any? = nil){
        self.name = name
        self.publisher = publisher
        self.data = data
    }
}

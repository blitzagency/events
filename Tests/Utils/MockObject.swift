//
//  MockHost.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation
import Events

func ==(lhs: MockObject, rhs: MockObject) -> Bool{
    return lhs.id == rhs.id
}

class MockObject: EventManagerHost, Equatable{
    let id = NSUUID().UUIDString
    let eventManager = EventManager()
}
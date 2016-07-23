//
//  Operators.swift
//  Events
//
//  Created by Adam Venturella on 7/17/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public func ==(lhs: EventManager, rhs: EventManager) -> Bool{
    return lhs.listenId == rhs.listenId
}

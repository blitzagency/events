//
//  Handler.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation


public struct Handler{
    let publisher: EventManager
    let subscriber: EventManager
    let listener: Listener
    let callback: (Event) -> ()
}

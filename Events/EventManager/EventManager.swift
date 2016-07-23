//
//  EventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public class EventManager: EventManagerBase {

    public func trigger(_ name: String){
        let event = buildEvent(name, publisher: self)
        trigger(event)
    }

    public func trigger<Data>(_ name: String, data: Data){
        let event = buildEvent(name, publisher: self, data: data)
        trigger(event)
    }

}

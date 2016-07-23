//
//  TypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public protocol TypedEventManageable: EventManageable{
    associatedtype EventType: RawRepresentable
}


public class TypedEventManager<Event: RawRepresentable>: EventManagerBase, TypedEventManageable{

    public typealias EventType = Event

    public func trigger(_ name: Event){
        guard let value = name.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value)
    }

    public func trigger<Data>(_ name: Event, data: Data){
        guard let value = name.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value, data: data)
    }

    func trigger(_ name: String){
        let event = buildEvent(name, publisher: self)
        trigger(event)
    }

    func trigger<Data>(_ name: String, data: Data){
        let event = buildEvent(name, publisher: self, data: data)
        trigger(event)
    }

}





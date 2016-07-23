//
//  TypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/18/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public protocol StringEvent: RawRepresentable {
    associatedtype RawValue = String
    init?(rawValue: String)
    var rawValue: String { get }
}


public class TypedEventManager<EventType: StringEvent>: EventManager {
    public typealias Event = EventType

    public func listenTo<Publisher: TypedEventManager where EventType == Publisher.Event>(publisher: Publisher, event: EventType, callback:() -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: TypedEventManager where EventType == Publisher.Event>(publisher: Publisher, event: EventType, callback:(Publisher) -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: TypedEventManager, Data where EventType == Publisher.Event>(publisher: Publisher, event: EventType, callback:(Publisher, Data) -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func trigger(name: EventType){
        let event = buildEvent(name.rawValue, publisher: self)
        trigger(event)

    }

    public func trigger<Data>(name: EventType, data: Data){
        let event = buildEvent(name.rawValue, publisher: self, data: data)
        trigger(event)
    }

}

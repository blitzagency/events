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

    public func trigger(_ event: Event){
        guard let value = event.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value)
    }

    public func trigger<Data>(_ event: Event, data: Data){
        guard let value = event.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value, data: data)
    }

    func trigger(_ event: String){
        let event = buildEvent(event, publisher: self)
        trigger(event)
    }

    func trigger<Data>(_ event: String, data: Data){
        let event = buildEvent(event, publisher: self, data: data)
        trigger(event)
    }

    /**
     Stop listening to events triggered by the specified publisher

     - Parameter publisher: The TypedEventManager<T> we would like to stop listening to.
     - Parameter event: An optional `String RawRepresentable` of type `T` event to limit our removal scope

     - Remark:
     If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Event: RawRepresentable, Publisher: TypedEventManager<Event>>(_ publisher: Publisher, event: Event?)
        where Event.RawValue == String {
            
        stopListening(publisher, event: event?.rawValue)
    }

}





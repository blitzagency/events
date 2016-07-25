//
//  TypedEventManagerHost.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public protocol TypedEventManagerHost {
    associatedtype EventType: RawRepresentable
    var eventManager: TypedEventManager<EventType> {get}
}

extension TypedEventManagerHost{

    public func trigger(_ event: EventType){
        guard let value = event.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value)
    }

    public func trigger<Data>(_ event: EventType, data: Data){
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

     - Parameter publisher: The TypedEventManagerHost we would like to stop listening to.
     - Parameter event: An optional `String RawRepresentable` of type `T` event to limit our removal scope

     - Remark:
     If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Event: RawRepresentable, Publisher: TypedEventManagerHost where Event == Publisher.EventType, Event.RawValue == String>(_ publisher: Publisher, event: Event?){
        eventManager.stopListening(publisher.eventManager, event: event?.rawValue)
    }

    /**
     Stop listening to events triggered by the specified publisher

     - Parameter publisher: The TypedEventManageable we would like to stop listening to.
     - Parameter event: An optional `String RawRepresentable` of type `T` event to limit our removal scope

     - Remark:
     If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Event: RawRepresentable, Publisher: TypedEventManageable where Event == Publisher.EventType, Event.RawValue == String>(_ publisher: Publisher, event: Event?){
        eventManager.stopListening(publisher, event: event?.rawValue)
    }

    public func stopListening(){
        eventManager.stopListening()
    }

    public func stopListening<Publisher: TypedEventManageable>(_ publisher: Publisher){
        eventManager.stopListening(publisher)
    }

    public func stopListening<Publisher: TypedEventManagerHost>(_ publisher: Publisher){
        eventManager.stopListening(publisher.eventManager)
    }
}


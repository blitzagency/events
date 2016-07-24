//
//  EventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public class EventManager: EventManagerBase {

    /**
     Trigger an event

     - Parameter event: The String RawRepresentable event to trigger

     ```
     enum Lucy: String{
        case Woo, ChaseSquirrels
     }

     myEventManager.trigger(Lucy.ChaseSquirrels)
     ```
    */
    public func trigger<Event: RawRepresentable where Event.RawValue == String>(_ event: Event){
        let event = buildEvent(event.rawValue, publisher: self)
        trigger(event)
    }

    /**
     Trigger an event with an additional payload

     - Parameter event: The String RawRepresentable event to trigger
     - Parameter data: The data you would like to send with the event

     ```
     enum Lucy: String{
        case Woo, ChaseSquirrels
     }

     myEventManager.trigger(Lucy.ChaseSquirrels, data: <any>)
     ```
    */
    public func trigger<Data, Event: RawRepresentable where Event.RawValue == String>(_ event: Event, data: Data){
        let event = buildEvent(event.rawValue, publisher: self, data: data)
        trigger(event)
    }

    /**
     Trigger an event

     - Parameter event: The string event to trigger

     ```
     myEventManager.trigger("lucy")
     ```
    */
    public func trigger(_ event: String){
        let event = buildEvent(event, publisher: self)
        trigger(event)
    }

    /**
    Trigger an event with an additional payload

     - Parameter event: The string event to trigger
     - Parameter data: The data you would like to send with the event

     ```
     myEventManager.trigger("lucy", data: <any>)
     ```
     */
    public func trigger<Data>(_ event: String, data: Data){
        let event = buildEvent(event, publisher: self, data: data)
        trigger(event)
    }

    /**
    Stop listening to events triggered by the specified publisher

    - Parameter publisher: The EventManageable we would like to stop listening to.
    - Parameter event: An optional `String RawRepresentable` event to limit our removal scope

    - Remark:
        If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Publisher: EventManager, Event: RawRepresentable where Event.RawValue == String>(_ publisher: Publisher, event: Event?){
        stopListening(publisher, event: event?.rawValue)
    }

}

//
//  EventManagerHost.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public protocol EventManagerHost{
    var eventManager: EventManager {get}
}


extension EventManagerHost{

    public func trigger<Event: RawRepresentable where Event.RawValue == String>(_ event: Event){
        let event = buildEvent(event.rawValue, publisher: self)
        trigger(event)
    }

    public func trigger<Data, Event: RawRepresentable where Event.RawValue == String>(_ event: Event, data: Data){
        let event = buildEvent(event.rawValue, publisher: self, data: data)
        trigger(event)
    }

    public func trigger(_ event: String){
        let event = buildEvent(event, publisher: self)
        trigger(event)
    }

    public func trigger<Data>(_ event: String, data: Data){
        let event = buildEvent(event, publisher: self, data: data)
        trigger(event)
    }

    public func stopListening(){
        eventManager.stopListening()
    }

    public func stopListening<Publisher: EventManager, Event: RawRepresentable where Event.RawValue == String>(_ publisher: Publisher, event: Event?){
        eventManager.stopListening(publisher, event: event?.rawValue)
    }

    public func stopListening<Publisher: EventManager>(_ publisher: Publisher, event: String? = nil){
        eventManager.stopListening(publisher, event: event)
    }

    public func stopListening<Publisher: EventManagerHost>(_ publisher: Publisher, event: String? = nil){
        eventManager.stopListening(publisher.eventManager, event: event)
    }
}

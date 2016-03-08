//
//  EventManagerHost.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

public protocol EventManagerHost{
    var eventManager: EventManager {get}
}

extension EventManagerHost {

    public func listenTo(name: String, callback: () -> ()) -> Self{
        eventManager.listenTo(self.eventManager, name: name, callback: callback)
        return self
    }

    public func listenTo(name: String, callback: (Self) -> ()) -> Self{
        eventManager.listenTo(self.eventManager, name: name, callback: callback)
        return self
    }

    public func listenTo<Data>(name: String, callback: (Self, Data) -> ()) -> Self{
        eventManager.listenTo(self.eventManager, name: name, callback: callback)
        return self
    }


    // ---- String Enums

    public func listenTo<Publisher, EventType where Publisher: EventManagerHost, EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType, callback: () -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name.rawValue, callback: callback)
        return self
    }

    public func listenTo<Publisher, EventType where Publisher: EventManagerHost, EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType, callback: (Publisher) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name.rawValue, callback: callback)
        return self
    }

    public func listenTo<Publisher, Data, EventType where Publisher: EventManagerHost,EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType, callback: (Publisher, Data) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name.rawValue, callback: callback)
        return self
    }

    // ----

    public func listenTo<Publisher where Publisher: EventManagerHost>(publisher: Publisher, _ name: String, callback: () -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name, callback: callback)
        return self
    }

    public func listenTo<Publisher where Publisher: EventManagerHost>(publisher: Publisher, _ name: String, callback: (Publisher) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name, callback: callback)
        return self
    }

    public func listenTo<Publisher, Data where Publisher: EventManagerHost>(publisher: Publisher, _ name: String, callback: (Publisher, Data) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name, callback: callback)
        return self
    }


    // ---

    public func listenTo<Publisher where Publisher: EventManager>(publisher: Publisher, _ name: String, callback: () -> ()) -> Self{
        eventManager.listenTo(publisher, name: name, callback: callback)
        return self
    }

    public func listenTo<Publisher where Publisher: EventManager>(publisher: Publisher, _ name: String, callback: (Publisher) -> ()) -> Self{
        eventManager.listenTo(publisher, name: name, callback: callback)
        return self
    }

    public func listenTo<Publisher, Data where Publisher: EventManager>(publisher: Publisher, _ name: String, callback: (Publisher, Data) -> ()) -> Self{
        eventManager.listenTo(publisher, name: name, callback: callback)
        return self
    }


    // ---

    public func trigger(name: String, data: Any? = nil){
        let event = Event(name: name, publisher: self, data: data)
        eventManager.trigger(event)
    }

    public func trigger<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, data: Any? = nil){
        let event = Event(name: name.rawValue, publisher: self, data: data)
        eventManager.trigger(event)
    }

    public func stopListening(name: String) -> Self{
        eventManager.stopListening(self.eventManager, name: name)
        return self
    }

    public func stopListening<Publisher where Publisher: EventManagerHost>(publisher: Publisher, _ name: String) -> Self{
        eventManager.stopListening(publisher.eventManager, name: name)
        return self
    }

    public func stopListening<Publisher where Publisher: EventManagerHost>(publisher: Publisher) -> Self{
        eventManager.stopListening(publisher.eventManager)
        return self
    }

    public func stopListening() -> Self{
        eventManager.stopListening()
        return self
    }

    // --- String Enums

    public func stopListening<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType) -> Self{
        eventManager.stopListening(self.eventManager, name: name.rawValue)
        return self
    }

    public func stopListening<Publisher, EventType where Publisher: EventManagerHost, EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType) -> Self{
        eventManager.stopListening(publisher.eventManager, name: name.rawValue)
        return self
    }
}
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

    /// Convenience for listening to self
    ///
    /// ```
    /// listenTo("foo"){
    ///     ...
    /// }
    /// ```
    /// Assumes the Sender is self. 
    /// 
    /// Note that a Publisher is not required for the first argument
    public func listenTo(name: String, queue: dispatch_queue_t? = nil, callback: () -> ()) -> Self{
        eventManager.listenTo(self.eventManager, name: name, queue: queue, callback: callback)
        return self
    }

    /// Convenience for listening to self
    ///
    /// ```
    /// listenTo("foo"){ publisher: Self in
    ///     ...
    /// }
    /// ```
    /// Assumes the Sender is self. 
    /// 
    /// Note that a Publisher is not required for the first argument
    public func listenTo(name: String, queue: dispatch_queue_t? = nil, callback: (Self) -> ()) -> Self{
        eventManager.listenTo(self.eventManager, name: name, queue: queue, callback: callback)
        return self
    }

    /// Convenience for listening to self
    ///
    /// ```
    /// listenTo("foo"){ (publisher: Self, data: SomeType) in
    ///     ...
    /// }
    /// ```
    /// Assumes the Sender is self. 
    ///
    /// Note that a Publisher is not required for the first argument
    public func listenTo<Data>(name: String, queue: dispatch_queue_t? = nil, callback: (Self, Data) -> ()) -> Self{
        eventManager.listenTo(self.eventManager, name: name, queue: queue, callback: callback)
        return self
    }


    /// Listen to a Publisher using a String RawRepresentable Enum
    /// as the EventType where Publisher is an `EventManagerHost`
    ///
    /// ```
    /// listenTo(publisher, Action.Foo){
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher, EventType where Publisher: EventManagerHost, EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType, queue: dispatch_queue_t? = nil, callback: () -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name.rawValue, queue: queue, callback: callback)
        return self
    }

    /// Listen to a Publisher using a String RawRepresentable Enum
    /// as the EventType where Publisher is an `EventManagerHost`
    ///
    /// ```
    /// listenTo(publisher, Action.Foo){ publisher: SomeType in
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher, EventType where Publisher: EventManagerHost, EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType, queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name.rawValue, queue: queue, callback: callback)
        return self
    }

    /// Listen to a Publisher using a String RawRepresentable Enum
    /// as the EventType where Publisher is an `EventManagerHost`
    ///
    /// ```
    /// listenTo(publisher, Action.Foo){ (publisher: SomeType, data: SomeType) in
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher, Data, EventType where Publisher: EventManagerHost,EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType, queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name.rawValue, queue: queue, callback: callback)
        return self
    }


    /// Listen to a Publisher where Publisher is an `EventManagerHost`
    ///
    /// ```
    /// listenTo(publisher){
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher where Publisher: EventManagerHost>(publisher: Publisher, _ name: String, queue: dispatch_queue_t? = nil, callback: () -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name, queue: queue, callback: callback)
        return self
    }

    /// Listen to a Publisher using a String as the EventType where Publisher 
    /// is an `EventManagerHost`
    ///
    /// ```
    /// listenTo(publisher, "foo"){ publisher: SomeType in
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher where Publisher: EventManagerHost>(publisher: Publisher, _ name: String, queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name, queue: queue, callback: callback)
        return self
    }

    /// Listen to a Publisher using a String as the EventType where Publisher 
    /// is an `EventManagerHost`
    ///
    /// ```
    /// listenTo(publisher, "foo"){ (publisher: SomeType, data: SomeType) in
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher, Data where Publisher: EventManagerHost>(publisher: Publisher, _ name: String, queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> Self{
        eventManager.listenTo(publisher.eventManager, name: name, queue: queue, callback: callback)
        return self
    }


    /// Listen to a Publisher where Publisher is an `EventManager`
    ///
    /// ```
    /// listenTo(publisher){
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher where Publisher: EventManager>(publisher: Publisher, _ name: String, queue: dispatch_queue_t? = nil, callback: () -> ()) -> Self{
        eventManager.listenTo(publisher, name: name, queue: queue, callback: callback)
        return self
    }

    /// Listen to a Publisher using a String as the EventType where Publisher
    /// is an `EventManager`
    ///
    /// ```
    /// listenTo(publisher, "foo"){ publisher: SomeType in
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher where Publisher: EventManager>(publisher: Publisher, _ name: String, queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> Self{
        eventManager.listenTo(publisher, name: name, queue: queue, callback: callback)
        return self
    }

    /// Listen to a Publisher using a String as the EventType where Publisher
    /// is an `EventManager`
    ///
    /// ```
    /// listenTo(publisher, "foo"){ (publisher: SomeType, data: SomeType) in
    ///     ...
    /// }
    /// ```
    public func listenTo<Publisher, Data where Publisher: EventManager>(publisher: Publisher, _ name: String, queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> Self{
        eventManager.listenTo(publisher, name: name, queue: queue, callback: callback)
        return self
    }



    /// Trigger an event using a String as the EventType
    /// 
    /// ```
    /// trigger("foo")
    /// // or 
    /// trigger("foo", data: something)
    /// ```
    ///
    public func trigger(name: String, data: Any? = nil){
        let event = Event(name: name, publisher: self, data: data)
        trigger(event)
    }

    /// Trigger an event using RawRepresentable String Enum as the EventType
    ///
    /// ```
    /// trigger(Action.Foo)
    /// // or
    /// trigger(Action.Foo, data: something)
    /// ```
    ///
    public func trigger<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, data: Any? = nil){
        let event = Event(name: name.rawValue, publisher: self, data: data)
        trigger(event)
    }

    /// Trigger an event using an Event object
    /// 
    /// The other 2 forms of trigger automatically
    /// construct the Event object for you and send
    /// it to this method
    ///
    ///
    /// ```
    /// trigger(myEvent)
    /// ```
    ///
    public func trigger(event: Event){
        eventManager.trigger(event)
    }

    /// Stop listening to events on `self` for `name`
    ///
    /// ```
    /// stopListening("foo")
    /// ```
    public func stopListening(name: String) -> Self{
        eventManager.stopListening(self.eventManager, name: name)
        return self
    }

    /// Stop listening to events on `publisher` for EventTypes with `name`
    /// where Publisher is an EventHostManager and EventType is a `String`
    ///
    /// ```
    /// stopListening(publisher, "foo")
    /// ```
    public func stopListening<Publisher where Publisher: EventManagerHost>(publisher: Publisher, _ name: String) -> Self{
        eventManager.stopListening(publisher.eventManager, name: name)
        return self
    }

    /// Stop listening to all events on a `publisher`
    /// where Publisher is an EventHostManager
    ///
    /// ```
    /// stopListening(publisher, "foo")
    /// ```
    public func stopListening<Publisher where Publisher: EventManagerHost>(publisher: Publisher) -> Self{
        eventManager.stopListening(publisher.eventManager)
        return self
    }

    /// Stop listening to all events on all publishers
    /// where Publisher is an EventHostManager
    ///
    /// ```
    /// stopListening()
    /// ```
    public func stopListening() -> Self{
        eventManager.stopListening()
        return self
    }

    /// Stop listening to events on `self` for EventTypes with `name`
    /// where EventType is a RawRepresentable String Enum
    ///
    /// ```
    /// stopListening(publisher, Action.Foo)
    /// ```
    public func stopListening<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType) -> Self{
        eventManager.stopListening(self.eventManager, name: name.rawValue)
        return self
    }

    /// Stop listening to events on `publisher` for EventTypes with `name`
    /// where `publisher` is an `EventManagerHost` EventType is a
    /// RawRepresentable String Enum
    ///
    /// ```
    /// stopListening(publisher, Action.Foo)
    /// ```
    public func stopListening<Publisher, EventType where Publisher: EventManagerHost, EventType: RawRepresentable, EventType.RawValue == String>(publisher: Publisher, _ name: EventType) -> Self{
        eventManager.stopListening(publisher.eventManager, name: name.rawValue)
        return self
    }
}
//
//  EventManager.swift
//  Events
//
//  Created by Adam Venturella on 11/29/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation





//public protocol StringEventManageable: EventManageable{
////    func listenTo<Publisher: StringEventManager, Event: RawRepresentable where Event.RawValue == String>(publisher: Publisher, event: Event, callback:() -> ())
////    func listenTo<Publisher: StringEventManager, Event: RawRepresentable where Event.RawValue == String>(publisher: Publisher, event: Event, callback:(Publisher) -> ())
////    func listenTo<Publisher: StringEventManager, Data, Event: RawRepresentable where Event.RawValue == String>(publisher: Publisher, event: Event, callback:(Publisher, Data) -> ())
////
//    func listenTo<Publisher: EventManager>(publisher: Publisher, event: String, callback:() -> ())
////    func listenTo<Publisher: StringEventManager>(publisher: Publisher, event: String, callback:(Publisher) -> ())
////    func listenTo<Publisher: StringEventManager, Data>(publisher: Publisher, event: String, callback:(Publisher, Data) -> ())
//
//    func trigger(name: String)
//    func trigger<Data>(name: String, data: Data)
//    
//}



public protocol StringEvent: RawRepresentable {
    associatedtype RawValue = String
    init?(rawValue: String)
    var rawValue: String { get }
}

enum Manager1: String{
    case Foo
}

enum Manager2: String{
    case Bar
}

func test(){
    let manager1 = TypedEventManager<Manager1>()
    let manager2 = TypedEventManager<Manager2>()

    manager2.listenTo(manager1, event: .Foo){}
}

public class TypedEventManager<EventType>: EventManagerBase{
//    public typealias Event = EventType

    public func listenTo<Event, Publisher: TypedEventManager<Event>>(publisher: Publisher, event: Event, callback:() -> ()){
        //listenTo(publisher, event: event.rawValue, callback: callback)
    }
    
}

public class EventManager1: EventManagerBase {

//    public let listenId = uniqueId()
//    public var listeningTo: [String: Listener] = [:]
//    public var events = [String: [HandlerBase]]()
//    public var listeners = [String: Listener]()
//    public let lockingQueue = dispatch_queue_create("com.events.manager.queue.\(uniqueId)", DISPATCH_QUEUE_SERIAL)


//    public init() {}

    public func listenTo<Publisher: EventManager>(publisher: Publisher, event: String, callback:() -> ()){

    }


    public func trigger(name: String){
        //let event = buildEvent(name, publisher: self)
        //trigger(event)

    }

    public func trigger<Data>(name: String, data: Data){
        //let event = buildEvent(name, publisher: self, data: data)
        //trigger(event)
    }



    /// Get the list of event handler for this publisher for the provided event type.
    func publisherEventHandlers<Publisher: EventManager>(publisher: Publisher, event: String) -> [HandlerBase]{
        
        guard let handlers = publisher.events[event] else {
            let newHandlers = [HandlerBase]()

            dispatch_sync(publisher.lockingQueue){
                publisher.events[event] = newHandlers
            }

            return newHandlers
        }

        return handlers;
    }

    /// Get the `Listener` for the provided Publisher
    func publisherListener<Publisher: EventManagerBase>(publisher: Publisher) -> Listener{

        guard let listener = listeningTo[publisher.listenId] else {
            // If no Listener exisis, we create a new one assing ourselves
            // as the subscriber for this Listener
            let listener = Listener(publisher: publisher, subscriber: self)

            // now, add this listener to our list of things
            // we are listening to.
            listeningTo[publisher.listenId] = listener
            return listener
        }

        return listener

    }

    /// Stop listening to events triggered by the specified publisher
    public func stopListening<Publisher: EventManager>(publisher: Publisher){
        guard let listener = listeningTo[publisher.listenId] else {
            return
        }

        // we need the events names and handlers
        // for every event this publisher might have
        // as we need to check if we are a part of
        // any of them and remove ourselves

        dispatch_sync(publisher.lockingQueue){
            var events = [String: [HandlerBase]]()

            publisher.events.forEach{
                key, handlers in

                var activeHandlers = [HandlerBase]()

                handlers.forEach{
                    handler in

                    if handler.listener !== listener{
                        activeHandlers.append(handler)
                        return
                    }

                    let candidate = handler.listener
                    candidate.count = candidate.count - 1

                    if candidate.count == 0{
                        // see: addHandler(...). The listeners is registered
                        // with listener.subscriberId
                        publisher.listeners.removeValueForKey(candidate.subscriberId)
                        self.listeningTo.removeValueForKey(publisher.listenId)
                    }
                }

                if activeHandlers.count > 0 {
                    events[key] = activeHandlers
                }
            }

            publisher.events = events
        }

    }
}

//public class EventManager:
//    public let listenId: String = uniqueId()
//    public var listeningTo: [String: Listener] = [:]
//    public var events = [String: [Handler]]()
//    public var listeners = [String: Listener]()
//
//    public init(){}
//
//    public func wrapCallback(queue: dispatch_queue_t? = nil, callback: () -> ()) -> (Event) -> (){
//        let queue = (queue != nil) ? queue! : dispatch_get_main_queue()
//
//        return { evt in
//            dispatch_async(queue){
//                callback()
//            }
//        }
//    }
//
//    public func wrapCallback<Publisher>(queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> (Event) -> (){
//        let queue = (queue != nil) ? queue! : dispatch_get_main_queue()
//
//        return { evt in
//            let publisher = evt.publisher as! Publisher
//
//            dispatch_async(queue){
//                callback(publisher)
//            }
//        }
//    }
//
//    public func wrapCallback<Publisher, Data>(queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> (Event) -> (){
//        let queue = (queue != nil) ? queue! : dispatch_get_main_queue()
//
//        return { [unowned self] evt in
//            let publisher = evt.publisher as! Publisher
//            if let number = evt.data as? NSNumber{
//                let data: Data = self.convert(number)
//                dispatch_async(queue){
//                    callback(publisher, data)
//                }
//            } else{
//                let data = evt.data as! Data
//                dispatch_async(queue){
//                    callback(publisher, data)
//                }
//            }
//        }
//    }
//
//    public func getOrCreateListenerFor<Publisher where Publisher: EventManager>(publisher: Publisher) -> Listener{
//        let listener: Listener
//
//        if let target = listeningTo[publisher.listenId]{
//            listener = target
//        } else {
//            listener = Listener(publisher: publisher, subscriber: self, listeningTo: listeningTo)
//            listeningTo[publisher.listenId] = listener
//        }
//
//        return listener
//    }
//
//    public func listenTo(publisher: EventManager, name: String, queue: dispatch_queue_t? = nil, callback: () -> ()) -> Self{
//        let listener = getOrCreateListenerFor(publisher)
//        let wrappedCallback = wrapCallback(queue, callback: callback)
//
//        internalOn(publisher, name: name, callback: wrappedCallback, listener: listener)
//        return self
//    }
//
//    public func listenTo<Publisher>(publisher: EventManager, name: String, queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> Self{
//        let listener = getOrCreateListenerFor(publisher)
//        let wrappedCallback = wrapCallback(queue, callback: callback)
//
//        internalOn(publisher, name: name, callback: wrappedCallback, listener: listener)
//        return self
//    }
//
//    public func listenTo<Publisher, Data>(publisher: EventManager, name: String, queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> Self{
//        let listener = getOrCreateListenerFor(publisher)
//        let wrappedCallback = wrapCallback(queue, callback: callback)
//
//        internalOn(publisher, name: name, callback: wrappedCallback, listener: listener)
//        return self
//    }
//
//
//    public func internalOn(publisher: EventManager, name: String, callback: (Event) -> (), listener: Listener) {
//
//        var events = publisher.events
//        var handlers = events[name] ?? []
//
//        listener.count = listener.count + 1
//
//        let handler = Handler(
//            publisher: listener.publisher,
//            subscriber: listener.subscriber,
//            listener: listener,
//            callback: callback
//        )
//
//        handlers.append(handler)
//        publisher.events[name] = handlers
//        publisher.listeners[listener.subscriberId] = listener
//
//    }
//
//    public func trigger(event: Event){
//
//        // aka setdefault
//        let handlers: [Handler] = events[event.name] ?? []
//        events[event.name] = handlers
//
//        dispatch_async(EventQueue){
//            handlers.forEach{
//                $0.callback(event)
//            }
//        }
//    }
//
//    public func trigger(name: String, data: Any? = nil){
//        let event = Event(name: name, publisher: self, data: data)
//        trigger(event)
//    }
//
//    public func stopListening(publisher: EventManager, name: String){
//
//        guard let listener = listeningTo[publisher.listenId] else {
//            return
//        }
//
//        let publisher = listener.publisher
//
//        publisher.listeners.removeValueForKey(listener.subscriberId)
//        publisher.events.removeValueForKey(name)
//        listeningTo.removeValueForKey(publisher.listenId)
//    }
//
//    public func stopListening(publisher: EventManager){
//        guard let listener = listeningTo[publisher.listenId] else {
//            return
//        }
//
//        var events = [String: [Handler]]()
//
//        publisher.events.forEach{ (key, handlers) -> () in
//            var remaining = [Handler]()
//
//            handlers.enumerate().forEach{ (index, handler) -> () in
//
//                if handler.listener !== listener{
//                    remaining.append(handler)
//                } else {
//                    let candidate = handler.listener
//
//                    candidate.count = candidate.count - 1
//
//                    if candidate.count == 0{
//                        publisher.listeners.removeValueForKey(candidate.subscriberId)
//                        listeningTo.removeValueForKey(publisher.listenId)
//                    }
//                }
//            }
//
//            if remaining.count > 0 {
//                events[key] = remaining
//            }
//
//        }
//
//        publisher.events = events
//    }
//
//    public func stopListening(){
//        listeningTo.forEach { (key, listener) -> () in
//            stopListening(listener.publisher)
//        }
//    }
//
//    public func convert<T>(value: NSNumber) -> T{
//
//        switch T.self{
//        case is Bool.Type:
//            return value.boolValue as! T
//        case is NSNumber.Type:
//            return value as! T
//        case is Double.Type:
//            return value.doubleValue as! T
//        case is Int.Type:
//            return value.integerValue as! T
//        case is Int32.Type:
//            return value.intValue as! T
//        case is UInt.Type:
//            return value.unsignedIntegerValue as! T
//        case is UInt64.Type:
//            return value.unsignedLongLongValue as! T
//        case is UInt32.Type:
//            return value.unsignedIntValue as! T
//        case is Float64.Type: fallthrough
//        case is Float32.Type: fallthrough
//        case is Float.Type:
//            return value.floatValue as! T
//        default:
//            return 0 as! T
//        }
//    }

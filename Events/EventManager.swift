//
//  EventManager.swift
//  Events
//
//  Created by Adam Venturella on 11/29/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation


private let EventQueue = dispatch_queue_create("com.events.dispatchQueue", DISPATCH_QUEUE_SERIAL)


public class EventManager{

    public let listenId: String = uniqueId()
    public var listeningTo: [String: Listener] = [:]
    public var events = [String: [Handler]]()
    public var listeners = [String: Listener]()

    public init(){}

    public func wrapCallback(queue: dispatch_queue_t? = nil, callback: () -> ()) -> (Event) -> (){
        let queue = (queue != nil) ? queue! : dispatch_get_main_queue()

        return { evt in
            dispatch_async(queue){
                callback()
            }
        }
    }

    public func wrapCallback<Publisher>(queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> (Event) -> (){
        let queue = (queue != nil) ? queue! : dispatch_get_main_queue()

        return { evt in
            let publisher = evt.publisher as! Publisher

            dispatch_async(queue){
                callback(publisher)
            }
        }
    }

    public func wrapCallback<Publisher, Data>(queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> (Event) -> (){
        let queue = (queue != nil) ? queue! : dispatch_get_main_queue()

        return { [unowned self] evt in
            let publisher = evt.publisher as! Publisher
            if let number = evt.data as? NSNumber{
                let data: Data = self.convert(number)
                dispatch_async(queue){
                    callback(publisher, data)
                }
            } else{
                let data = evt.data as! Data
                dispatch_async(queue){
                    callback(publisher, data)
                }
            }
        }
    }

    public func getOrCreateListenerFor<Publisher where Publisher: EventManager>(publisher: Publisher) -> Listener{
        let listener: Listener

        if let target = listeningTo[publisher.listenId]{
            listener = target
        } else {
            listener = Listener(publisher: publisher, subscriber: self, listeningTo: listeningTo)
            listeningTo[publisher.listenId] = listener
        }

        return listener
    }

    public func listenTo(publisher: EventManager, name: String, queue: dispatch_queue_t? = nil, callback: () -> ()) -> Self{
        let listener = getOrCreateListenerFor(publisher)
        let wrappedCallback = wrapCallback(queue, callback: callback)

        internalOn(publisher, name: name, callback: wrappedCallback, listener: listener)
        return self
    }

    public func listenTo<Publisher>(publisher: EventManager, name: String, queue: dispatch_queue_t? = nil, callback: (Publisher) -> ()) -> Self{
        let listener = getOrCreateListenerFor(publisher)
        let wrappedCallback = wrapCallback(queue, callback: callback)

        internalOn(publisher, name: name, callback: wrappedCallback, listener: listener)
        return self
    }

    public func listenTo<Publisher, Data>(publisher: EventManager, name: String, queue: dispatch_queue_t? = nil, callback: (Publisher, Data) -> ()) -> Self{
        let listener = getOrCreateListenerFor(publisher)
        let wrappedCallback = wrapCallback(queue, callback: callback)

        internalOn(publisher, name: name, callback: wrappedCallback, listener: listener)
        return self
    }


    public func internalOn(publisher: EventManager, name: String, callback: (Event) -> (), listener: Listener) {

        var events = publisher.events
        var handlers = events[name] ?? []

        listener.count = listener.count + 1

        let handler = Handler(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )

        handlers.append(handler)
        publisher.events[name] = handlers
        publisher.listeners[listener.subscriberId] = listener

    }

    public func trigger(event: Event){

        // aka setdefault
        let handlers: [Handler] = events[event.name] ?? []
        events[event.name] = handlers

        dispatch_async(EventQueue){
            handlers.forEach{
                $0.callback(event)
            }
        }
    }

    public func trigger(name: String, data: Any? = nil){
        let event = Event(name: name, publisher: self, data: data)
        trigger(event)
    }

    public func stopListening(publisher: EventManager, name: String){

        guard let listener = listeningTo[publisher.listenId] else {
            return
        }

        let publisher = listener.publisher

        publisher.listeners.removeValueForKey(listener.subscriberId)
        publisher.events.removeValueForKey(name)
        listeningTo.removeValueForKey(publisher.listenId)
    }

    public func stopListening(publisher: EventManager){
        guard let listener = listeningTo[publisher.listenId] else {
            return
        }

        var events = [String: [Handler]]()

        publisher.events.forEach{ (key, handlers) -> () in
            var remaining = [Handler]()

            handlers.enumerate().forEach{ (index, handler) -> () in

                if handler.listener !== listener{
                    remaining.append(handler)
                } else {
                    let candidate = handler.listener

                    candidate.count = candidate.count - 1

                    if candidate.count == 0{
                        publisher.listeners.removeValueForKey(candidate.subscriberId)
                        listeningTo.removeValueForKey(publisher.listenId)
                    }
                }
            }

            if remaining.count > 0 {
                events[key] = remaining
            }

        }

        publisher.events = events
    }

    public func stopListening(){
        listeningTo.forEach { (key, listener) -> () in
            stopListening(listener.publisher)
        }
    }

    public func convert<T>(value: NSNumber) -> T{

        switch T.self{
        case is Bool.Type:
            return value.boolValue as! T
        case is NSNumber.Type:
            return value as! T
        case is Double.Type:
            return value.doubleValue as! T
        case is Int.Type:
            return value.integerValue as! T
        case is Int32.Type:
            return value.intValue as! T
        case is UInt.Type:
            return value.unsignedIntegerValue as! T
        case is UInt64.Type:
            return value.unsignedLongLongValue as! T
        case is UInt32.Type:
            return value.unsignedIntValue as! T
        case is Float64.Type: fallthrough
        case is Float32.Type: fallthrough
        case is Float.Type:
            return value.floatValue as! T
        default:
            return 0 as! T
        }
    }
}
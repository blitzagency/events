//
//  EventManager+PublisherDataCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

extension EventManagerHost {

    public func listenTo<Publisher: EventManagerHost, Data, Event: RawRepresentable>(_ publisher: Publisher, event: Event, callback: @escaping (Publisher, Data) -> ())
        where Event.RawValue == String {

        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: EventManagerHost, Data>(_ publisher: Publisher, event: String, callback: @escaping (Publisher, Data) -> ()){

        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func wrapCallback<Publisher: EventManagerHost, Data>(_ callback: @escaping (Publisher, Data) -> ()) -> (EventPublisherData<Publisher, Data>) -> (){
        return { event in
            callback(event.publisher, event.data)
        }
    }

    func internalOn<Publisher: EventManagerHost, Data>(_ publisher: Publisher, event: String, callback: @escaping (EventPublisherData<Publisher, Data>) -> ()){

        let listener = eventManager.publisherListener(publisher.eventManager)

        let handler = HandlerPublisherData<Publisher, Data>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )

        eventManager.addHandler(publisher.eventManager, handler: handler, listener: listener, event: event)
    }

    internal func trigger<Publisher: EventManagerHost, Data>(_ event: EventPublisherData<Publisher, Data>){

        // when we trigger an event, we use buildEvent() which set's the publisher to
        // ourself on the EventPublisher<Publisher> model.
        // so event.publisher == self
        let handlers = eventManager.publisherEventHandlers(event.publisher.eventManager, event: event.name)
        print(type(of: Data.self))

        handlers?.forEach{ handler in

            guard let handler = handler as? HandlerPublisherData<Publisher, Data> else {
                return
            }

            handler.callback(event)

        }
    }
}

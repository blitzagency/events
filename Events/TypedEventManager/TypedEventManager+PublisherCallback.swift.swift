//
//  TypedEventManager+PublisherCallback.swift.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

extension TypedEventManager {

    public func listenTo<Event, Publisher: TypedEventManager<Event> where Event.RawValue == String>(_ publisher: Publisher, event: Event, callback:(Publisher) -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    func listenTo<Publisher: EventManagerBase>(_ publisher: Publisher, event: String, callback:(Publisher) -> ()){
        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func internalOn<Publisher: EventManagerBase>(_ publisher: Publisher, event: String, callback: (EventPublisher<Publisher>) -> ()){

        let listener = publisherListener(publisher)

        let handler = HandlerPublisher<Publisher>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )

        self.addHandler(publisher, handler: handler, listener: listener, event: event)
    }

    func trigger<Publisher: EventManagerBase>(_ event: EventPublisher<Publisher>){

        // when we trigger an event, we use buildEvent() which set's the publisher to
        // ourself on the EventPublisher<Publisher> model.
        // so event.publisher == self
        let handlers = publisherEventHandlers(event.publisher, event: event.name)

        handlers.forEach{ handler in

            guard let handler = handler as? HandlerPublisher<Publisher> else {
                return
            }

            handler.callback(event)
            
        }
    }
    

}

//
//  TypedEventManagerHost+PublisherCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension TypedEventManagerHost {

    public func listenTo<Event, Publisher: TypedEventManagerHost>(_ publisher: Publisher, event: Event, callback: @escaping (Publisher) -> ())
        where Publisher.EventType == Event, Event: RawRepresentable, Event.RawValue == String {

        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    func listenTo<Publisher: TypedEventManagerHost>(_ publisher: Publisher, event: String, callback: @escaping (Publisher) -> ()){
        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func wrapCallback<Publisher: TypedEventManagerHost>(_ callback: @escaping (Publisher) -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback(event.publisher)
        }
    }

    func internalOn<Publisher: TypedEventManagerHost>(_ publisher: Publisher, event: String, callback: @escaping (EventPublisher<Publisher>) -> ()){

        let listener = eventManager.publisherListener(publisher.eventManager)

        let handler = HandlerPublisher<Publisher>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )

        eventManager.addHandler(publisher.eventManager, handler: handler, listener: listener, event: event)
    }


    func trigger<Publisher: TypedEventManagerHost>(_ event: EventPublisher<Publisher>){

        // when we trigger an event, we use buildEvent() which set's the publisher to
        // ourself on the EventPublisher<Publisher> model.
        // so event.publisher == self


        let handlers = eventManager.publisherEventHandlers(event.publisher.eventManager, event: event.name)

        handlers?.forEach{ handler in
            guard let handler = handler as? HandlerPublisher<Publisher> else {
                return
            }
            
            handler.callback(event)
            
        }
    }
}

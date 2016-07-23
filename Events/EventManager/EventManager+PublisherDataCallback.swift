//
//  StringEventManageable+PublisherDataCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension EventManager {

    public func listenTo<Publisher: EventManager, Data, Event: RawRepresentable where Event.RawValue == String>(_ publisher: Publisher, event: Event, callback:(Publisher, Data) -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: EventManager, Data>(_ publisher: Publisher, event: String, callback:(Publisher, Data) -> ()){

        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func internalOn<Publisher: EventManager, Data>(_ publisher: Publisher, event: String, callback: (EventPublisherData<Publisher, Data>) -> ()){

        let listener = publisherListener(publisher)

        let handler = HandlerPublisherData<Publisher, Data>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )


        self.addHandler(publisher, handler: handler, listener: listener, event: event)
    }


    func trigger<Publisher: EventManager, Data>(_ event: EventPublisherData<Publisher, Data>){

        // when we trigger an event, we use buildEvent() which set's the publisher to
        // ourself on the EventPublisher<Publisher> model.
        // so event.publisher == self
        let handlers = publisherEventHandlers(event.publisher, event: event.name)

        handlers?.forEach{ handler in

            guard let handler = handler as? HandlerPublisherData<Publisher, Data> else {
                return
            }
            
            handler.callback(event)
            
        }
    }
}

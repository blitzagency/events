//
//  EventManager+PublisherCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/18/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension EventManager {

    public func listenTo<Publisher: EventManager, Event: RawRepresentable where Event.RawValue == String>(publisher: Publisher, event: Event, callback:(Publisher) -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: EventManager>(publisher: Publisher, event: String, callback:(Publisher) -> ()){
        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func wrapCallback<Publisher: EventManager>(callback: (Publisher) -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback(event.publisher)
        }
    }

    func internalOn<Publisher: EventManager>(publisher: Publisher, event: String, callback: (EventPublisher<Publisher>) -> ()){

        let listener = publisherListener(publisher)

        let handler = HandlerPublisher<Publisher>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )


        self.addHandler(publisher, handler: handler, listener: listener, event: event)
        
    }

    func addHandler<Publisher: EventManager>(publisher: Publisher, handler: HandlerPublisher<Publisher>, listener: Listener, event: String){

        var handlers = self.publisherEventHandlers(publisher, event: event) ?? [HandlerBase]()

        dispatch_sync(publisher.lockingQueue){
            listener.count = listener.count + 1
            handlers.append(handler)

            // set the handler back on the publisher
            // when the publisher triggers it cycles though
            // it's own events and invokes the handlers
            //
            // also add our listener to the publisher's list
            // of listeners. We will use this as a way to identify
            // things when we have stopListening.
            publisher.events[event] = handlers
            publisher.listeners[listener.subscriberId] = listener
        }

    }

    public func trigger<Publisher: EventManager>(event: EventPublisher<Publisher>){

        // when we trigger an event, we use buildEvent() which set's the publisher to
        // ourself on the EventPublisher<Publisher> model.
        // so event.publisher == self
        let handlers = publisherEventHandlers(event.publisher, event: event.name)

        handlers?.forEach{ handler in
            guard let handler = handler as? HandlerPublisher<Publisher> else {
                return
            }

            handler.callback(event)
            
        }
        
    }
}

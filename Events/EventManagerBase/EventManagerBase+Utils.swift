//
//  StringEventManageable.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation



extension EventManagerBase {

    func wrapCallback<Publisher: EventManagerBase>(_ callback: () -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback()
        }
    }

    func wrapCallback<Publisher: EventManagerBase>(_ callback: (Publisher) -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback(event.publisher)
        }
    }

    func wrapCallback<Publisher: EventManagerBase, Data>(_ callback: (Publisher, Data) -> ()) -> (EventPublisherData<Publisher, Data>) -> (){
        return { event in
            callback(event.publisher, event.data)
        }
    }

    func addHandler(_ publisher: EventManagerBase, handler: HandlerBase, listener: Listener, event: String){

        var handlers = self.publisherEventHandlers(publisher, event: event)

        publisher.lockingQueue.sync{

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

    /// Get the list of event handler for this publisher for the provided event type.
    func publisherEventHandlers<Publisher: EventManagerBase>(_ publisher: Publisher, event: String) -> [HandlerBase]{

        guard let handlers = publisher.events[event] else {
            let newHandlers = [HandlerBase]()

            publisher.lockingQueue.sync{
                publisher.events[event] = newHandlers
            }

            return newHandlers
        }

        return handlers;
    }

    /// Get the `Listener` for the provided Publisher
    func publisherListener<Publisher: EventManagerBase>(_ publisher: Publisher) -> Listener{

        guard let listener = listeningTo[publisher.listenId] else {
            // If no Listener exisis, we create a new one assing ourselves
            // as the subscriber for this Listener
            let listener = Listener(publisher: publisher, subscriber: self)

            // now, add this listener to our list of things
            // we are listening to.

            lockingQueue.sync{
                self.listeningTo[publisher.listenId] = listener
            }

            return listener
        }
        
        return listener
        
    }
}

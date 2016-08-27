//
//  StringEventManageable.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation



extension EventManagerBase {

    /**
     Stop listening to events from all publishers
    */
    public func stopListening(){
        listeningTo.forEach { (key, listener) -> () in
            stopListening(listener.publisher)
        }
    }

    /**
     Stop listening to events triggered by the specified publisher

     - Parameter publisher: The EventManageable we would like to stop listening to.
     - Parameter event: An optional `String` event to limit our removal scope

     - Remark:
        If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Publisher: EventManageable>(_ publisher: Publisher, event: String? = nil){

        // are we listening to this publisher?
        guard let listener = listeningTo[publisher.listenId] else {
            return
        }

        // we need the events names and handlers
        // for every event this publisher might have
        // as we need to check if we are a part of
        // any of them and remove ourselves

        lockingQueue.sync{
            // we are going to loop over all of the events
            // and any that do not have the publiher that was
            // was passed in we will add to this new
            // events dictionary and reset it, thus
            // we stop listening to the provided publisher.
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

                    if let event = event, event != key{
                        activeHandlers.append(handler)
                        return
                    }

                    let candidate = handler.listener
                    candidate.count = candidate.count - 1

                    if candidate.count == 0{
                        // see: addHandler(...). The listeners is registered
                        // with listener.subscriberId
                        publisher.listeners.removeValue(forKey: candidate.subscriberId)
                        self.listeningTo.removeValue(forKey: publisher.listenId)
                    }
                }

                if activeHandlers.count > 0 {
                    events[key] = activeHandlers
                }
            }
            
            publisher.events = events
            
        }
    }

    func wrapCallback<Publisher: EventManagerBase>(_ callback: @escaping () -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback()
        }
    }

    func wrapCallback<Publisher: EventManagerBase>(_ callback: @escaping (Publisher) -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback(event.publisher)
        }
    }

    func wrapCallback<Publisher: EventManagerBase, Data>(_ callback: @escaping (Publisher, Data) -> ()) -> (EventPublisherData<Publisher, Data>) -> (){
        return { event in
            callback(event.publisher, event.data)
        }
    }

    func addHandler(_ publisher: EventManagerBase, handler: HandlerBase, listener: Listener, event: String){

        var handlers = self.publisherEventHandlers(publisher, event: event) ?? [HandlerBase]()

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
    func publisherEventHandlers<Publisher: EventManagerBase>(_ publisher: Publisher, event: String) -> [HandlerBase]?{
        return publisher.events[event]
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

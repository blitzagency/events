//
//  EventManager+PublisherDataCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/18/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension EventManager {

    public func listenTo<Publisher: StringEventManager, Data, Event: RawRepresentable where Event.RawValue == String>(publisher: Publisher, event: Event, callback:(Publisher, Data) -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: StringEventManager, Data>(publisher: Publisher, event: String, callback:(Publisher, Data) -> ()){

        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func wrapCallback<Publisher: StringEventManager, Data>(callback: (Publisher, Data) -> ()) -> (EventPublisherData<Publisher, Data>) -> (){
        return { event in
            callback(event.publisher, event.data)
        }
    }

    func internalOn<Publisher: EventManager, Data>(publisher: Publisher, event: String, callback: (EventPublisherData<Publisher, Data>) -> ()){

        let listener = publisherListener(publisher)

        let handler = HandlerPublisherData<Publisher, Data>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )


        self.addHandler(publisher, handler: handler, listener: listener, event: event)

        
    }

    func addHandler<Publisher: StringEventManager, Data>(publisher: Publisher, handler: HandlerPublisherData<Publisher, Data>, listener: Listener, event: String){
        dispatch_sync(publisher.lockingQueue){
            var handlers = self.publisherEventHandlers(publisher, event: event)

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

    public func trigger<Publisher: StringEventManager, Data>(event: EventPublisherData<Publisher, Data>){

        // when we trigger an event, we use buildEvent() which set's the publisher to
        // ourself on the EventPublisher<Publisher> model.
        // so event.publisher == self
        let handlers = publisherEventHandlers(event.publisher, event: event.name)

        handlers.forEach{ handler in

            guard let handler = handler as? HandlerPublisherData<Publisher, Data> else {
                return
            }

            handler.callback(event)
            
        }
    }
}
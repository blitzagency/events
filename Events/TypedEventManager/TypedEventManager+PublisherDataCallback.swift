//
//  TypedEventManager+PublisherDataCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

//
//  StringEventManageable+PublisherDataCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension TypedEventManager {

    public func listenTo<Data, Event: RawRepresentable, Publisher: TypedEventManager<Event>>(_ publisher: Publisher, event: Event, callback: @escaping (Publisher, Data) -> ())
        where Event.RawValue == String {

        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    func listenTo<Data, Publisher: EventManagerBase>(_ publisher: Publisher, event: String, callback: @escaping (Publisher, Data) -> ()){

        let wrappedCallback = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }



    func internalOn<Data, Publisher: EventManagerBase>(_ publisher: Publisher, event: String, callback: @escaping (EventPublisherData<Publisher, Data>) -> ()){

        let listener = publisherListener(publisher)

        let handler = HandlerPublisherData<Publisher, Data>(
            publisher: listener.publisher,
            subscriber: listener.subscriber,
            listener: listener,
            callback: callback
        )

        self.addHandler(publisher, handler: handler, listener: listener, event: event)
    }


    func trigger<Publisher: EventManagerBase, Data>(_ event: EventPublisherData<Publisher, Data>){

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

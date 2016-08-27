//
//  TypedEventManagerHost+ParameterlessCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

extension TypedEventManagerHost {

    public func listenTo<Event: RawRepresentable, Publisher: TypedEventManager<Event>>(_ publisher: Publisher, event: Event, callback: @escaping () -> ())
        where Event.RawValue == String {

            eventManager.listenTo(publisher, event: event.rawValue, callback: callback)
    }


    public func listenTo<Event: RawRepresentable, Publisher: TypedEventManagerHost>(_ publisher: Publisher, event: Publisher.EventType, callback: @escaping () -> ())
        where Publisher.EventType == Event, Event.RawValue == String {

        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    func listenTo<Publisher: TypedEventManagerHost>(_ publisher: Publisher, event: String, callback: @escaping () -> ()){
        let wrappedCallback: (EventPublisher<Publisher>) -> () = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func wrapCallback<Publisher: TypedEventManagerHost>(_ callback: @escaping () -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback()
        }
    }


}

//
//  TypedEventManagerHost+ParameterlessCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

extension TypedEventManagerHost {

    public func listenTo<Event: RawRepresentable, Publisher: TypedEventManager<Event> where Event.RawValue == String>(_ publisher: Publisher, event: Event, callback:() -> ()){
        eventManager.listenTo(publisher, event: event.rawValue, callback: callback)
    }


    public func listenTo<Event: RawRepresentable, Publisher: TypedEventManagerHost where Publisher.EventType == Event, Event.RawValue == String>(_ publisher: Publisher, event: Publisher.EventType, callback:() -> ()){
        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    func listenTo<Publisher: TypedEventManagerHost>(_ publisher: Publisher, event: String, callback:() -> ()){
        let wrappedCallback: (EventPublisher<Publisher>) -> () = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

    func wrapCallback<Publisher: TypedEventManagerHost>(_ callback: () -> ()) -> (EventPublisher<Publisher>) -> (){
        return { event in
            callback()
        }
    }


}

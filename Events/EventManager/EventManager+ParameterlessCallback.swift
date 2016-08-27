//
//  StringEventManageable+ParameterlessCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

extension EventManager {


    public func listenTo<Publisher: EventManager, Event: RawRepresentable>(_ publisher: Publisher, event: Event, callback: @escaping () -> ())
        where Event.RawValue == String {

        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    public func listenTo<Publisher: EventManager>(_ publisher: Publisher, event: String, callback: @escaping () -> ()){
        let wrappedCallback: (EventPublisher<Publisher>) -> () = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

}

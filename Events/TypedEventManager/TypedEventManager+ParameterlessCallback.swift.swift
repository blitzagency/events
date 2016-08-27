//
//  TypedEventManager+ParameterlessCallback.swift.swift
//  Events
//
//  Created by Adam Venturella on 7/21/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

extension TypedEventManager {


    public func listenTo<Event: RawRepresentable, Publisher: TypedEventManager<Event>>(_ publisher: Publisher, event: Event, callback: @escaping () -> ())
        where Event.RawValue == String {

        listenTo(publisher, event: event.rawValue, callback: callback)
    }

    func listenTo<Publisher: EventManagerBase>(_ publisher: Publisher, event: String, callback: @escaping () -> ()){
        let wrappedCallback: (EventPublisher<Publisher>) -> () = wrapCallback(callback)
        internalOn(publisher, event: event, callback: wrappedCallback)
    }

}

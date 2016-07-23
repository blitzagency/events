//
//  EventManager+NoneCallback.swift
//  Events
//
//  Created by Adam Venturella on 7/18/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension EventManager {

//    public func listenTo<Publisher: StringEventManager, Event: RawRepresentable where Event.RawValue == String>(publisher: Publisher, event: Event, callback:() -> ()){
//        listenTo(publisher, event: event.rawValue, callback: callback)
//    }
//
//    public func listenTo<Publisher: StringEventManager>(publisher: Publisher, event: String, callback:() -> ()){
//        let wrappedCallback: (EventPublisher<Publisher>) -> () = wrapCallback(callback)
//        internalOn(publisher, event: event, callback: wrappedCallback)
//    }
//
//    func wrapCallback<Publisher: StringEventManager>(callback: () -> ()) -> (EventPublisher<Publisher>) -> (){
//        return { event in
//            callback()
//        }
//    }
}
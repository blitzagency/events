//
//  TypedEventManagerHost.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public protocol TypedEventManagerHost {
    associatedtype EventType: RawRepresentable
    var eventManager: TypedEventManager<EventType> {get}
}

extension TypedEventManagerHost{

    public func trigger(_ event: EventType){
        guard let value = event.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value)
    }

    public func trigger<Data>(_ event: EventType, data: Data){
        guard let value = event.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value, data: data)
    }

    func trigger(_ event: String){
        let event = buildEvent(event, publisher: self)
        trigger(event)
    }

    func trigger<Data>(_ event: String, data: Data){
        let event = buildEvent(event, publisher: self, data: data)
        trigger(event)
    }

    /**
     Stop listening to events triggered by the specified publisher

     - Parameter publisher: The TypedEventManagerHost we would like to stop listening to.
     - Parameter event: An optional `String RawRepresentable` of type `T` event to limit our removal scope

     - Remark:
     If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Event: RawRepresentable, Publisher: TypedEventManagerHost where Event == Publisher.EventType, Event.RawValue == String>(_ publisher: Publisher, event: Event?){
        eventManager.stopListening(publisher.eventManager, event: event?.rawValue)
    }

    /**
     Stop listening to events triggered by the specified publisher

     - Parameter publisher: The TypedEventManageable we would like to stop listening to.
     - Parameter event: An optional `String RawRepresentable` of type `T` event to limit our removal scope

     - Remark:
     If no event is given, all events will be silenced from the specified publisher.
     */
    public func stopListening<Event: RawRepresentable, Publisher: TypedEventManageable where Event == Publisher.EventType, Event.RawValue == String>(_ publisher: Publisher, event: Event?){
        eventManager.stopListening(publisher, event: event?.rawValue)
    }

    public func stopListening(){
        eventManager.stopListening()
    }

    public func stopListening<Publisher: TypedEventManageable>(_ publisher: Publisher){
        eventManager.stopListening(publisher)
    }

    public func stopListening<Publisher: TypedEventManagerHost>(_ publisher: Publisher){
        eventManager.stopListening(publisher.eventManager)
    }
}



//public final class AnyEvent<Event: RawRepresentable where Event.RawValue == String>: RawRepresentable{
//    public typealias RawValue = String
//
//    var box: Event
//
//    init<T: RawRepresentable where T.RawValue == RawValue>(_ value: T) {
//        box = value
//    }
//
//    public init?(rawValue: RawValue){
//        fatalError()
//    }
//
//    public var rawValue: RawValue {
//        fatalError()
//    }
//
//}
//    public typealias RawValue = String
//    private let box: Event
//
//    init<T: RawRepresentable where T.RawValue == String, Event.RawValue == T.RawValue>(_ value: T) {
//        box = value as! Event
//    }
//
//    public init?(rawValue: String){
//        fatalError()
//    }
//
//    public var rawValue: String {
//        return box.rawValue as! String
//    }
//}


//public struct AnyTypedEvent<T: RawRepresentable where T.RawValue == String>: StringRawRepresentable{
//    public typealias RawValue = T.RawValue
//    public typealias Event = T.Type
//
//    public let box: T
//
//    public init(_ event: T){
//        self.box = event
//    }
//
//    public init?(rawValue: String){
//        //fatalError()
//        self.box = T(rawValue: rawValue)!
//    }
//
//    public var rawValue: String {
//        return box.rawValue
//    }
//}





//public protocol TypedEventManagerHost {
//    associatedtype Event
//    var eventManager: TypedEventManager<AnyEvent<Event>> {get}
//}

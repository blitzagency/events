//
//  TypedEventManagerHost.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public protocol TypedEventManagerHost {
    associatedtype Event: RawRepresentable
    var eventManager: TypedEventManager<Event> {get}
}

extension TypedEventManagerHost{

    public func trigger(_ event: Event){
        guard let value = event.rawValue as? String else{
            fatalError("TypedEventManager<\(Event.self)> is not representable as a 'String'")
        }

        trigger(value)
    }

    public func trigger<Data>(_ event: Event, data: Data){
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

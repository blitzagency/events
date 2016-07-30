//
//  Handler.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation



public protocol EventHandler {
    var publisher: EventManagerBase { get }
    var subscriber: EventManagerBase { get }
    var listener: Listener { get }
}

public protocol PublisherCallback {
    associatedtype Event
    var callback: (Event) -> () { get }
}

public protocol PublisherDataCallback {
    associatedtype Event
    var callback: (Event) -> () { get }
}



// Swift does not allow struct inheritance
// because of that, these are classes as we need to be 
// able to cast up and down the type heirarchy in 
// EventManager.trigger

public class HandlerBase: EventHandler {

    public unowned let publisher: EventManagerBase
    public unowned let subscriber: EventManagerBase
    public unowned let listener: Listener

    public init(publisher: EventManagerBase, subscriber: EventManagerBase, listener: Listener){
        self.publisher = publisher
        self.subscriber = subscriber
        self.listener = listener
    }
}


public class HandlerPublisher<Publisher>: HandlerBase, PublisherCallback {
    public let callback: (EventPublisher<Publisher>) -> ()

    public init(publisher: EventManagerBase, subscriber: EventManagerBase, listener: Listener, callback: (EventPublisher<Publisher>) -> ()){
        self.callback = callback
        super.init(publisher: publisher, subscriber: subscriber, listener: listener)
    }
}

public class HandlerPublisherData<Publisher, Data>: HandlerBase, PublisherDataCallback {
    public let callback: (EventPublisherData<Publisher, Data>) -> ()

    public init(publisher: EventManagerBase, subscriber: EventManagerBase, listener: Listener, callback: (EventPublisherData<Publisher, Data>) -> ()){
        self.callback = callback
        super.init(publisher: publisher, subscriber: subscriber, listener: listener)
    }
}

//
//  Event.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation


public protocol Event{
    var name: String { get }
}

public protocol PublisherAssociated{
    associatedtype Publisher
    var publisher: Publisher { get }
}

public protocol DataAssociated{
    associatedtype Data
    var data: Data { get }
}


public struct EventPublisher<Publisher>: Event, PublisherAssociated{
    public let name: String
    public let publisher: Publisher


    public init(name: String, publisher: Publisher){
        self.name = name
        self.publisher = publisher
    }

}


public struct EventPublisherData<Publisher, Data>: Event, PublisherAssociated, DataAssociated{
    public let name: String
    public let publisher: Publisher
    public let data: Data


    public init(name: String, publisher: Publisher, data: Data){
        self.name = name
        self.publisher = publisher
        self.data = data
    }
    
}

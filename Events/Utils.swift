//
//  Utils.swift
//  Events
//
//  Created by Adam Venturella on 11/30/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

func uniqueId() -> String {
    return UUID().uuidString
}



func buildEvent<Publisher>(_ name: String, publisher: Publisher) -> EventPublisher<Publisher>{
    return EventPublisher(name: name, publisher: publisher)
}


func buildEvent<Publisher, Data>(_ name: String, publisher: Publisher, data: Data) -> EventPublisherData<Publisher, Data>{
    return EventPublisherData(name: name, publisher: publisher, data: data)
}

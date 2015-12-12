//
//  Listener.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation


public class Listener{
    var listeningTo: [String: Listener]
    unowned let publisher: EventManager
    unowned let subscriber: EventManager
    var count = 0

    public init(publisher: EventManager, subscriber: EventManager, listeningTo: [String: Listener]){
        self.publisher = publisher
        self.subscriber = subscriber
        self.listeningTo = listeningTo
    }

    var publisherId: String {
        return publisher.listenId
    }

    var subscriberId: String {
        return subscriber.listenId
    }
}

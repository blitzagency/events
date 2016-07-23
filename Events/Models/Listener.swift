//
//  Listener.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation


public class Listener {
    unowned let publisher: EventManagerBase
    unowned let subscriber: EventManagerBase
    var count = 0

    public init(publisher: EventManagerBase, subscriber: EventManagerBase){
        self.publisher = publisher
        self.subscriber = subscriber
    }

    var publisherId: String {
        return publisher.listenId
    }

    var subscriberId: String {
        return subscriber.listenId
    }
}

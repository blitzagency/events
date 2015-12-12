//
//  Handler.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation


public struct Handler{
    unowned let publisher: EventManager
    unowned let subscriber: EventManager
    unowned let listener: Listener
    let callback: (Event) -> ()

    init(publisher: EventManager, subscriber: EventManager, listener: Listener, callback: (Event)->()){
        self.publisher = publisher
        self.subscriber = subscriber
        self.listener = listener
        self.callback = callback
    }
}

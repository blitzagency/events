//
//  EventManagerBase.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public class EventManagerBase : EventManageable {
    public let listenId = uniqueId()
    public var listeningTo: [String: Listener] = [:]
    public var events = [String: [HandlerBase]]()
    public var listeners = [String: Listener]()
    public let lockingQueue = DispatchQueue(label: "com.events.manager.queue.\(uniqueId)")

    public init(){}
}


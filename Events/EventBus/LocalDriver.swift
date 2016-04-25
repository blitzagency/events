//
//  LocalSession.swift
//  DeviceEventBus
//
//  Created by Adam Venturella on 4/24/16.
//
//

import Foundation


public class LocalDriver: ChannelDriver {
    public var channels = [String: Channel]()
    
    public init(){

    }

    public func send(channel channel: String, name: String, data: Any? = nil) {

        guard let channel = channels[channel] else{
            return
        }

        let event = Event(name: name, publisher: channel, data: data)
        channel.eventManager.trigger(event)
    }
}
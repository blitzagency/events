//
//  ChannelDriver.swift
//  EventBus
//
//  Created by Adam Venturella on 4/24/16.
//
//

import Foundation

public protocol ChannelDriver: class{
    var channels: [String: Channel] {get set}
    func send(channel channel: String, name: String, data: Any?)
}

extension ChannelDriver{
    public func get(key: String = "default") -> Channel{
        if let channel = channels[key]{
            print("Got Existing Key: '\(key)'")
            return channel
        }

        print("Creating new channel: '\(key)'")
        let channel = Channel(name: key, driver: self)
        channels[key] = channel

        return channel
    }

    public func reset(key: String? = nil){
        if key == nil{
            channels.forEach{ $1.stopListening() }
            channels.removeAll()
            return
        }

        if let key = key, let channel = channels[key]{
            channel.stopListening()
            channels.removeValueForKey(key)
        }
        
    }
}
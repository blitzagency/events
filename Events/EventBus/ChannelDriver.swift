//
//  ChannelDriver.swift
//  EventBus
//
//  Created by Adam Venturella on 4/24/16.
//
//

import Foundation


class ChannelDriverThunk<SendType>: ChannelDriver{
    var channels = [String: Channel<SendType>]()

    private let _send : (String, String, SendType?) -> ()

    init<Driver: ChannelDriver where Driver.SendType == SendType>(driver: Driver){
        _send = driver.send
    }

    func send(channel channel: String, name: String, data: SendType? = nil){
        _send(channel, name, data)
    }

}


public protocol ChannelDriver: class{
    associatedtype SendType
    var channels: [String: Channel<SendType>] {get set}
    func send(channel channel: String, name: String, data: SendType?)
}

extension ChannelDriver{
    public func get(key: String = "default") -> Channel<SendType>{
        if let channel = channels[key]{
            print("Got Existing Key: '\(key)'")
            return channel
        }

        print("Creating new channel: '\(key)'")
        let channel = Channel<SendType>(name: key, driver: self)
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
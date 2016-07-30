//
//  LocalChannelDriver.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public class LocalChannelDriver: ChannelDriver{
    public var channels = [String: Channel]()

    public func get<Label: RawRepresentable where Label.RawValue == String>(_ key: Label) -> Channel{
        return get(key.rawValue)
    }

    public func get(_ key: String = "default") -> Channel{
        if let channel = channels[key]{
            print("Got Existing Key: '\(key)'")
            return channel
        }

        print("Creating new channel: '\(key)'")

        let channel = Channel(label: key)
        channels[key] = channel

        return channel
    }
    
}

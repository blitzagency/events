//
//  ChannelDriver.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

public protocol ChannelDriver{
    associatedtype ChannelType
    var channels: [String: ChannelType] {get}
    func get(_ key: String) -> ChannelType
}

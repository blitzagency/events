//
//  EventBus.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public class EventBus{

    public static var localChannel: LocalChannelDriver = {
        return LocalChannelDriver()
    }()

    // we don't include WatchKitChannelDriver in the macOS build.
    // If you remove these platform gaurds Events will not compile
    // on macOS. However, if you are iOS or watchOS we only
    // support watchChannels accordingly.
    #if os(iOS) || os(watchOS)
    @available(iOS 9.0, watchOS 2.0, *)
    public static var watchChannel: WatchKitChannelDriver = {
        return WatchKitChannelDriver.driver()
    }()
    #endif
    
}

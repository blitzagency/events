//
//  DeviceEventBus.swift
//  NotchDeviceEventBus
//
//  Created by Adam Venturella on 4/23/16.
//
//

import Foundation


public class EventBus{

    public static var localChannel: LocalDriver = {
        return LocalDriver()
    }()


    #if os(iOS) || os(watchOS)
    @available(iOS 9.0, watchOS 2.0, *)
    public static var watchChannel: WatchDriver = {
        return WatchDriver.defaultSession()
    }()
    #endif

}
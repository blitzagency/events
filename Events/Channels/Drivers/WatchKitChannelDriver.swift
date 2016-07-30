//
//  WatchKitChannelDriver.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

import Foundation
import WatchConnectivity

#if TEST
    typealias WatchSessionType = MockWCSession
#else
    typealias WatchSessionType = WCSession
#endif


@available(iOS 9.0, watchOS 2.0, *)
@objc public class WatchKitChannelDriver: NSObject, WCSessionDelegate, ChannelDriver{
    static var _driver: WatchKitChannelDriver?
    
    var _session: WatchSessionType?
    public var channels = [String: WatchKitChannel]()

    public static func driver() -> WatchKitChannelDriver{
        if let driver = _driver{
            return driver
        }

        let driver = WatchKitChannelDriver()
        _driver = driver

        return driver
    }


    override public init(){
        super.init()
        initSession()
    }

    func initSession(){
        // the session is always available on watchOS
        if WatchSessionType.isSupported(){
            let defaultSession = WatchSessionType.default() as! WatchSessionType
            defaultSession.delegate = self
            defaultSession.activate()

            _session = defaultSession
        }
    }

    public func get<Label: RawRepresentable where Label.RawValue == String>(_ key: Label) -> WatchKitChannel{
        return get(key.rawValue)
    }

    public func get(_ key: String = "default") -> WatchKitChannel{
        if let channel = channels[key]{
            print("Got Existing Key: '\(key)'")
            return channel
        }

        print("Creating new channel: '\(key)'")

        let channel = WatchKitChannel(label: key, driver: self)
        channels[key] = channel

        return channel
    }

    @available(iOSApplicationExtension 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: NSError?){

    }

    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession){

    }

    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession){

    }

    public func send(_ payload:[String: AnyObject]){
        // data has to be AnyObject to be serialized
        guard let session = _session, session.isReachable else {
            print("No Session or session is not reachable")
            return
        }

        session.sendMessage(payload, replyHandler: nil, errorHandler: nil)
    }

    public func session(_ session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard let channelLabel = message["channel"] as? String else {
            fatalError("No channel label provided")
        }

        guard let channel = channels[channelLabel] else {
            return
        }

        guard let event = message["event"] as? String else {
            fatalError("Message received without a key: 'event' or that value was not convertible to a String")
        }


        if let request = message["request"] as? [String: AnyObject] {
            handleRequest(channel, event: event, message: message, request: request)
        } else {
            handleEvent(channel, event: event, message: message)
        }

    }

    func handleRequest(_ channel: WatchKitChannel, event: String, message: [String: AnyObject], request: [String: AnyObject]){

        let args = request["args"] as? [AnyObject]
        let argCount = args?.count ?? 0

        // cast the channel to EventManagerHost 
        // so we don't end up in an infinite loop.
        // We want to call trigger() on the EventManagerHost so it 
        // doesn't try to send the data over the WCSession
        
        switch argCount{
        case 0:
            let args = deserializeWatchKitRequestEventNoArgs(request)
            let event = buildEvent(event, publisher: channel, data: args)
            (channel as EventManagerHost).trigger(event)
        case 1:
            let args = deserializeWatchKitRequestEventArgs1(request)
            let event = buildEvent(event, publisher: channel, data: args)
            (channel as EventManagerHost).trigger(event)
        case 2:
            let args = deserializeWatchKitRequestEventArgs2(request)
            let event = buildEvent(event, publisher: channel, data: args)
            (channel as EventManagerHost).trigger(event)
        case 3:
            let args = deserializeWatchKitRequestEventArgs3(request)
            let event = buildEvent(event, publisher: channel, data: args)
            (channel as EventManagerHost).trigger(event)
        default:
            fatalError("Unable to handle argument count '\(argCount)'")
        }

    }

    func handleEvent(_ channel: WatchKitChannel, event: String, message: [String: AnyObject]){
        if let data = message["data"]{
            let event = buildEvent(event, publisher: channel, data: data)
            (channel as EventManagerHost).trigger(event)
        } else {
            (channel as EventManagerHost).trigger(event)
        }
    }
}

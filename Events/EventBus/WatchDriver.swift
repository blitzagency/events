//
//  WatchKitDriver.swift
//  DeviceEventBus
//
//  Created by Adam Venturella on 4/24/16.
//
//

import Foundation
import WatchConnectivity

@available(iOS 9.0, watchOS 2.0, *)
@objc public class WatchDriver: NSObject, WCSessionDelegate, ChannelDriver{

    static var _defaultDriver: WatchDriver?
    var session: WCSession?
    public var channels = [String: Channel]()

    public static func defaultSession() -> WatchDriver{
        if let driver = _defaultDriver{
            return driver
        }

        let driver = WatchDriver()
        _defaultDriver = driver

        return driver
    }


    override init(){
        super.init()
        initSession()
    }

    func initSession(){
        // the session is always available on watchOS
        if WCSession.isSupported(){
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            self.session = session
        }
    }

    public func send(channel channel: String, name: String, data: Any? = nil) {
        guard let session = session where session.reachable else {
            print("No Session or session is not reachable")
            return
        }

        let payload: [String: AnyObject]
        if let data = data{
            // we are sending across the divide
            // we can only send AnyObject to get the serialization
            if let object = data as? AnyObject{
                payload = ["channel": channel, "name": name, "data": object]
            } else {
                fatalError("Attempt to send data that cannot be converted to AnyObject for serialization")
            }

        } else {
            payload = ["channel": channel, "name": name]
        }

        session.sendMessage(payload, replyHandler: nil, errorHandler: nil)
    }

    public func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        guard let channelName = message["channel"] as? String else {
            fatalError("No channel name provided")
        }

        guard let channel = channels[channelName] else {
            return
        }

        guard let name = message["name"] as? String else {
            fatalError("Message received without a key: 'name' or that value was not convertible to a String")
        }

        if let data = message["data"]{
            let event = Event(name: name, publisher: channel, data: data)
            channel.eventManager.trigger(event)
        } else {
            let event = Event(name: name, publisher: channel)
            channel.eventManager.trigger(event)
        }
    }
}
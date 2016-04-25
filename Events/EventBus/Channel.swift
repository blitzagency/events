//
//  DeviceChannel.swift
//  DeviceEventBus
//
//  Created by Adam Venturella on 4/23/16.
//
//

import Foundation


public class Channel: EventManagerHost{
    public let eventManager = EventManager()
    let name: String
    let driver: ChannelDriver

    public init(name: String, driver: ChannelDriver){
        self.name = name
        self.driver = driver
    }

    public func reply<Result>(name: String, @autoclosure(escaping) value : () -> Result){
        reply(name, callback: value)
    }

    public func reply<Result>(name: String, callback : () -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self] in
            let data = callback()
            self.trigger(reply, data: data)
        }
    }

    public func reply<Result, A0>(name: String, callback: (A0) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel, args:[AnyObject]) in

            let arg0 = args[0] as! A0

            self.trigger(reply, data: callback(arg0))
        }
    }

    public func reply<Result, A0, A1>(name: String, callback: (A0, A1) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel, args:[AnyObject]) in

            let arg0 = args[0] as! A0
            let arg1 = args[1] as! A1

            self.trigger(reply, data: callback(arg0, arg1))
        }
    }

    public func reply<Result, A0, A1, A2>(name: String, callback: (A0, A1, A2) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel, args:[AnyObject]) in

            let arg0 = args[0] as! A0
            let arg1 = args[1] as! A1
            let arg2 = args[2] as! A2

            self.trigger(reply, data: callback(arg0, arg1, arg2))
        }
    }

    public func reply<Result, A0, A1, A2, A3>(name: String, callback: (A0, A1, A2, A3) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel, args:[AnyObject]) in

            let arg0 = args[0] as! A0
            let arg1 = args[1] as! A1
            let arg2 = args[2] as! A2
            let arg3 = args[3] as! A3

            self.trigger(reply, data: callback(arg0, arg1, arg2, arg3))
        }
    }


    public func request<Result>(name: String, callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        trigger(request)
    }

    public func request<Result, A0: AnyObject>(name: String, _ arg0: A0, callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        trigger(request, data: [arg0])
    }

    public func request<Result, A0: AnyObject, A1: AnyObject>(name: String, _ arg0: A0, _ arg1: A1, callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        trigger(request, data: [arg0, arg1])
    }

    public func request<Result, A0: AnyObject, A1: AnyObject, A2: AnyObject>(name: String, _ arg0: A0, _ arg1: A1, _ arg2: A2,  callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel, data: Result) in
            self.stopListening(reply)
            callback(data)
        }
        
        trigger(request, data: [arg0, arg1, arg2])
    }

    public func request<Result, A0: AnyObject, A1: AnyObject, A2: AnyObject, A3: AnyObject>(name: String, _ arg0: A0, _ arg1: A1, _ arg2: A2, _ arg3: A3,  callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        trigger(request, data: [arg0, arg1, arg2, arg3])
    }

    public func trigger(name: String, data: Any? = nil){
        let event = Event(name: name, publisher: self, data: data)
        trigger(event)
    }


    public func trigger<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, data: Any? = nil){

        let event = Event(name: name.rawValue, publisher: self, data: data)
        trigger(event)
    }

    public func trigger(event: Events.Event) {
        if let data = event.data{
            driver.send(channel: name, name: event.name, data: data)
            return
        }

        driver.send(channel: name, name: event.name, data: nil)
    }
}

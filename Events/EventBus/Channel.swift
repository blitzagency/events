//
//  DeviceChannel.swift
//  DeviceEventBus
//
//  Created by Adam Venturella on 4/23/16.
//
//

import Foundation

public typealias WatchChannel = Channel<AnyObject>
public typealias LocalChannel = Channel<Any>

public class Channel<SendType>: EventManagerHost{
    public let eventManager = EventManager()

    let name: String
    let driver: ChannelDriverThunk<SendType>

    public init<Driver: ChannelDriver where Driver.SendType == SendType>(name: String, driver: Driver){
        self.name = name
        self.driver = ChannelDriverThunk(driver: driver)
    }

    public func reply<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, @autoclosure(escaping) value : () -> Result){
        reply(name.rawValue, callback: value)
    }

    public func reply<Result>(name: String, @autoclosure(escaping) value : () -> Result){
        reply(name, callback: value)
    }

    public func reply<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, callback : () -> Result){
        reply(name.rawValue, callback: callback)
    }

    func reply<Result>(name: String, callback : () -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self] in
            let result = callback() as? SendType
            self.trigger(reply, data: result)
        }
    }

    public func reply<Result, A0, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, callback: (A0) -> Result){
        reply(name.rawValue, callback: callback)
    }

    public func reply<Result, A0>(name: String, callback: (A0) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel<SendType>, args:[SendType]) in

            let arg0 = args[0] as! A0

            let result = callback(arg0)

            if let result = result as? SendType{
                self.trigger(reply, data: result)
            } else {
                self.replyError(result, name: name)
            }

        }
    }

    public func reply<Result, A0, A1, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, callback: (A0, A1) -> Result){
        reply(name.rawValue, callback: callback)
    }

    public func reply<Result, A0, A1>(name: String, callback: (A0, A1) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel<SendType>, args:[SendType]) in

            let arg0 = args[0] as! A0
            let arg1 = args[1] as! A1

            let result = callback(arg0, arg1)

            if let result = result as? SendType{
                self.trigger(reply, data: result)
            } else {
                self.replyError(result, name: name)
            }
        }
    }

    public func reply<Result, A0, A1, A2, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, callback: (A0, A1, A2) -> Result){
        reply(name.rawValue, callback: callback)
    }

    public func reply<Result, A0, A1, A2>(name: String, callback: (A0, A1, A2) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel<SendType>, args:[SendType]) in

            let arg0 = args[0] as! A0
            let arg1 = args[1] as! A1
            let arg2 = args[2] as! A2

            let result = callback(arg0, arg1, arg2)

            if let result = result as? SendType{
                self.trigger(reply, data: result)
            } else {
                self.replyError(result, name: name)
            }
        }
    }

    public func reply<Result, A0, A1, A2, A3, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, callback: (A0, A1, A2, A3) -> Result){
        reply(name.rawValue, callback: callback)
    }

    public func reply<Result, A0, A1, A2, A3>(name: String, callback: (A0, A1, A2, A3) -> Result){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, request){[unowned self]
            (sender: Channel<SendType>, args:[SendType]) in

            let arg0 = args[0] as! A0
            let arg1 = args[1] as! A1
            let arg2 = args[2] as! A2
            let arg3 = args[3] as! A3

            let result = callback(arg0, arg1, arg2, arg3)

            if let result = result as? SendType{
                self.trigger(reply, data: result)
            } else {
                self.replyError(result, name: name)
            }
        }
    }


    public func request<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, callback: (Result) -> ()){
        request(name.rawValue, callback: callback)
    }

    public func request<Result>(name: String, callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel<SendType>, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        trigger(request)
    }

    public func request<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, _ arg0: SendType, callback: (Result) -> ()){
        request(name.rawValue, arg0, callback: callback)
    }

    public func request<Result>(name: String, _ arg0: SendType, callback:(Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel<SendType>, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        let args = [arg0]
        if let args = args as? SendType{
            trigger(request, data: args)
        } else{
            requestError(args, name: name)
        }

    }

    public func request<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, _ arg0: SendType, _ arg1: SendType, callback: (Result) -> ()){
        request(name.rawValue, arg0, arg1, callback: callback)
    }

    public func request<Result>(name: String, _ arg0: SendType, _ arg1: SendType, callback: (Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel<SendType>, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        let args = [arg0, arg1]
        if let args = args as? SendType{
            trigger(request, data: args)
        } else{
            requestError(args, name: name)
        }
    }

    public func request<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, _ arg0: SendType, _ arg1: SendType, _ arg2: SendType, callback: (Result) -> ()){
        request(name.rawValue, arg0, arg1, arg2, callback: callback)
    }

    public func request<Result>(name: String, _ arg0: SendType, _ arg1: SendType, _ arg2: SendType,  callback: (Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel<SendType>, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        let args = [arg0, arg1, arg2]

        if let args = args as? SendType{
            trigger(request, data: args)
        } else{
            requestError(args, name: name)
        }
    }

    public func request<Result, EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, _ arg0: SendType, _ arg1: SendType, _ arg2: SendType, _ arg3: SendType, callback: (Result) -> ()){
        request(name.rawValue, arg0, arg1, arg2, arg3, callback: callback)
    }

    public func request<Result>(name: String, _ arg0: SendType, _ arg1: SendType, _ arg2: SendType, _ arg3: SendType,  callback: (Result) -> ()){
        let request = "request:\(name)"
        let reply = "reply:\(name)"

        listenTo(self, reply){[unowned self]
            (sender: Channel<SendType>, data: Result) in
            self.stopListening(reply)
            callback(data)
        }

        let args = [arg0, arg1, arg2, arg3]

        if let args = args as? SendType{
            trigger(request, data: args)
        } else{
            requestError(args, name: name)
        }
    }

    /// Explicitely overrides the underlying EventMangerHost's
    /// trigger method to keep us in the channel vs falling into
    /// the protocol extension's implementation.
    ///
    /// Swift attempts to call the protocol method with Any? unless you
    /// explicitely cast the input value to SendType
    public func trigger(name: String, data: Any? = nil){
        if let data = data{
            if let data = data as? SendType {
                trigger(name, data: data)
                return
            }

            triggerError(data, name: name)
        }

        trigger(name, data: SendType?.None)
    }

    /// Explicitely overrides the underlying EventMangerHost's
    /// trigger method to keep us in the channel vs falling into 
    /// the protocol extension's implementation.
    public func trigger<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, data: Any? = nil){
        trigger(name.rawValue, data: data)
    }

    public func trigger(name: String, data: SendType? = nil){
        let event = Event(name: name, publisher: self, data: data)
        trigger(event)
    }


    public func trigger<EventType: RawRepresentable where EventType.RawValue == String>(name: EventType, data: SendType? = nil){
        let event = Event(name: name.rawValue, publisher: self, data: data)
        trigger(event)
    }

    public func trigger(event: Events.Event) {
        if let data = event.data as? SendType{
            driver.send(channel: name, name: event.name, data: data)
            return
        }

        driver.send(channel: name, name: event.name, data: nil)
    }

    public func triggerError<T>(value: T, name: String){
        let message = "Unable to cast trigger data: '\(value)' to '\(SendType.self)' for '\(name)'"
        fatalError(message)
    }

    public func replyError<T>(value: T, name: String){
        let message = "Unable to cast reply data: '\(value)' to '\(SendType.self)' for '\(name)'"
        fatalError(message)
    }

    public func requestError<T>(value: T, name: String){
        let message = "Unable to cast request data: '\(value)' to '\(SendType.self)' for '\(name)'"
        fatalError(message)
    }
}

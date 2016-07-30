//
//  Channel.swift
//  Events
//
//  Created by Adam Venturella on 7/26/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation



public class Channel: EventManagerHost{
    public let channelId = uniqueId()
    public let eventManager = EventManager()
    public let label: String

    public init(label: String){
        self.label = label
    }

    public lazy var requestPrefix: String = {
        [unowned self] in
        return "\(self.channelId):request"
    }()

    public lazy var replyPrefix: String = {
        [unowned self] in
        return "\(self.channelId):reply"
    }()

    public func createReplyToken() -> String {
        return uniqueId()
    }


    // intentionally private
    // nothing should call this but request/reply
    func trigger<T>(_ event: String, args: RequestArguments<T>){
        let event = buildEvent(event, publisher: self, data: args)
        trigger(event)
    }

    // intentionally private
    // nothing should call this but request/reply
    func trigger(_ event: String, args: RequestArguments<None>){
        let event = buildEvent(event, publisher: self, data: args)
        trigger(event)
    }

    // explicitely override trigger<Data> from te the EventManagerHost
    // so we can control in subclasses of Channel how the events
    // are triggered. For example we need somethign special
    // in a WatchKitChannel
    public func trigger<Data>(_ event: String, data: Data){
        let event = buildEvent(event, publisher: self, data: data)
        trigger(event)
    }

    public func trigger(_ event: String){
        let event = buildEvent(event, publisher: self)
        trigger(event)
    }

    ///
    /// 0 Arg
    ///

    public func reply<Result>(_ event: String, callback: () -> Result){
        let request = "\(requestPrefix):\(event)"

        listenTo(self, event: request){
            [unowned self]
            (sender: Channel, args: RequestArguments<None>) in


            let result = callback()
            self.trigger(args.reply, data: result)
        }

    }

    public func request<Result>(_ event: String, callback: (Result) -> ()){
        let replyToken = createReplyToken()
        let request = "\(requestPrefix):\(event)"
        let reply = "\(replyPrefix):\(event):\(replyToken)"


        listenTo(self, event: reply){
            [unowned self]
            (sender: Channel, data: Result) in

            self.stopListening(self, event: reply)
            callback(data)
        }

        // we need something to set the generic Type of Arguments
        // so we have a contrived marker protocol called None
        let args = RequestArguments<None>(reply: reply)
        trigger(request, args: args)
    }


    ///
    /// 1 Arg
    ///

    public func reply<Result, A0>(_ event: String, callback: (A0) -> Result){
        let request = "\(requestPrefix):\(event)"

        listenTo(self, event: request){[unowned self]
            (sender: Channel, args: RequestArguments<(A0)>) in


            let (arg0) = args.tuple!
            let result = callback(arg0)
            self.trigger(args.reply, data: result)
        }
    }


    public func request<Result, A0>(_ event: String, _ arg0: A0, callback:(Result) -> ()){
        let replyToken = createReplyToken()
        let request = "\(requestPrefix):\(event)"
        let reply = "\(replyPrefix):\(event):\(replyToken)"

        listenTo(self, event: reply){[unowned self]
            (sender: Channel, data: Result) in

            self.stopListening(self, event: reply)
            callback(data)
        }

        let args = RequestArguments(reply: reply, tuple: (arg0))
        trigger(request, args: args)
    }

    ///
    /// 2 Args
    ///

    public func reply<Result, A0, A1>(_ event: String, callback: (A0, A1) -> Result){
        let request = "\(requestPrefix):\(event)"

        listenTo(self, event: request){[unowned self]
            (sender: Channel, args: RequestArguments<(A0, A1)>) in


            let (arg0, arg1) = args.tuple!
            let result = callback(arg0, arg1)

            self.trigger(args.reply, data: result)
        }
    }


    public func request<Result, A0, A1>(_ event: String, _ arg0: A0, _ arg1: A1, callback:(Result) -> ()){
        let replyToken = createReplyToken()
        let request = "\(requestPrefix):\(event)"
        let reply = "\(replyPrefix):\(event):\(replyToken)"

        listenTo(self, event: reply){[unowned self]
            (sender: Channel, data: Result) in

            self.stopListening(self, event: reply)
            callback(data)
        }

        let args = RequestArguments(reply: reply, tuple: (arg0, arg1))
        trigger(request, args: args)
    }

}

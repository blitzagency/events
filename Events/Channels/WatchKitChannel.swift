//
//  WatchKitChannel.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public final class WatchKitChannel: Channel {

    let driver: WatchKitChannelDriver

    public init(label: String, driver: WatchKitChannelDriver) {
        self.driver = driver
        super.init(label: label)
    }

    public override func trigger(_ event: String) {
        let event = buildEvent(event, publisher: self)
        trigger(event)
    }

    public override func trigger<Data>(_ event: String, data: Data){

        guard let payload = data as? AnyObject else {
            fatalError("WatchKitChannel can only trigger data for AnyObject, got '\(data.dynamicType)'")
        }

        let event = buildEvent(event, publisher: self, data: payload)
        trigger(event)
    }

    override func trigger<T>(_ event: String, args: RequestArguments<T>){
        let event = buildEvent(event, publisher: self, data: args)
        trigger(event)
    }

    override func trigger(_ event: String, args: RequestArguments<None>){
        let event = buildEvent(event, publisher: self, data: args)
        trigger(event)
    }


    func trigger<Publisher: WatchKitChannel, Data>(_ event: EventPublisherData<Publisher, RequestArguments<Data>>){
        let payload = serializeWatchKitRequestEvent(event)
        driver.send(payload)
    }

    func trigger<Publisher: WatchKitChannel>(_ event: EventPublisherData<Publisher, RequestArguments<None>>){
        let payload = serializeWatchKitRequestEvent(event)
        driver.send(payload)
    }

    func trigger<Publisher: WatchKitChannel>(_ event: EventPublisher<Publisher>){
        let payload = serializeWatchKitEvent(event)
        driver.send(payload)
    }

    func trigger<Publisher: WatchKitChannel, Data: AnyObject>(_ event: EventPublisherData<Publisher, Data>){
        let payload = serializeWatchKitEvent(event)
        driver.send(payload)
    }

    // All of the request/reply methods intentionally go though
    // super.listenTo so as to avoid using the listenTo below
    // for use during regular events.
    public func listenTo<Publisher : EventManagerHost, Data>(_ publisher: Publisher, event: String, callback: (Publisher, Data) -> ()) {

        super.listenTo(publisher, event: event){
        (sender: Publisher, data: AnyObject) in

            guard let arg = data as? Data else {
                fatalError("WatchKitChannel unable to cast '\(data)' to requested type '\(Data.self)' for event '\(event)'")
            }

            callback(sender, arg)
        }
    }


    ///
    /// 0 Arg
    ///

    public override func reply<Result>(_ event: String, callback: () -> Result){
        let request = "\(requestPrefix):\(event)"

        super.listenTo(self, event: request){
            [unowned self]
            (sender: WatchKitChannel, args: RequestArguments<None>) in


            let result = callback()
            self.trigger(args.reply, data: result)
        }

    }

    public override func request<Result>(_ event: String, callback: (Result) -> ()){
        let replyToken = createReplyToken()
        let request = "\(requestPrefix):\(event)"
        let reply = "\(replyPrefix):\(event):\(replyToken)"


        super.listenTo(self, event: reply){
            [unowned self]
            (sender: WatchKitChannel, data: AnyObject) in

            guard let result = data as? Result else{
                fatalError("WatchKitChannel '\(sender.label)' unable to cast '\(data)' to requested type '\(Result.self)' for reply '\(reply)'")
            }

            callback(result)
            DispatchQueue.main.async {
                [unowned self] in
                self.stopListening(self, event: reply)
            }
        }

        // we need something to set the generic Type of Arguments
        // so we have a contrived marker protocol called None
        let args = RequestArguments<None>(reply: reply)
        trigger(request, args: args)
    }


    ///
    /// 1 Arg
    ///

    public override func reply<Result, A0>(_ event: String, callback: (A0) -> Result){
        let request = "\(requestPrefix):\(event)"

        super.listenTo(self, event: request){[unowned self]
            (sender: WatchKitChannel, args: RequestArguments<(AnyObject)>) in

            guard let (arg0) = args.tuple as? (A0) else{
                return
            }

            let result = callback(arg0)
            self.trigger(args.reply, data: result)
        }
    }


    public override func request<Result, A0>(_ event: String, _ arg0: A0, callback:(Result) -> ()){
        let replyToken = createReplyToken()
        let request = "\(requestPrefix):\(event)"
        let reply = "\(replyPrefix):\(event):\(replyToken)"

        super.listenTo(self, event: reply){[unowned self]
            (sender: WatchKitChannel, data: AnyObject) in

            guard let result = data as? Result else{
                fatalError("WatchKitChannel '\(sender.label)' unable to cast '\(data)' to requested type '\(Result.self)' for reply '\(reply)'")
            }

            callback(result)
            DispatchQueue.main.async {
                [unowned self] in
                self.stopListening(self, event: reply)
            }
        }

        let args = RequestArguments(reply: reply, tuple: (arg0))
        trigger(request, args: args)
    }

    ///
    /// 2 Args
    ///

    public override func reply<Result, A0, A1>(_ event: String, callback: (A0, A1) -> Result){
        let request = "\(requestPrefix):\(event)"

        super.listenTo(self, event: request){[unowned self]
            (sender: WatchKitChannel, args: RequestArguments<(AnyObject, AnyObject)>) in

            guard let arg0 = args.tuple!.0 as? A0, let arg1 = args.tuple!.1 as? A1 else{
                return
            }

            let result = callback(arg0, arg1)
            self.trigger(args.reply, data: result)
        }
    }


    public override func request<Result, A0, A1>(_ event: String, _ arg0: A0, _ arg1: A1, callback:(Result) -> ()){
        let replyToken = createReplyToken()
        let request = "\(requestPrefix):\(event)"
        let reply = "\(replyPrefix):\(event):\(replyToken)"

        super.listenTo(self, event: reply){[unowned self]
            (sender: WatchKitChannel, data: AnyObject) in

            guard let result = data as? Result else{
                fatalError("WatchKitChannel '\(sender.label)' unable to cast '\(data)' to requested type '\(Result.self)' for reply '\(reply)'")
            }

            callback(result)
            DispatchQueue.main.async {
                [unowned self] in
                self.stopListening(self, event: reply)
            }
        }

        let args = RequestArguments(reply: reply, tuple: (arg0, arg1))
        trigger(request, args: args)
    }


}

//
//  Channel+2RequestReply.swift
//  Events
//
//  Created by Adam Venturella on 7/27/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


extension Channel{

//    public func reply<Result, A0, A1>(_ event: String, callback: (A0, A1) -> Result){
//        let request = "\(requestPrefix):\(event)"
//
//        listenTo(self, event: request){[unowned self]
//            (sender: Channel, args: RequestArguments<(A0, A1)>) in
//
//        
//            let (arg0, arg1) = args.tuple!
//            let result = callback(arg0, arg1)
//
//            self.trigger(args.reply, data: result)
//        }
//    }
//
//
//    public func request<Result, A0, A1>(_ event: String, _ arg0: A0, _ arg1: A1, callback:(Result) -> ()){
//        let replyToken = createReplyToken()
//        let request = "\(requestPrefix):\(event)"
//        let reply = "\(replyPrefix):\(event):\(replyToken)"
//
//        listenTo(self, event: reply){[unowned self]
//            (sender: Channel, data: Result) in
//
//            self.stopListening(self, event: reply)
//            callback(data)
//        }
//
//        let args = RequestArguments(reply: reply, tuple: (arg0, arg1))
//        trigger(request, args: args)
//    }
}

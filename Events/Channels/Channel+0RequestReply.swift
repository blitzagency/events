//
//  Channel+0RequestReply.swift
//  Events
//
//  Created by Adam Venturella on 7/27/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation



extension Channel{

//    public func reply<Result>(_ event: String, callback: () -> Result){
//        let request = "\(requestPrefix):\(event)"
//
//        listenTo(self, event: request){
//            [unowned self]
//            (sender: Channel, args: RequestArguments<None>) in
//
//
//            let result = callback()
//            self.trigger(args.reply, data: result)
//        }
//
//    }
//
//    public func request<Result>(_ event: String, callback: (Result) -> ()){
//        let replyToken = createReplyToken()
//        let request = "\(requestPrefix):\(event)"
//        let reply = "\(replyPrefix):\(event):\(replyToken)"
//
//
//        listenTo(self, event: reply){
//            [unowned self]
//            (sender: Channel, data: Result) in
//
//            self.stopListening(self, event: reply)
//            callback(data)
//        }
//
//        // we need something to set the generic Type of Arguments
//        // so we have a contrived marker protocol called None
//        let args = RequestArguments<None>(reply: reply)
//        trigger(request, args: args)
//    }


    
    
}

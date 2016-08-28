//
//  WatchKitSerializers.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


func serializeWatchKitEvent<Publisher: WatchKitChannel>(_ event: EventPublisher<Publisher>) -> [String: Any]{
    var payload = [String: Any]()

    payload["channel"] = event.publisher.label as AnyObject
    payload["event"] = event.name as AnyObject

    return payload
}


func serializeWatchKitEvent<Publisher: WatchKitChannel, Data: Any>(_ event: EventPublisherData<Publisher, Data>) -> [String: Any]{
    var payload = [String: Any]()

    payload["channel"] = event.publisher.label
    payload["event"] = event.name
    payload["data"] =  event.data

    return payload
}


func serializeWatchKitRequestEvent<Publisher: WatchKitChannel>(_ event: EventPublisherData<Publisher, RequestArguments<None>>) -> [String: Any]{
    var payload = [String: Any]()


    payload["channel"] = event.publisher.label
    payload["event"] = event.name
    payload["request"] = ["reply": event.data.reply]

    return payload
}


func serializeWatchKitRequestEvent<Publisher: WatchKitChannel, Arg0>(_ event: EventPublisherData<Publisher, RequestArguments<(Arg0)>>) -> [String: Any]{
    var payload = [String: Any]()
    let args = [event.data.tuple!] as [Any]

    payload["channel"] = event.publisher.label as AnyObject
    payload["event"] = event.name as AnyObject
    payload["request"] = ["reply": event.data.reply, "args": args as AnyObject] as AnyObject

    return payload
}


func serializeWatchKitRequestEvent<Publisher: WatchKitChannel, Arg0, Arg1>(_ event: EventPublisherData<Publisher, RequestArguments<(Arg0, Arg1)>>) -> [String: Any]{
    var payload = [String: Any]()
    let (arg0, arg1) = event.data.tuple!
    let args = [arg0, arg1] as [Any]

    payload["channel"] = event.publisher.label as AnyObject
    payload["event"] = event.name as AnyObject
    payload["request"] = ["reply": event.data.reply, "args": args as AnyObject] as AnyObject

    return payload
}


func deserializeWatchKitRequestReply(_ data: [String: Any]) -> String{
    guard let reply = data["reply"] as? String else {
        fatalError("WatchKitChannel request must use reply's that are strings, got '\(type(of: data["reply"]))'")
    }

    return reply
}


func deserializeWatchKitRequestArgs(_ data: [String: Any]) -> [AnyObject]{
    guard let args = data["args"] as? [AnyObject] else {
        fatalError("WatchKitChannel request must use arguments that are compatible with AnyObject got '\(type(of: data["args"]))'")
    }

    return args
}


func deserializeWatchKitRequestEventNoArgs(_ data: [String: Any]) -> RequestArguments<None>{
    let reply = deserializeWatchKitRequestReply(data)

    let args = RequestArguments<None>(reply: reply)
    return args
}


func deserializeWatchKitRequestEventArgs1(_ data: [String: Any]) -> RequestArguments<(Any)> {
    let reply = deserializeWatchKitRequestReply(data)
    let args = deserializeWatchKitRequestArgs(data)

    return RequestArguments(reply: reply, tuple: (args[0]))

}


func deserializeWatchKitRequestEventArgs2(_ data: [String: Any]) -> RequestArguments<(Any, Any)> {
    let reply = deserializeWatchKitRequestReply(data)
    let args = deserializeWatchKitRequestArgs(data)

    return RequestArguments(reply: reply, tuple: (args[0], args[1]))
    
}


func deserializeWatchKitRequestEventArgs3(_ data: [String: Any]) -> RequestArguments<(Any, Any, Any)> {
    let reply = deserializeWatchKitRequestReply(data)
    let args = deserializeWatchKitRequestArgs(data)

    return RequestArguments(reply: reply, tuple: (args[0], args[1], args[2]))

}



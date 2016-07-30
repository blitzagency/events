//
//  WatchKitSerializers.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

func generatorForTuple(_ tuple: Any) -> AnyIterator<Any> {
    return AnyIterator(Mirror(reflecting: tuple).children.lazy.map { $0.value }.makeIterator())
}


func serializeWatchKitEvent<Publisher: WatchKitChannel>(_ event: EventPublisher<Publisher>) -> [String: AnyObject]{
    var payload = [String: AnyObject]()
    payload["channel"] = event.publisher.label
    payload["event"] = event.name

    return payload
}


func serializeWatchKitEvent<Publisher: WatchKitChannel, Data: AnyObject>(_ event: EventPublisherData<Publisher, Data>) -> [String: AnyObject]{
    var payload = [String: AnyObject]()
    payload["channel"] = event.publisher.label
    payload["event"] = event.name
    payload["data"] =  event.data

    return payload
}



func serializeWatchKitRequestEvent<Publisher: WatchKitChannel>(_ event: EventPublisherData<Publisher, RequestArguments<None>>) -> [String: AnyObject]{
    var payload = [String: AnyObject]()

    payload["channel"] = event.publisher.label
    payload["event"] = event.name
    payload["request"] = ["reply": event.data.reply]

    return payload
}


func serializeWatchKitRequestEvent<Publisher: WatchKitChannel, Data>(_ event: EventPublisherData<Publisher, RequestArguments<Data>>) -> [String: AnyObject]{
    var payload = [String: AnyObject]()

    var args = [AnyObject]()

    // Swift doesn't have single element tuple
    // so we initially check if the value of event.data.tuple 
    // is convertible to AnyObject (tuples are not)
    // if it is skip the iteration and move on.

    if let arg = event.data.tuple! as? AnyObject{
        args.append(arg)
    } else {
        for each in generatorForTuple(event.data.tuple!){
            guard let arg = each as? AnyObject else{
                fatalError("WatchKitChannel can only trigger data for AnyObject, got '\(each.dynamicType)'")
            }

            args.append(arg)
        }
    }

    payload["channel"] = event.publisher.label
    payload["event"] = event.name
    payload["request"] = ["reply": event.data.reply, "args": args]


    return payload
}

func deserializeWatchKitRequestReply(_ data: [String: AnyObject]) -> String{
    guard let reply = data["reply"] as? String else {
        fatalError("WatchKitChannel request must use reply's that are strings, got '\(data["reply"].dynamicType)'")
    }

    return reply
}

func deserializeWatchKitRequestArgs(_ data: [String: AnyObject]) -> [AnyObject]{
    guard let args = data["args"] as? [AnyObject] else {
        fatalError("WatchKitChannel request must use arguments that are compatible with AnyObject got '\(data["args"].dynamicType)'")
    }

    return args
}

func deserializeWatchKitRequestEventNoArgs(_ data: [String: AnyObject]) -> RequestArguments<None>{
    let reply = deserializeWatchKitRequestReply(data)

    let args = RequestArguments<None>(reply: reply)
    return args
}

func deserializeWatchKitRequestEventArgs1(_ data: [String: AnyObject]) -> RequestArguments<(AnyObject)> {
    let reply = deserializeWatchKitRequestReply(data)
    let args = deserializeWatchKitRequestArgs(data)

    return RequestArguments(reply: reply, tuple: (args[0]))

}

func deserializeWatchKitRequestEventArgs2(_ data: [String: AnyObject]) -> RequestArguments<(AnyObject, AnyObject)> {
    let reply = deserializeWatchKitRequestReply(data)
    let args = deserializeWatchKitRequestArgs(data)

    return RequestArguments(reply: reply, tuple: (args[0], args[1]))
    
}

func deserializeWatchKitRequestEventArgs3(_ data: [String: AnyObject]) -> RequestArguments<(AnyObject, AnyObject, AnyObject)> {
    let reply = deserializeWatchKitRequestReply(data)
    let args = deserializeWatchKitRequestArgs(data)

    return RequestArguments(reply: reply, tuple: (args[0], args[1], args[2]))

}



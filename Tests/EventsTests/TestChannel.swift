//
//  TestChannel.swift
//  Events
//
//  Created by Adam Venturella on 7/27/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


import XCTest
@testable import Events

class TestChannel: XCTestCase {

    func test0ArgRequest(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")

        channel.reply("lucy"){
            return "woof"
        }

        channel.request("lucy"){
            (value: String) in
            XCTAssert(value == "woof")
            done.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func test1ArgRequest(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")

        channel.reply("lucy"){ (v1: String) -> String in
            return v1
        }


        channel.request("lucy", "woof"){
            (value: String) in
            XCTAssert(value == "woof")
            done.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

    }

    func test2ArgRequest(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")

        channel.reply("lucy"){ (v1: String, v2: String) -> String in
            return "\(v1):\(v2)"
        }

        channel.request("lucy", "woof", "chaseSquirrels"){
            (value: String) in
            XCTAssert(value == "woof:chaseSquirrels")
            done.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

    }

    func testDoesNotReplyToArgumentCountMismatch(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")

        channel.reply("lucy"){
            (v1: String, v2: String) -> String in
            return "\(v1):\(v2)"
        }

        channel.request("lucy", "woof"){
            (value: String) in
            XCTFail("Should not have triggered")
        }

        delay(0.5){
            done.fulfill()
        }


        waitForExpectations(timeout: 1, handler: nil)
        
    }

    func testEventManagerHostListenToChannel(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")
        let cat = Cat(id: "1")

        cat.listenTo(channel, event: "lucy"){
            done.fulfill()
        }

        channel.trigger("lucy")

        waitForExpectations(timeout: 1, handler: nil)

    }

    func testEventManagerHostListenToChannelPublisherCallback(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")
        let cat = Cat(id: "1")

        cat.listenTo(channel, event: "lucy"){
            (sender: Channel) in
            XCTAssert(sender.channelId == channel.channelId)
            done.fulfill()
        }

        channel.trigger("lucy")

        waitForExpectations(timeout: 1, handler: nil)
        
    }

    func testEventManagerHostListenToChannelPublisherDataCallback(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")
        let cat = Cat(id: "1")

        cat.listenTo(channel, event: "lucy"){
            (sender: Channel, data: String) in

            XCTAssert(sender.channelId == channel.channelId)
            XCTAssert(data == "woof")
            done.fulfill()
        }

        channel.trigger("lucy", data: "woof")

        waitForExpectations(timeout: 1, handler: nil)
        
    }

    func testEventManagerHostListenToChannelPublisherDataCallbackExplicit(){
        let done = expectation(description: "done")
        let channel = Channel(label: "test")
        let cat = Cat(id: "1")

        let callback : (Channel, String) -> () = {
            (sender, data) in
            XCTAssert(sender.channelId == channel.channelId)
            XCTAssert(data == "woof")
            done.fulfill()
        }

        cat.listenTo(channel, event: "lucy", callback: callback)
        channel.trigger("lucy", data: "woof")

        waitForExpectations(timeout: 1, handler: nil)
        
    }

    func testEmbedded(){
        let done = expectation(description: "done")
        let driver = LocalChannelDriver()
        let channel = driver.get("test")
        let foo = Foo(channel: channel, done: done)

        channel.trigger("lucy", data: "woof")
        waitForExpectations(timeout: 1, handler: nil)
    }
}

class Foo: EventManagerHost{
    let eventManager = EventManager()
    let channel: Channel
    let done: XCTestExpectation

    lazy var onEvent: (Channel, String) -> () = {[unowned self]
        (sender, data) in
        self.done.fulfill()
    }

    init(channel: Channel, done: XCTestExpectation){
        self.channel = channel
        self.done = done
        listenTo(channel, event: "lucy", callback: onEvent)
    }
}

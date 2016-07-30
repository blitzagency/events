//
//  TestWatchChannel.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation
import XCTest
@testable import Events

class TestWatchChannel: XCTestCase {

    func test0ArgRequest(){
        let done = expectation(description: "done")
        let driver = WatchKitChannelDriver()
        let channel = driver.get("test")

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
        let driver = WatchKitChannelDriver()
        let channel = driver.get("test")

        channel.reply("lucy"){
            (a1: String) -> String in
            return a1
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
        let driver = WatchKitChannelDriver()
        let channel = driver.get("test")

        channel.reply("lucy"){
            (a1: String, a2: Int) -> String in
            return "lucy is #\(a2) at \(a1)"
        }


        channel.request("lucy", "barking", 1){
            (value: String) in
            XCTAssert(value == "lucy is #1 at barking")
            done.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
        
    }

    func testListenToParameterlessCallback(){

        let done = expectation(description: "done")
        let driver = WatchKitChannelDriver()
        let channel = driver.get("test")

        channel.listenTo(channel, event: "lucy"){
            done.fulfill()
        }

        channel.trigger("lucy")

        waitForExpectations(timeout: 1, handler: nil)
    }


    func testListenToPublisherCallback(){

        let done = expectation(description: "done")
        let driver = WatchKitChannelDriver()
        let channel = driver.get("test")


        channel.listenTo(channel, event: "lucy"){
            (sender: WatchKitChannel) in

            XCTAssert(sender.label == channel.label)
            done.fulfill()
        }

        channel.trigger("lucy")

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testListenToPublisherDataCallback(){

        let done = expectation(description: "done")
        let driver = WatchKitChannelDriver()
        let channel = driver.get("test")

        channel.listenTo(channel, event: "lucy"){
            (sender: WatchKitChannel, data: String) in

            XCTAssert(sender.label == channel.label)
            XCTAssert(data == "woof")
            done.fulfill()
        }

        channel.trigger("lucy", data: "woof")
        waitForExpectations(timeout: 1, handler: nil)
    }

}

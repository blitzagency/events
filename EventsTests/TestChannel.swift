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
        let channel = Channel(label: "test")

        channel.reply("lucy"){
            return "woof"
        }

        channel.request("lucy"){
            (value: String) in
            XCTAssert(value == "woof")
        }
    }

    func test1ArgRequest(){
        let channel = Channel(label: "test")

        channel.reply("lucy"){ (v1: String) -> String in
            return v1
        }


        channel.request("lucy", "woof"){
            (value: String) in
            XCTAssert(value == "woof")
        }

    }

    func test2ArgRequest(){
        let channel = Channel(label: "test")

        channel.reply("lucy"){ (v1: String, v2: String) -> String in
            return "\(v1):\(v2)"
        }

        channel.request("lucy", "woof", "chaseSquirrels"){
            (value: String) in
            XCTAssert(value == "woof:chaseSquirrels")
        }

    }

    func testDoesNotReplyToArgumentCountMismatch(){
        let channel = Channel(label: "test")

        channel.reply("lucy"){ (v1: String, v2: String) -> String in
            return "\(v1):\(v2)"
        }

        channel.request("lucy", "woof"){
            (value: String) in
            XCTFail("Should not have triggered")
        }
        
    }
    
}

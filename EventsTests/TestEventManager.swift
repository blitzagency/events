//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
import Events

class TestEventManager: XCTestCase {


    func testParameterlessCallback(){

        let done = expectation(description: "done")

        let m1 = EventManager()
        let m2 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            done.fulfill()
        }

        m1.trigger("lucy")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPublisherCallback(){

        let done = expectation(description: "done")

        let m1 = EventManager()
        let m2 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            (publisher: EventManager) in

            XCTAssert(publisher === m1)
            done.fulfill()
        }

        m1.trigger("lucy")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPublisherDataCallback(){

        let done = expectation(description: "done")

        let m1 = EventManager()
        let m2 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            (publisher: EventManager, data: String) in

            XCTAssert(publisher === m1)
            XCTAssert(data == "woof")
            done.fulfill()
        }
        
        m1.trigger("lucy", data: "woof")
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

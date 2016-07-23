//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
@testable import Events

class TestEventManager: XCTestCase {


    func testStopListeningToPublisher(){
        let m1 = EventManager()
        let m2 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            XCTFail("Failed to stop listening to 'lucy'")
        }

        m2.listenTo(m1, event: "woof"){
            XCTFail("Failed to stop listening to 'woof'")
        }

        guard let listener = m2.listeningTo[m1.listenId] else{
            XCTFail("Unable to locate listener for \(m1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(m1.events.count == 2)
        XCTAssert(m1.events["lucy"]!.count == 1)
        XCTAssert(m1.events["woof"]!.count == 1)

        m2.stopListening(m1)

        m1.trigger("lucy")
        m1.trigger("woof")

        XCTAssert(listener.count == 0)
        XCTAssertNil(m2.listeningTo[m1.listenId])
        XCTAssert(m1.events.count == 0)
    }

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

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


    func testStopListeningToEvent(){

        let done = expectation(description: "done")
        let m1 = EventManager()
        let m2 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            done.fulfill()
        }

        m2.listenTo(m1, event: "woof"){
            XCTFail("Failed to stop listening to 'm1.woof'")
        }

        guard let listener = m2.listeningTo[m1.listenId] else{
            XCTFail("Unable to locate listener for \(m1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(m1.events.count == 2)


        m2.stopListening(m1, event: "woof")


        XCTAssert(listener.count == 1)
        XCTAssert(m1.events.count == 1)


        m1.trigger("lucy")
        m1.trigger("woof")

        waitForExpectations(timeout: 300, handler: nil)
    }

    func testStopListening(){
        let m1 = EventManager()
        let m2 = EventManager()
        let m3 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            XCTFail("Failed to stop listening to 'm1.lucy'")
        }

        m2.listenTo(m1, event: "woof"){
            XCTFail("Failed to stop listening to 'm1.woof'")
        }

        m2.listenTo(m3, event: "chaseSquirrels"){
            XCTFail("Failed to stop listening to 'm3.chaseSquirrels'")
        }

        guard let listener = m2.listeningTo[m1.listenId] else{
            XCTFail("Unable to locate listener for \(m1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(m1.events.count == 2)
        XCTAssert(m3.events.count == 1)
        XCTAssert(m1.events["lucy"]!.count == 1)
        XCTAssert(m1.events["woof"]!.count == 1)
        XCTAssert(m3.events["chaseSquirrels"]!.count == 1)

        m2.stopListening()

        m1.trigger("lucy")
        m1.trigger("woof")
        m3.trigger("chaseSquirrels")

        XCTAssert(listener.count == 0)
        XCTAssertNil(m2.listeningTo[m1.listenId])
        XCTAssertNil(m2.listeningTo[m3.listenId])
        XCTAssert(m1.events.count == 0)
        XCTAssert(m3.events.count == 0)
    }

    func testStopListeningToPublisher(){
        let m1 = EventManager()
        let m2 = EventManager()
        let m3 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            XCTFail("Failed to stop listening to 'lucy'")
        }

        m2.listenTo(m1, event: "woof"){
            XCTFail("Failed to stop listening to 'woof'")
        }

        m2.listenTo(m3, event: "chaseSquirrels"){}

        guard let listener = m2.listeningTo[m1.listenId] else{
            XCTFail("Unable to locate listener for \(m1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(m1.events.count == 2)
        XCTAssert(m3.events.count == 1)
        XCTAssert(m1.events["lucy"]!.count == 1)
        XCTAssert(m1.events["woof"]!.count == 1)
        XCTAssert(m3.events["chaseSquirrels"]!.count == 1)

        m2.stopListening(m1)

        m1.trigger("lucy")
        m1.trigger("woof")

        XCTAssert(listener.count == 0)
        XCTAssertNil(m2.listeningTo[m1.listenId])
        XCTAssertNotNil(m2.listeningTo[m3.listenId])
        XCTAssert(m1.events.count == 0)
        XCTAssert(m3.events.count == 1)
    }

    func testListenToParameterlessCallback(){

        let done = expectation(description: "done")

        let m1 = EventManager()
        let m2 = EventManager()

        m2.listenTo(m1, event: "lucy"){
            done.fulfill()
        }

        m1.trigger("lucy")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testListenToPublisherCallback(){

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

    func testListenToPublisherDataCallback(){

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

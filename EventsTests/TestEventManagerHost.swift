//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
@testable import Events

class TestEventManagerHost: XCTestCase {


    func testStopListeningToPublisher(){
        let m1 = Cat(id: "1")
        let m2 = Cat(id: "2")

        m2.listenTo(m1, event: "ollie"){
            XCTFail("Failed to stop listening to 'ollie'")
        }

        m2.listenTo(m1, event: "meow"){
            XCTFail("Failed to stop listening to 'meow'")
        }

        let manager1 = m1.eventManager
        let manager2 = m2.eventManager

        guard let listener = manager2.listeningTo[manager1.listenId] else{
            XCTFail("Unable to locate listener for \(manager1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(manager1.events.count == 2)
        XCTAssert(manager1.events["ollie"]!.count == 1)
        XCTAssert(manager1.events["meow"]!.count == 1)

        m2.stopListening(m1)

        manager1.trigger("ollie")
        manager1.trigger("meow")

        XCTAssert(listener.count == 0)
        XCTAssertNil(manager2.listeningTo[manager1.listenId])
        XCTAssert(manager1.events.count == 0)
    }

    func testListenToEventManager(){

        let done = expectation(description: "done")

        let m1 = EventManager()
        let m2 = Cat(id: "2")

        m2.listenTo(m1, event: "meow"){
            done.fulfill()
        }

        m1.trigger("meow")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testStopListeningToEventManager(){

        let m1 = EventManager()
        let m2 = Cat(id: "2")

        m2.listenTo(m1, event: "meow"){
            XCTFail("Failed to stop listening to 'meow'")
        }

        m2.stopListening(m1)
        m1.trigger("meow")

    }

    func testParameterlessCallback(){

        let done = expectation(description: "done")

        let m1 = Cat(id: "1")
        let m2 = Cat(id: "2")

        m2.listenTo(m1, event: "meow"){
            done.fulfill()
        }

        m1.trigger("meow")
        waitForExpectations(timeout: 1, handler: nil)
    }


    func testPublisherCallback(){

        let done = expectation(description: "done")

        let m1 = Cat(id: "1")
        let m2 = Cat(id: "2")

        m2.listenTo(m1, event: "meow"){
            (cat: Cat) in
            XCTAssert(cat.id == m1.id)
            done.fulfill()
        }

        m1.trigger("meow")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPublisherDataCallback(){

        let done = expectation(description: "done")

        let m1 = Cat(id: "1")
        let m2 = Cat(id: "2")

        m2.listenTo(m1, event: "meow"){
            (cat: Cat, data: Pet) in
            XCTAssert(cat.id == m1.id)
            XCTAssert(data == .Ollie)
            done.fulfill()
        }

        m1.trigger("meow", data: Pet.Ollie)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
}

//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
@testable import Events

class TestTypedEventManagerHost: XCTestCase {


    func testStopListeningToPublisher(){
        let m1 = Dog(id: "1")
        let m2 = Dog(id: "2")

        m2.listenTo(m1, event: .Woo){
            XCTFail("Failed to stop listening to 'Woo'")
        }

        m2.listenTo(m1, event: .ChaseSquirrels){
            XCTFail("Failed to stop listening to 'ChaseSquirrels'")
        }

        let manager1 = m1.eventManager
        let manager2 = m2.eventManager

        guard let listener = manager2.listeningTo[manager1.listenId] else{
            XCTFail("Unable to locate listener for \(manager1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(manager1.events.count == 2)
        XCTAssert(manager1.events[Lucy.Woo.rawValue]!.count == 1)
        XCTAssert(manager1.events[Lucy.ChaseSquirrels.rawValue]!.count == 1)

        m2.stopListening(m1)

        manager1.trigger(.Woo)
        manager1.trigger(.ChaseSquirrels)

        XCTAssert(listener.count == 0)
        XCTAssertNil(manager2.listeningTo[manager1.listenId])
        XCTAssert(manager1.events.count == 0)
    }

    func testParameterlessCallback(){

        let done = expectation(description: "done")

        let m1 = Dog(id: "1")
        let m2 = Dog(id: "2")

        m2.listenTo(m1, event: .ChaseSquirrels){
            done.fulfill()
        }

        m1.trigger(.ChaseSquirrels)
        waitForExpectations(timeout: 1, handler: nil)
    }


    func testPublisherCallback(){

        let done = expectation(description: "done")

        let m1 = Dog(id: "1")
        let m2 = Dog(id: "2")

        m2.listenTo(m1, event: .ChaseSquirrels){
            (dog: Dog) in
            XCTAssert(dog.id == m1.id)
            done.fulfill()
        }

        m1.trigger(.ChaseSquirrels)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPublisherDataCallback(){

        let done = expectation(description: "done")

        let m1 = Dog(id: "1")
        let m2 = Dog(id: "2")

        m2.listenTo(m1, event: .ChaseSquirrels){
            (dog: Dog, data: String) in
            XCTAssert(dog.id == m1.id)
            XCTAssert(data == "Lucy")
            done.fulfill()
        }

        m1.trigger(.ChaseSquirrels, data: "Lucy")
        waitForExpectations(timeout: 1, handler: nil)
    }


}

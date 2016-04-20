//
//  EventManagerHostTests.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import XCTest
import Events

class EventManagerHostTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testListenToManager() {
        let done = self.expectationWithDescription("done")
        let manager = EventManager()

        manager.listenTo(manager, name: "foo"){
            done.fulfill()
        }

        manager.trigger("foo")
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventNoArgs(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()

        sub.listenTo(pub, "foo"){
            done.fulfill()
        }

        pub.trigger("foo")
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventSender(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()

        sub.listenTo(pub, "foo"){ (sender: MockObject) in
            done.fulfill()
        }

        pub.trigger("foo")
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventSenderValueData(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = 9

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Int) in
            XCTAssert(value == candidate)
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventSenderReferenceData(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = MockObject()

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: MockObject) in
            XCTAssert(value == candidate)
            XCTAssert(value === candidate)
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventStopListeningPubName(){
        let pub = MockObject()
        let sub = MockObject()
        let done = expectationWithDescription("done")
        var count = 0

        sub.listenTo(pub, "foo"){
            count = count + 1
        }

        pub.trigger("foo")
        sub.stopListening(pub, "foo")
        pub.trigger("foo")

        delay(0.1){
            XCTAssert(count == 1, "Expected 1 found \(count)")
            done.fulfill()
        }

        waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testEventStopListeningPub(){
        let pub1 = MockObject()
        let pub2 = MockObject()
        let sub1 = MockObject()
        let sub2 = MockObject()
        let done = expectationWithDescription("done")
        var count = 0

        sub1.listenTo(pub1, "foo"){
            count = count + 1
        }

        sub1.listenTo(pub1, "bar"){
            count = count + 1
        }

        // should remain after stopLlistening to pub1

        sub1.listenTo(pub2, "foo"){
            count = count + 1
        }

        sub2.listenTo(pub1, "foo"){
            count = count + 1
        }

        pub1.trigger("foo")
        pub1.trigger("bar")
        pub2.trigger("foo")

        sub1.stopListening(pub1)

        pub1.trigger("foo")
        pub1.trigger("bar")
        pub2.trigger("foo")

        delay(0.1){
            XCTAssert(count == 6, "Expected 6 found \(count)")
            done.fulfill()
        }

        waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testEventStopListening(){
        let pub1 = MockObject()
        let sub1 = MockObject()
        let done = expectationWithDescription("done")
        var count = 0

        sub1.listenTo(pub1, "foo"){
            count = count + 1
        }

        sub1.listenTo(pub1, "bar"){
            count = count + 1
        }

        pub1.trigger("foo")
        pub1.trigger("bar")

        sub1.stopListening()

        pub1.trigger("foo")
        pub1.trigger("bar")

        delay(0.1){
            XCTAssert(count == 2, "Expected 2 found \(count)")
            done.fulfill()
        }

        waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testEventSelf(){
        let pub1 = MockObject()
        let done = expectationWithDescription("done")
        var count = 0

        pub1.listenTo("foo"){
            count = count + 1
        }

        pub1.trigger("foo")


        pub1.stopListening()
        pub1.trigger("foo")

        delay(0.1){

            XCTAssert(count == 1, "Expected 1 found \(count)")
            XCTAssert(pub1.eventManager.listeners.count == 0, "Expected 1 found \(count)")
            done.fulfill()
        }

        waitForExpectationsWithTimeout(3.0, handler: nil)

    }

    func testEventSelfSender(){
        let pub1 = MockObject()
        let done = expectationWithDescription("done")
        var count = 0

        pub1.listenTo("foo"){ (obj: MockObject) in
            XCTAssert(obj === pub1)
            count = count + 1
        }

        pub1.trigger("foo")

        pub1.stopListening()
        pub1.trigger("foo")


        delay(0.1){
            XCTAssert(count == 1, "Expected 1 found \(count)")
            XCTAssert(pub1.eventManager.listeners.count == 0, "Expected 1 found \(count)")
            done.fulfill()
        }

        waitForExpectationsWithTimeout(3.0, handler: nil)
    }

    func testEventSelfSenderData(){
        let pub1 = MockObject()
        let done = expectationWithDescription("done")
        var count = 0

        pub1.listenTo("foo"){ (_, value: String) in
            XCTAssert(value == "ollie")
            count = count + 1
        }

        pub1.trigger("foo", data: "ollie")

        delay(0.1){
            XCTAssert(count == 1, "Expected 1 found \(count)")
            XCTAssert(pub1.eventManager.listeners.count == 1, "Expected 1 found \(count)")

            pub1.stopListening("foo")
            pub1.trigger("foo")

            delay(0.1){
                XCTAssert(pub1.eventManager.listeners.count == 0)
                XCTAssert(count == 1, "Expected 1 found \(count)")
                done.fulfill()
            }
        }

        waitForExpectationsWithTimeout(3.0, handler: nil)
        
    }

    func testEventDataOnly(){
//        let pub1 = MockObject()
//        var count = 0
//
//        pub1.listenTo("foo"){ (value: String) in
//            XCTAssert(value == "ollie")
//            count++
//        }
//
//        pub1.trigger("foo", data: "ollie")
//
//        XCTAssert(count == 1, "Expected 1 found \(count)")
//        XCTAssert(pub1.eventManager.listeners.count == 1, "Expected 1 found \(count)")
//
//        pub1.stopListening("foo")
//        pub1.trigger("foo")
//
//        XCTAssert(pub1.eventManager.listeners.count == 0)
//        XCTAssert(count == 1, "Expected 1 found \(count)")
    }
}

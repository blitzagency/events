//
//  NSNumberConversionTests.swift
//  Events
//
//  Created by Adam Venturella on 2/3/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest

class NSNumberConversionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEventDataAsNSNumberNSNumber(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: NSNumber) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberDouble(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Double) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberInt(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Int) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberInt32(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Int32) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberUInt(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: UInt) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberUInt32(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: UInt32) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberUInt64(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: UInt64) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberFloat(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Float) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberFloat32(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Float32) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func testEventDataAsNSNumberFloat64(){
        let done = expectationWithDescription("done")
        let pub = MockObject()
        let sub = MockObject()
        let candidate = NSNumber(integer: 9)

        sub.listenTo(pub, "foo"){ (sender: MockObject, value: Float64) in
            done.fulfill()
        }

        pub.trigger("foo", data: candidate)
        waitForExpectationsWithTimeout(1.0, handler: nil)
    }

}

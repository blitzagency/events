//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
import Events

class TestTypedEventManagerHost: XCTestCase {


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

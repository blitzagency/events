//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
import Events

class TestEventManagerHost: XCTestCase {


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

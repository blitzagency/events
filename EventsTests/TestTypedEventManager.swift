//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
import Events

class TestTypedEventManager: XCTestCase {


    func testParameterlessCallback(){

        let done = expectation(description: "done")

        let m1 = TypedEventManager<Pet>()
        let m2 = TypedEventManager<Fruit>()

        m2.listenTo(m1, event: .Lucy){
            done.fulfill()
        }

        m1.trigger(.Lucy)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPublisherCallback(){

        let done = expectation(description: "done")

        let m1 = TypedEventManager<Pet>()
        let m2 = TypedEventManager<Fruit>()

        m2.listenTo(m1, event: .Lucy){
            (publisher: TypedEventManager<Pet>) in

            XCTAssert(publisher === m1)
            done.fulfill()
        }

        m1.trigger(.Lucy)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPublisherDataCallback(){

        let done = expectation(description: "done")

        let m1 = TypedEventManager<Pet>()
        let m2 = TypedEventManager<Fruit>()

        m2.listenTo(m1, event: .Lucy){
            (publisher: TypedEventManager<Pet>, data: String) in

            XCTAssert(publisher === m1)
            XCTAssert(data == "Lucy")
            done.fulfill()
        }

        m1.trigger(.Lucy, data: "Lucy")
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

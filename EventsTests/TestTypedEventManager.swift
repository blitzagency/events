//
//  TestTypedEventManager.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import XCTest
@testable import Events

class TestTypedEventManager: XCTestCase {


    func testStopListeningToPublisher(){
        let m1 = TypedEventManager<Pet>()
        let m2 = TypedEventManager<Fruit>()

        m2.listenTo(m1, event: .Lucy){
            XCTFail("Failed to stop listening to 'Lucy'")
        }

        m2.listenTo(m1, event: .Ollie){
            XCTFail("Failed to stop listening to 'Ollie'")
        }

        guard let listener = m2.listeningTo[m1.listenId] else{
            XCTFail("Unable to locate listener for \(m1.listenId)")
            return
        }

        XCTAssert(listener.count == 2)
        XCTAssert(m1.events.count == 2)
        XCTAssert(m1.events[Pet.Lucy.rawValue]!.count == 1)
        XCTAssert(m1.events[Pet.Ollie.rawValue]!.count == 1)

        m2.stopListening(m1)

        m1.trigger(.Lucy)
        m1.trigger(.Ollie)

        XCTAssert(listener.count == 0)
        XCTAssertNil(m2.listeningTo[m1.listenId])
        XCTAssert(m1.events.count == 0)
    }


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

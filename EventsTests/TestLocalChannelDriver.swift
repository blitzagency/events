//
//  TestLocalChannelDriver.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation
import XCTest
@testable import Events

class TestLocalChannelDriver: XCTestCase {

    func testDefaultDriverChannel(){
        let driver = LocalChannelDriver()
        let channel1 = driver.get()
        let channel2 = driver.get()
        XCTAssert(channel1 === channel2)
    }

    func testCustomDriverChannel(){
        let driver = LocalChannelDriver()
        let channel1 = driver.get("test")
        let channel2 = driver.get("test")
        XCTAssert(channel1 === channel2)
    }
    
}

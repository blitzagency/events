//
//  RequestArguments.swift
//  Events
//
//  Created by Adam Venturella on 7/29/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


// Marker to no arguments
protocol None{}


struct RequestArguments<Tuple> {

    let tuple: Tuple?
    let reply: String

    init(reply: String, tuple: Tuple? = nil){
        self.reply = reply
        self.tuple = tuple
    }
}

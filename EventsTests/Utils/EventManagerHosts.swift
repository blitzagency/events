//
//  EventManagerHosts.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation
import Events


class Cat: EventManagerHost{
    let eventManager = EventManager()
    let id: String

    init(id: String){
        self.id = id
    }
}

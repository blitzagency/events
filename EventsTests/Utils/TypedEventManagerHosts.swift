//
//  TypedEventHosts.swift
//  Events
//
//  Created by Adam Venturella on 7/22/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation
import Events

public enum Lucy: String{
    case Woo
    case Sniff
    case Sleep
    case ChaseSquirrels
}


class Dog: TypedEventManagerHost{
    let eventManager = TypedEventManager<Lucy>()
    let id: String

    init(id: String){
        self.id = id
    }

}

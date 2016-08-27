//
//  Delay.swift
//  Events
//
//  Created by Adam Venturella on 4/20/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

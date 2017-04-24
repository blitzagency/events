//
//  RegionSegue.swift
//  Events
//
//  Created by Adam Venturella on 12/12/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation
import UIKit

class RegionEmbedSegue: UIStoryboardSegue{
    override func perform() {
        print(self.sourceViewController)
        print(self.destinationViewController)
    }
}
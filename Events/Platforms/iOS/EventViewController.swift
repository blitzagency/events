//
//  EventViewController.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation
import UIKit

public class EventViewController: UIViewController, EventManagerHost {
    public let eventManager = EventManager()

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier{
            self.trigger("segue:\(id)", data: segue.destinationViewController)
        }
    }

    deinit{
        stopListening()
    }
}
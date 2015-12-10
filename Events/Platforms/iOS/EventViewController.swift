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

    deinit{
        stopListening()
    }
}
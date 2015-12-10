//
//  EventView.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation
import AppKit

public class EventView: NSView, EventManagerHost {
    public let eventManager = EventManager()
}
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

    deinit{
        stopListening()
    }
}

public class EventViewClick: EventView{

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func mouseUp(theEvent: NSEvent) {
        if theEvent.clickCount == 1{
            onClick()
        }
    }

    func onClick(){
        trigger("click", data: self)
    }
}
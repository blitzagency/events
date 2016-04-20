//
//  EventView.swift
//  Events
//
//  Created by Adam Venturella on 12/2/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation
import UIKit

public class EventView: UIView, EventManagerHost {
    public let eventManager = EventManager()

    deinit{
        stopListening()
    }
}

public class EventViewClick: EventView{

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initClickGesture()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initClickGesture()
    }

    func initClickGesture(){
        let clickGesture = UITapGestureRecognizer(target: self, action: #selector(EventViewClick.onClick(_:)))
        addGestureRecognizer(clickGesture)
    }

    func onClick(gesture: UITapGestureRecognizer){
        trigger("click", data: self)
    }
}
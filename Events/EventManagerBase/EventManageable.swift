//
//  EventManageable.swift
//  Events
//
//  Created by Adam Venturella on 7/19/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation


public protocol EventManageable: class {
    var listenId: String {get}
    var listeningTo: [String: Listener] {get set}
    var events: [String: [HandlerBase]] {get set}
    var listeners: [String: Listener] {get set}
    var lockingQueue: DispatchQueue {get}
}

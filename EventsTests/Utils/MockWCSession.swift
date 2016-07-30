//
//  MockWCSession.swift
//  Events
//
//  Created by Adam Venturella on 7/30/16.
//  Copyright © 2016 BLITZ. All rights reserved.
//

import Foundation
import WatchConnectivity


#if TEST

public protocol WCSessionMock{
    weak var delegate: WCSessionDelegate? { get set }

    static func isSupported() -> Bool
    func activate()
    func sendMessage(_ message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Swift.Void)?, errorHandler: ((NSError) -> Swift.Void)?)
}

extension WCSession: WCSessionMock {}

public class MockWCSession: WCSession{

    public override static func isSupported() -> Bool{
        return true
    }

    public override var isReachable: Bool{
        return true
    }

    public override func activate(){
        if #available(iOSApplicationExtension 9.3, *) {
            delegate?.session(self, activationDidCompleteWith: WCSessionActivationState.activated, error: nil)
        } else {
            // Fallback on earlier versions
        }
    }

    public override func sendMessage(_ message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Swift.Void)?, errorHandler: ((NSError) -> Swift.Void)? = nil){
        delegate?.session!(self, didReceiveMessage: message)
    }
}

#endif

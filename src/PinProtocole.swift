//
//  PinProtocole.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

public enum pinViewAction: Int {
    case activatePin = 0
    case deactivatePin = 1
    case changePin = 2
    case touchIdPin = 3
    case showPin = 4
    case otherPin = 5
}


@objc public protocol PinViewControllerDataSource : class {
    ///**
    // *  Pin code for controller. Supports from 2 to 8 characters
    // */
    func codeForPinViewController() ->String
    ///**
    // *  touch id Active
    // */
    func touchIDActiveViewController() ->Bool
    @objc optional func showTouchIDVerificationImmediately() ->Bool
}

public protocol PinViewControllerValidateDelegate : class {
    /**
     *  when user set wrong pin code calling this delegate method
     */
    func pinViewControllerDidSetWrongPin(action :pinViewAction)
    /**
     *  when user set correct pin code calling this delegate method
     */
    func pinViewControllerDidSetСorrectPin(action: pinViewAction)
}


@objc public protocol PinViewControllerCreateDelegate : class {
    /**
     *  when user set new pin code calling this delegate method
     */
    func pinViewController(vc: UIViewController! , pin: String)
    
    /**
     *  when user active touchID calling this delegate method
     */
    func touchIDActive(vc: UIViewController!, active:Bool)
    
    func lengthForPin() ->NSInteger
}

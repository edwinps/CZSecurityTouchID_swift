//
//  FingerPrint.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

let kViewControllerPin = "kViewControllerPin"
let kTouchIDActive = "kTouchIDActive"
let keyCrypted = "603deb1015ca7f352c073b6108d0a30914dff4"

open class FingerPrint : PinViewControllerCreateDelegate, PinViewControllerDataSource {
    fileprivate var showTouchID:Bool!
    /**
     set the appearance of the view
     */
    public var appearance:PinAppearance!
    /**
     set length For Pin code
     */
    fileprivate var _lengthCodePin:NSInteger!
    
    // Load the AES module
    let AES = CryptoJS.AES()
    
    open static let sharedInstance: FingerPrint = {
        let instance = FingerPrint()
        // setup code
        instance.appearance = PinAppearance.defaultAppearance()
        instance.lengthCodePin = 4;
        return instance
    }()

    public var lengthCodePin: NSInteger? {
        set {
          _lengthCodePin = newValue
        }
        get {
            return _lengthCodePin
        }
    }

    
    public func createPinViewWithScope(scope:PinViewControllerScope? = .PinViewControllerScopeValidate, validationDelegate:PinViewControllerValidateDelegate) ->UIViewController
    {
        if(scope == .PinViewControllerScopeValidate && self.touchIDActiveViewController() == true){
            showTouchID = true;
        }else{
            showTouchID = false;
        }
        PinViewController.setNewAppearance(newAppearance: self.appearance)
        let vc = PinViewController.initWithScope(scope: scope!, dataSourceDelegate: self, createDelegate: self)
        vc.validateDelegate = validationDelegate;
        return vc;
    }

    public func createSettingViewWithAppearance(settingAppearance:SettingsAppearance?, pinAppearance:PinAppearance?) ->UIViewController
    {
       showTouchID = false
        let vc = SettingController.initWithSettingsAppearance(appearance: settingAppearance)
        if(pinAppearance != nil){
          vc.pinViewAppearance = pinAppearance
        }
        vc.delegate = self
        return vc
    }
    
    //MARK: - PinViewControllerCreateDelegate
    public func pinViewController(vc: UIViewController! , pin: String){
        // Encrypted the pin code
        let encrypted = pin.length > 0 ? AES.encrypt(pin, secretKey: keyCrypted) : ""
//        print("Encrypted Pin: \(encrypted)")
        let defaults = UserDefaults.standard
        defaults.set(encrypted, forKey: kViewControllerPin)
    }

    public func touchIDActive(vc: UIViewController!, active:Bool){
        let defaults = UserDefaults.standard
        defaults.set(active, forKey: kTouchIDActive)
    }
    
    public func lengthForPin() ->NSInteger{
       return _lengthCodePin
    }
    
    //MARK: - PinViewControllerDataSource
    public func codeForPinViewController() ->String {
        let defaults = UserDefaults.standard
        let pin:String? = defaults.object(forKey: kViewControllerPin) as? String
        // Decrypted the pin code
        let decrypted = pin != nil ? AES.decrypt(pin!, secretKey: keyCrypted) : ""
//        print("Decrypted Pin: \(decrypted)")
        return decrypted
    }
    
    public func touchIDActiveViewController() ->Bool {
        let defaults = UserDefaults.standard
        let active:Bool? = defaults.object(forKey: kTouchIDActive) as! Bool?
        if(active != nil){
            return active!
        }
        
        return false;
    }
    
    public func showTouchIDVerificationImmediately() ->Bool {
        return showTouchID
    }
    
}

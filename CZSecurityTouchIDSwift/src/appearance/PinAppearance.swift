//
//  PinAppearance.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

open class PinAppearance: NSObject {
    /**
     Circle fil color of numeric buttons
     */
    public var numberButtonColor: UIColor?
    /**
     Numeric buttons text color
     */
    public var numberButtonTitleColor: UIColor?
    /**
     Circle color of numeric buttons
     */
    public var numberButtonStrokeColor: UIColor?
    /**
     Circle error color
     */
    public var strokeErrorColor: UIColor?
    /**
     Numeric buttons circle width
     */
    public var numberButtonStrokeWitdh: CGFloat?
    /**
     Display Numeric buttons
     */
    public var numberButtonstrokeEnabled: Bool?
    /**
     Display Numeric buttons
     */
    public var numberButtonFont: UIFont?
    /**
     line color of delete Button
     */
    public var deleteButtonColor: UIColor?
    /**
     Circle fil color of pin code
     */
    public var pinFillColor: UIColor?
    /**
     Circle fil highlight color of pin code
     */
    public var pinHighlightedColor: UIColor?
    /**
     Circle color of pin code
     */
    public var pinStrokeColor: UIColor?
    /**
     Pin fil circle width
     */
    public var pinStrokeWidth: CGFloat?
    /**
     Pin circle width
     */
    public var pinSize: CGSize?
    /**
     title to display the first time to enter code
     default text "Enter code"
     */
    public var titleText: String?
    /**
     title to display the second time to enter code
     default text "Re-enter the code"
     */
    public var reEnterPinTitleText: String?
    /**
     title to display to create a new code
     default text "Create code"
     */
    public var createNewPinTitleText: String?
    /**
     title to display when it try to change of code
     default text "Enter the new code"
     */
    public var changeTitleText: String?
    /**
     title color
     */
    public var titleTextColor: UIColor?
    /**
     title font
     */
    public var titleTextFont: UIFont?
    /**
     sub-title to display
     default text "Passcodes did not match"
     */
    public var supportText: String?
    /**
     supportT title color
     */
    public var supportTextColor: UIColor?
    /**
     supportT title font
     */
    public var supportTextFont: UIFont?
    /**
     title to display in popup of touch id
     default text @"Put finger"
     */
    public var touchIDText: String?
    /**
     sub-title to display in popup of touch id
     default text @"Unlock App"
     */
    public var touchIDVerification: String?
    /**
     logo to display
     */
    public var logo: UIImage?
    /**
     backggroun color
     */
    public var backgroundColor: UIColor?
    
    
    open static func defaultAppearance() -> PinAppearance {
        let defaultAppearance = PinAppearance()
        return defaultAppearance
    }
    
    override init(){
        super.init()
        setupDefaultAppearance()
    }
    
    func setupDefaultAppearance() {
        let defaultTextColor = UIColor.darkGray
        let defaultColor = UIColor (colorLiteralRed: 46.0/255, green: 192.0/255, blue: 197.0/255, alpha: 1)
        let errorColor = UIColor.red
        
        let defaultTitleFont = UIFont(name: "HelveticaNeue", size:22.0)
        let defaultSupportFont = UIFont(name: "HelveticaNeue"  , size:12.0)
        let defaultFont = UIFont(name: "HelveticaNeue", size:27.0)
        
        self.numberButtonColor = defaultColor;
        self.numberButtonTitleColor = UIColor.black
        self.numberButtonStrokeColor = defaultColor;
        self.numberButtonStrokeWitdh = 0.8;
        self.numberButtonstrokeEnabled = true;
        self.numberButtonFont = defaultFont;

        self.strokeErrorColor = errorColor;
        self.deleteButtonColor = defaultColor;

        self.pinFillColor = UIColor.clear
        self.pinHighlightedColor = defaultColor;
        self.pinStrokeColor = defaultColor;
        self.pinStrokeWidth = 0.8;
        self.pinSize = CGSize(width:14.0, height:14.0)

        
        self.titleText = "Enter code";
        self.createNewPinTitleText = "Create code";
        self.reEnterPinTitleText = "Re-enter the code";
        self.changeTitleText = "Enter the new code";
        self.titleTextFont = defaultTitleFont;
        self.titleTextColor = defaultTextColor;
        
        self.supportText = "Passcode did not match, try again";
        self.supportTextFont = defaultSupportFont;
        self.supportTextColor = defaultTextColor;
        
        self.touchIDText = "Put finger";
        self.touchIDVerification = "Unlock App";
        self.logo = nil;
        self.backgroundColor = UIColor.white

    }
    
}

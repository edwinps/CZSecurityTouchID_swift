//
//  SettingsAppearance.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

open class SettingsAppearance: NSObject {
    /**
     footer to display at below of table group
     default text @"Allows the touch unlocking of the application"
     */
    public var footerGroupText: String?
    /**
     title to display at above of table group
     default text @""
     */
    public var titleGroupText: String?
    /**
     active button text
     default text @"Activate Code"
     */
    public var activateButtonText: String?
    /**
     active button color
     */
    public var activateButtonColor: UIColor?
    /**
     active button font
     */
    public var activateButtonFont: UIFont?
    /**
     Deactivate button text
     default text @"Deactivate Code"
     */
    public var deactivateButtonText: String?
    /**
     Deactivate button color
     */
    public var deactivateButtonColor: UIColor?
    /**
     Deactivate button font
     */
    public var deactivateButtonFont: UIFont?
    /**
     change button text
     default text @"Change Code"
     */
    public var changeButtonText: String?
    /**
     change button color
     */
    public var changeButtonColor: UIColor?
    /**
     change button font
     */
    public var changeButtonFont: UIFont?
    /**
     touch id button text
     default text @"Touch ID"
     */
    public var touchIDButtonText: String?
    /**
     touch id button color
     */
    public var touchIDButtonColor: UIColor?
    /**
     touch id button font
     */
    public var touchIDButtonFont: UIFont?
    
    open static func defaultAppearance() -> SettingsAppearance {
        let defaultAppearance = SettingsAppearance()
        return defaultAppearance
    }
    
    override init(){
        super.init()
        setupDefaultAppearance()
    }
    
    func setupDefaultAppearance() {
        let defaultColor = UIColor.black
        let defaultFont = UIFont(name:"HelveticaNeue" , size:17.0)
        
        self.footerGroupText = "Allows the touch unlocking of the application";
        self.titleGroupText = "";
        
        self.activateButtonText = "Activate Code";
        self.activateButtonFont = defaultFont;
        self.activateButtonColor = defaultColor;
        
        self.changeButtonText = "Change Code";
        self.changeButtonFont = defaultFont;
        self.changeButtonColor = defaultColor;
        
        self.deactivateButtonText = "Deactivate Code";
        self.deactivateButtonFont = defaultFont;
        self.deactivateButtonColor = defaultColor;
        
        self.touchIDButtonText = "Touch ID";
        self.touchIDButtonFont = defaultFont;
        self.touchIDButtonColor = defaultColor;

        
    }
    
}

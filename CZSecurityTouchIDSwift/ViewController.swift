//
//  ViewController.swift
//  CZSecurityTouchIDSwift
//
//  Created by Edwin Peña on 14/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PinViewControllerValidateDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPinAction(_ sender: UIButton) {
        let appearance = PinAppearance.defaultAppearance()
        appearance.logo = UIImage(named:"sc_logo")
        FingerPrint.sharedInstance.appearance = appearance;
        // FingerPrint.sharedInstance.lengthCodePin = 8
        let vc = FingerPrint.sharedInstance.createPinViewWithScope(scope: .PinViewControllerScopeValidate, validationDelegate: self)
        self.present(vc, animated: true)
    }
    
    @IBAction func SettingPinAction(_ sender: UIButton) {
        let appearance = PinAppearance.defaultAppearance()
        appearance.logo = UIImage(named:"sc_logo")
        // FingerPrint.sharedInstance.lengthCodePin = 8
        let vc = FingerPrint.sharedInstance.createSettingViewWithAppearance(settingAppearance: nil, pinAppearance: appearance)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - PinViewControllerValidateDelegate
    func pinViewControllerDidSetWrongPin(action :pinViewAction){
        
    }
    
    func pinViewControllerDidSetСorrectPin(action: pinViewAction){
        self.dismiss(animated: true, completion: nil)
    }
}


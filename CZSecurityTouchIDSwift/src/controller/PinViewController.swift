//
//  PinViewController.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import LocalAuthentication

public enum PinViewControllerScope {
    case PinViewControllerScopeValidate
    case PinViewControllerScopeCreate
    case PinViewControllerScopeChange
    case PinViewControllerScopeDesactive
}

class PinViewController: UIViewController, CAAnimationDelegate {
    static var appearance = PinAppearance.defaultAppearance()
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var supportLabel: UILabel?
    @IBOutlet var numberButtons: [PinButton]? = []
    @IBOutlet weak var deleteButton: UIButton?
    @IBOutlet weak var viewForPins: UIView?
    @IBOutlet weak var imageLogo: UIImageView?
    @IBOutlet weak var viewForPinsLayoutConstraint: NSLayoutConstraint!
    
    fileprivate var _appearance :PinAppearance?
    fileprivate var _scope: PinViewControllerScope?
    fileprivate var  _currentPin :String?
    fileprivate var  comfirmationPin :String?
    fileprivate var  enable = true
    fileprivate var touchIDPassedValidation = false
    fileprivate var errorPin = false
    
    weak var createDelegate : PinViewControllerCreateDelegate?
    weak var validateDelegate : PinViewControllerValidateDelegate?
    weak var dataSourceDelegate : PinViewControllerDataSource?
    
    static func initWithScope(scope: PinViewControllerScope, dataSourceDelegate:PinViewControllerDataSource?,createDelegate:PinViewControllerCreateDelegate? ) -> PinViewController {
        let pinViewControllerScopeself = PinViewController(nibName: "PinViewController", bundle: Bundle(for: PinViewController.self))
        pinViewControllerScopeself.scope = scope
        pinViewControllerScopeself.appearance = PinViewController.appearance
        pinViewControllerScopeself.dataSourceDelegate = dataSourceDelegate;
        pinViewControllerScopeself.createDelegate = createDelegate;
        pinViewControllerScopeself.viewDidLoad()
        return pinViewControllerScopeself
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    static func setNewAppearance(newAppearance: PinAppearance)
    {
        appearance = newAppearance
    }
    
    
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.navigationController?.navigationBar.topItem?.title = "";
        setupInitialState()
        clearCurrentPin()
        createPinView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.rotateTransform()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.rotateTransform()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.createPinView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (size.width / size.height <= 1) {
            self.view.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupInitialState() {
        enable = true
        touchIDPassedValidation = false
        
        if(dataSourceDelegate?.showTouchIDVerificationImmediately!() == true ){
            touchIDVerification()
        }else {
            return
        }
    }
    
    public var scope: PinViewControllerScope? {
        set {
            _scope = newValue
            viewDidLoad()
            if newValue == .PinViewControllerScopeCreate {
                self.titleLabel?.text = appearance?.createNewPinTitleText;
            }else {
                self.titleLabel?.text = appearance?.titleText;
            }
        }
        get {
            return _scope
        }
    }
    
    public var appearance: PinAppearance? {
        set {
            _appearance = newValue
        }
        get {
            return PinViewController.appearance
        }
    }
    
    func configureView() {
        
        for button in self.numberButtons! {
            button.tintColor = appearance?.numberButtonColor
            button.setTitleColor(appearance?.numberButtonTitleColor, for: UIControlState.selected)
            button.setTitleColor(appearance?.numberButtonTitleColor, for: UIControlState.highlighted)
            button.strokeColor = appearance?.numberButtonStrokeColor
            button.strokeWidth = appearance?.numberButtonStrokeWitdh
            button.strokeColor = appearance?.numberButtonstrokeEnabled! == true ? appearance?.numberButtonStrokeColor : UIColor.clear
            button.titleLabel?.font = appearance?.numberButtonFont
            button.setNeedsDisplay()
        }
        let deleteButtonImage = UIImage.init(named:"sc_img_delete", in: Bundle(for: PinViewController.self), compatibleWith: nil)
        self.deleteButton?.setImage(deleteButtonImage, for: UIControlState.normal)
        self.deleteButton?.tintColor = appearance?.deleteButtonColor
        self.titleLabel?.text = appearance?.titleText;
        self.titleLabel?.font = appearance?.titleTextFont;
        self.titleLabel?.textColor = appearance?.titleTextColor;
        self.supportLabel?.text = appearance?.supportText;
        self.supportLabel?.font = appearance?.supportTextFont;
        self.supportLabel?.textColor = appearance?.supportTextColor;
        self.supportLabel?.isHidden = true
        self.imageLogo?.image = appearance?.logo
        self.view.backgroundColor = appearance?.backgroundColor
    }
    
    func changeColorView(){
        for button in self.numberButtons! {
            button.strokeColor = errorPin == true ? appearance?.strokeErrorColor :appearance?.numberButtonStrokeColor;
            button.setNeedsDisplay()
        }
        
        for case let view as PinView in (self.viewForPins?.subviews)! {
            view.strokeColor = errorPin == true ?appearance?.strokeErrorColor : appearance?.pinStrokeColor;
            view.fillColor = errorPin == true ?appearance?.strokeErrorColor : appearance?.pinStrokeColor;
            view.highlightedColor = errorPin == true ?appearance?.strokeErrorColor : appearance?.pinHighlightedColor;
            view.setNeedsDisplay()
        }
        self.createPinView(warning: true)
        self.deleteButton?.tintColor = errorPin == true ? appearance?.strokeErrorColor : appearance?.deleteButtonColor
        self.titleLabel?.textColor = errorPin == true ? appearance?.strokeErrorColor : appearance?.titleTextColor
        self.supportLabel?.textColor = errorPin == true ? appearance?.strokeErrorColor : appearance?.supportTextColor
    }
    
    
    
    func createPinView(warning: Bool = false) {
        let length:NSInteger;
        let currentPinLength = self.currentPin?.length
        
        switch scope! {
        case .PinViewControllerScopeCreate:
            length = self.createDelegate?.lengthForPin() ?? 0
            break
        case .PinViewControllerScopeValidate:
            let pin = (self.dataSourceDelegate?.codeForPinViewController()) ?? ""
            length = pin.length
            break;
        case .PinViewControllerScopeChange:
            let pin = (self.dataSourceDelegate?.codeForPinViewController()) ?? ""
            length = pin.length
            break;
        case .PinViewControllerScopeDesactive:
            let pin = (self.dataSourceDelegate?.codeForPinViewController()) ?? ""
            length = pin.length
            break;
        }
        
        let width = appearance?.pinSize?.width ?? 0
        let distance = CGFloat(15.0);
        
        let pinWidth = (CGFloat(length) * width) + (CGFloat(length - 1) * distance);
        let center = (self.viewForPins?.frame.width)! / 2;
        var x = center - (pinWidth / 2);
        
        for view in (self.viewForPins?.subviews)! {
            view.removeFromSuperview()
        }
        
        for index in 0 ..< length {
            
            let view = PinView(frame: CGRect(x: x, y: 0, width: (appearance?.pinSize?.width)!, height: (appearance?.pinSize?.height)!))
            view.fillColor = errorPin == true || warning == true ?appearance?.strokeErrorColor : appearance?.pinFillColor;
            view.highlightedColor = errorPin == true || warning == true ? appearance?.strokeErrorColor : appearance?.pinHighlightedColor
            view.strokeColor = errorPin == true || warning == true ?appearance?.strokeErrorColor : appearance?.pinStrokeColor;
            view.strokeWidth = appearance?.pinStrokeWidth;
            
            
            if (self.touchIDPassedValidation) {
                view.highlighted = true;
            } else if (currentPinLength! <= index) {
                view.highlighted = false;
            } else {
                view.highlighted = true;
            }
            self.viewForPins?.addSubview(view)
            x = x + (distance + width)
        }
    }
    
    
    func clearCurrentPin() {
        self.currentPin = "";
    }
    
    //MARK: Controller logic
    
    func rotateTransform(){
        var rotateTransform:CGAffineTransform
        switch (UIApplication.shared.statusBarOrientation) {
        case .landscapeLeft:
            rotateTransform = CGAffineTransform(rotationAngle: CGFloat(90*M_PI/180.0))
            rotateTransform = rotateTransform.translatedBy(x: +90.0, y: +90.0);
            self.view.transform = rotateTransform
            break;
        case .landscapeRight:
            rotateTransform = CGAffineTransform(rotationAngle : CGFloat(-90*M_PI/180.0));
            rotateTransform = rotateTransform.translatedBy(x: +90.0, y: +90.0);
            self.view.transform = rotateTransform
            break;
            
        default:
            rotateTransform = CGAffineTransform(rotationAngle: 0);
            break;
        }
    }
    
    func reEnterPin(){
        self.viewDidLoad()
        self.titleLabel?.text = appearance?.reEnterPinTitleText;
    }
    
    func noMathPin(){
        wrongPin()
        self.supportLabel?.isHidden = false
    }
    
    func createNewPin(){
        _scope = .PinViewControllerScopeCreate;
        comfirmationPin = "";
        self.viewDidLoad()
        self.titleLabel?.text = appearance?.changeTitleText;
    }
    
    func appendingPincode(pincode: String){
        let appended = self.currentPin! + pincode
        var length: Int
        switch self.scope! {
        case .PinViewControllerScopeCreate:
            length = min(appended.length, (self.createDelegate?.lengthForPin())!)
            break;
            
        case .PinViewControllerScopeValidate:
            length = min(appended.length, (self.dataSourceDelegate?.codeForPinViewController())!.length)
            break;
            
        case .PinViewControllerScopeChange:
            length = min(appended.length, (self.dataSourceDelegate?.codeForPinViewController())!.length)
            break;
            
        case .PinViewControllerScopeDesactive:
            length = min(appended.length, (self.dataSourceDelegate?.codeForPinViewController())!.length)
            break;
        }
        self.currentPin = (appended as NSString).substring(to: length)
        createPinView()
    }
    
    func removeLastPincode() {
        let indexString = (self.currentPin?.length)! - 1
        if (indexString >= 0 && (self.currentPin?.length)! > indexString) {
            self.currentPin = (self.currentPin! as NSString).substring(to: indexString)
        }
        createPinView()
    }
    
    public var currentPin: String! {
        set {
            _currentPin = newValue
            setCurrentPin(currentPin: newValue)
        }
        get {
            return _currentPin
        }
    }
    func setCurrentPin(currentPin: String) {
        switch self.scope! {
        case .PinViewControllerScopeValidate:
            let equalLength = (currentPin.length == self.dataSourceDelegate?.codeForPinViewController().length && currentPin.length > 0 )
            if (equalLength == true) {
                self.validatePin(pin: currentPin)
            }
            break;
        case .PinViewControllerScopeChange:
            let equalLength = (currentPin.length == self.dataSourceDelegate?.codeForPinViewController().length)
            if (equalLength == true) {
                self.validatePin(pin: currentPin)
            }
            break;
        case .PinViewControllerScopeCreate:
            if (currentPin.length == self.createDelegate?.lengthForPin()) {
                if(comfirmationPin?.length ?? 0 > 0){
                    if(comfirmationPin == currentPin){
                        self.createDelegate?.pinViewController(vc: self, pin: comfirmationPin!)
                        comfirmationPin = ""
                    }else{
                        self.noMathPin()
                    }
                }else {
                    comfirmationPin = currentPin;
                    self.reEnterPin()
                }
                
            }
            break;
        case .PinViewControllerScopeDesactive:
            let equalLength = (currentPin.length == self.dataSourceDelegate?.codeForPinViewController().length && currentPin.length > 0 );
            if (equalLength == true) {
                self.validatePin(pin: currentPin)
            }
            break;
        }
    }
    
    func validatePin(pin :String){
        if (self.dataSourceDelegate?.codeForPinViewController() == pin) {
            self.correctPin()
            
        } else {
            self.wrongPin()
        }
    }
    
    func correctPin() {
        if(_scope == .PinViewControllerScopeChange){
            self.createNewPin()
        }else{
                if(_scope == .PinViewControllerScopeDesactive){
                    self.validateDelegate?.pinViewControllerDidSetСorrectPin(action: .deactivatePin)
                }else{
                    self.validateDelegate?.pinViewControllerDidSetСorrectPin(action: .showPin)
                }
        }
    }
    
    func wrongPin() {
        weak var weakSelf = self;
        errorPin = true;
        self.changeColorView()
        self.enable = false;
        let delay = 0.25;
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let strongSelf = weakSelf!
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            let shake = self.makeShakeAnimation()
            strongSelf.viewForPins?.layer.add(shake, forKey: "shake")
            strongSelf.validateDelegate?.pinViewControllerDidSetWrongPin(action: .showPin)
            strongSelf.clearCurrentPin()
            strongSelf.createPinView()
            strongSelf.enable = true;
        }
    }
    
    func makeShakeAnimation() ->CAAnimation {
        
        let shake = CAKeyframeAnimation(keyPath : "transform.translation.x")
        shake.setValue("shake", forKey: "makeShakeAnimation")
        shake.values = [-20, 20, -15, 15, -10, 10, -5, 5 ,0]
        shake.duration = 0.5
        shake.isAdditive = true
        shake.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shake.delegate = self
        return shake;
    }
    
    //MARK: - CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation){
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        let value:String = anim.value(forKey: "makeShakeAnimation") as! String
        if (value == "shake")
        {
            errorPin = false;
            self.changeColorView()
            self.createPinView()
            return;
        }
    }
    
    func touchIDVerification() {
        
        var error:NSError?
        let context = LAContext()
        context.localizedFallbackTitle = ""
        if context.canEvaluatePolicy (LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            weak var weakSelf = self;
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: (appearance?.touchIDVerification!)!
                , reply: { (success, authenticationError) in
                    if (success) {
                        let strongSelf = weakSelf!;
                        DispatchQueue.main.async {
                            strongSelf.touchIDPassedValidation = true;
                            strongSelf.createPinView()
                            strongSelf.validateDelegate?.pinViewControllerDidSetСorrectPin(action: .showPin)
                        }
                    } else {
                        print("Authentication Error: \(String(describing :authenticationError))");
                    }
            })
        } else {
            print("Policy Error: \(String(describing: error?.localizedDescription))");
        }
        
    }
    
    //MARK: - Actions
    @IBAction func tapPinButtonAction(_ sender: PinButton){
        if (!self.enable) {
            return;
        }
        let number = sender.tag
        self.appendingPincode(pincode:String(describing:number));
        AudioServicesPlaySystemSound(0x450);
        
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        self.removeLastPincode()
        AudioServicesPlaySystemSound(0x450);
    }
    
}

extension String {
    var length: Int { return characters.count    }
}


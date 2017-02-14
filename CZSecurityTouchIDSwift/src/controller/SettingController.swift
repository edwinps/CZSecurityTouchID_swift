//
//  SettingController.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 6/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingController: UITableViewController, CellDTODelegate,PinViewControllerValidateDelegate,PinViewControllerCreateDelegate {
    
    var appearance:SettingsAppearance?
    fileprivate var _pinViewAppearance:PinAppearance?
    
    fileprivate var footerGroupText:String! = ""
    fileprivate var titleGroupText:String! = ""
    fileprivate var activatePinText:String?
    fileprivate var deactivatePinText:String?
    fileprivate var changePinText:String?
    fileprivate var touchIDPinText:String?
    fileprivate var _dataSource = [CellDTO]()
    fileprivate var _vcPinView:PinViewController?
    fileprivate let kCellIdentifier = "SettingCell"
    weak var delegate : PinViewControllerDataSource & PinViewControllerCreateDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func initWithSettingsAppearance(appearance: SettingsAppearance?) -> SettingController {
        let settingControllerSelf = SettingController(nibName: "SettingController", bundle: Bundle(for: SettingController.self))
        var appearanceNew = appearance
        if (appearanceNew == nil) {
            appearanceNew = SettingsAppearance.defaultAppearance()
            settingControllerSelf.pinViewAppearance = PinAppearance.defaultAppearance()
        }
        settingControllerSelf.appearance = appearanceNew;
        return settingControllerSelf
    }
    
    public var vcPinView: PinViewController? {
        set {
            _vcPinView = newValue
            _vcPinView!.dataSourceDelegate = delegate;
        }
        get {
            if (_vcPinView == nil) {
                _vcPinView = PinViewController.initWithScope(scope: .PinViewControllerScopeCreate , dataSourceDelegate: delegate, createDelegate: self)
                self.vcPinView = _vcPinView
            }
            return _vcPinView
        }
    }
    
    public var pinViewAppearance: PinAppearance? {
        set {
            _pinViewAppearance = newValue
            if(_pinViewAppearance == nil){
                _pinViewAppearance = PinAppearance.defaultAppearance()
            }
            PinViewController.setNewAppearance(newAppearance: _pinViewAppearance!)
        }
        get {
            return _pinViewAppearance
        }
    }
    
    public var dataSource: [CellDTO] {
        set {
            _dataSource = newValue
            self.tableView.reloadData()
        }
        get {
            return _dataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: kCellIdentifier, bundle: Bundle(for: SettingController.self)), forCellReuseIdentifier: kCellIdentifier)
        self.configureView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        footerGroupText = ""
        titleGroupText = appearance?.titleGroupText
        
        var error:NSError?;
        let context = LAContext()
        var arrayButtons = Array<CellDTO>()
        
        let changeCodeButton = CellDTO().initWithId(identifier: .changePin, appearance: appearance!, delegate: nil)
        let tochIDButton = CellDTO().initWithId(identifier: .touchIdPin, appearance: appearance!, delegate: self)
        if (self.delegate?.codeForPinViewController() != nil &&  self.delegate!.codeForPinViewController().length  > 0){
            let deactiveButton = CellDTO().initWithId(identifier: .deactivatePin, appearance: appearance!, delegate: nil)
            arrayButtons.append(deactiveButton)
        }else{
            let activeButton = CellDTO().initWithId(identifier: .activatePin, appearance: appearance!, delegate: nil)
            arrayButtons.append(activeButton)
            changeCodeButton.enableCell = false;
            tochIDButton.enableCell = false;
        }
        arrayButtons.append(changeCodeButton)
        
        if context.canEvaluatePolicy (LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            tochIDButton.switchOn = delegate?.touchIDActiveViewController() ?? false
            arrayButtons.append(tochIDButton)
            footerGroupText = appearance?.footerGroupText
            
        }
        self.dataSource = arrayButtons
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:SettingCell? = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as? SettingCell
        if (cell == nil) {
            cell = SettingCell(style: .default, reuseIdentifier: kCellIdentifier)
        }
        cell!.cellDTO = dataSource[indexPath.row]
        cell!.delegate = self;
        return cell!;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titleGroupText
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        return footerGroupText
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        let cellDTO = dataSource[indexPath.row]
        
        if(cellDTO.cellDTOIdentifier == .activatePin){
            createPinAction()
        }else if (cellDTO.cellDTOIdentifier == .deactivatePin){
            desactivePinAction()
        }else if (cellDTO.cellDTOIdentifier == .changePin){
            changePinAction()
        }
    }
    
    func showPinAction() {
        vcPinView?.scope = .PinViewControllerScopeValidate
        self.navigationController?.pushViewController(vcPinView!, animated: true)
    }
    
    func changePinAction() {
        vcPinView?.scope = .PinViewControllerScopeChange
        self.navigationController?.pushViewController(vcPinView!, animated: true)
    }
    
    
    func createPinAction() {
        vcPinView?.scope = .PinViewControllerScopeCreate
        self.navigationController?.pushViewController(vcPinView!, animated: true)
    }
    
    func desactivePinAction() {
        vcPinView?.scope = .PinViewControllerScopeDesactive
        self.navigationController?.pushViewController(vcPinView!, animated: true)
        
    }
    
    //MARK: - CellDTODelegate
    func cellTouchId(cell: SettingCell, actvie:Bool){
        delegate?.touchIDActive(vc: self, active: actvie)
    }
    
    //MARK: - PinViewControllerValidateDelegate
    
    func pinViewControllerDidSetWrongPin(action :pinViewAction){
        
    }
    
    func pinViewControllerDidSetСorrectPin(action: pinViewAction){
        if(action == .deactivatePin){
            delegate?.touchIDActive(vc: self, active: false)
            delegate?.pinViewController(vc: self , pin:"")
            configureView()
        }
        if(action != .otherPin){
            _ = self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - PinViewControllerCreateDelegate
    func pinViewController(vc: UIViewController! , pin: String){
        _ = self.navigationController?.popViewController(animated: true)
        delegate?.pinViewController(vc: vc , pin: pin)
        configureView()
    }
    
    func touchIDActive(vc: UIViewController!, active:Bool){
        delegate?.touchIDActive(vc: vc, active: active)
    }
    
    func lengthForPin() ->NSInteger{
        return delegate?.lengthForPin() ?? 4
    }
}

//
//  SettingCell.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

protocol CellDTODelegate : class {
    func cellTouchId(cell: SettingCell, actvie:Bool)
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var titleText:UILabel!
    @IBOutlet weak var switchButton:UISwitch!
    fileprivate var _cellDTO:CellDTO?
    var delegate:CellDTODelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.switchButton?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        if(delegate?.cellTouchId(cell: self, actvie: (switchButton?.isOn)!) != nil){
            delegate?.cellTouchId(cell: self, actvie: (switchButton?.isOn)!)
        }
    }
    
    public var cellDTO: CellDTO? {
        set {
          _cellDTO = newValue
            self.switchButton?.isHidden = _cellDTO?.switchHidden! ?? true
            switchButton?.setOn(_cellDTO?.switchOn ?? false, animated: true)
            
            if(_cellDTO != nil &&  !cellDTO!.enableCell!){
                self.isUserInteractionEnabled = false;
                self.selectionStyle = UITableViewCellSelectionStyle.none;
                self.contentView.alpha = 0.5;
            }else{
                self.isUserInteractionEnabled = true;
                self.selectionStyle = UITableViewCellSelectionStyle.default;
                self.contentView.alpha = 1;
            }
            if(_cellDTO?.cellDTOIdentifier == .activatePin){
                titleText.text = _cellDTO?.appearance?.activateButtonText;
                titleText.font = _cellDTO?.appearance?.activateButtonFont;
                titleText.textColor = _cellDTO?.appearance?.activateButtonColor;
            }else if(_cellDTO?.cellDTOIdentifier == .deactivatePin){
                titleText.text = _cellDTO?.appearance?.deactivateButtonText;
                titleText.font = _cellDTO?.appearance?.deactivateButtonFont;
                titleText.textColor = _cellDTO?.appearance?.deactivateButtonColor;
            }else  if(_cellDTO?.cellDTOIdentifier == .changePin){
                titleText.text = _cellDTO?.appearance?.changeButtonText;
                titleText.font = _cellDTO?.appearance?.changeButtonFont;
                titleText.textColor = _cellDTO?.appearance?.changeButtonColor;
            }else  if(_cellDTO?.cellDTOIdentifier == .touchIdPin){
                titleText.text = _cellDTO?.appearance?.touchIDButtonText;
                titleText.font = _cellDTO?.appearance?.touchIDButtonFont;
                titleText.textColor = _cellDTO?.appearance?.touchIDButtonColor;
                self.selectionStyle = UITableViewCellSelectionStyle.none
            }
        }
        get {
            return _cellDTO
        }
    }
    func setCellDTO(cellDTO:CellDTO){
        self.cellDTO = cellDTO
        
    }
}

//
//  CellDTO.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import Foundation

class CellDTO: NSObject {
    var appearance: SettingsAppearance?
    var enableCell: Bool?
    var switchHidden: Bool?
    var cellDTOIdentifier: pinViewAction?
    var delegate: CellDTODelegate?
    var switchOn: Bool?
    
    override init(){
        super.init()
    }
    
    func initWithId(identifier:pinViewAction,appearance: SettingsAppearance,delegate: CellDTODelegate?) -> CellDTO {
        let cellDTO = CellDTO()
        cellDTO.cellDTOIdentifier = identifier;
        cellDTO.appearance = appearance;
        cellDTO.delegate = delegate;
        cellDTO.enableCell = true;
        if(delegate != nil){
            cellDTO.switchHidden = false;
        }else{
            cellDTO.switchHidden = true;
        }
        return cellDTO
    }
}

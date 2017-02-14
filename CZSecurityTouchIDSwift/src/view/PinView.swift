//
//  PinView.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 2/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

class PinView: UIView {
    var fillColor:UIColor!
    var highlightedColor:UIColor!
    var strokeColor:UIColor!
    var strokeWidth:CGFloat!
    var highlighted:Bool!
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        applyDefautlAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDefautlAttributes() {
        self.backgroundColor = UIColor.clear
        self.fillColor = UIColor.red
        self.strokeColor = UIColor.blue
        self.strokeWidth = 0.5;
        self.highlighted = true;
        self.highlightedColor  = UIColor.green
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPathRect = CGRect(x: self.strokeWidth, y: self.strokeWidth,width: rect.width - (self.strokeWidth * 2), height: rect.height - (self.strokeWidth * 2))
        let ovalPath = UIBezierPath(ovalIn :bezierPathRect)
        if self.highlighted == true {
            self.highlightedColor.setFill()
        }else{
            self.fillColor.setFill()
        }
        ovalPath.fill()
        self.strokeColor.setStroke()
        ovalPath.lineWidth = self.strokeWidth
        ovalPath.stroke()
    }
}

//
//  PinButton.swift
//  T21FingerPrintSwift
//
//  Created by Edwin Peña on 1/2/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

import UIKit

class PinButton: UIButton {
    private var _strokeColor:UIColor?
    private var _strokeWidth:CGFloat?
    
    public var strokeColor: UIColor? {
        set {
            _strokeColor = newValue
            setNeedsDisplay()
        }
        get {
            return _strokeColor
        }
    }
    
    public var strokeWidth: CGFloat? {
        set {
            _strokeWidth = newValue
            setNeedsDisplay()
        }
        get {
            return _strokeWidth
        }
    }
    
    override var isHighlighted: Bool {
       set {
            if (super.isHighlighted != newValue) {
                super.isHighlighted = newValue;
                self.setNeedsDisplay()
            }
            
        }
        get {
            return super.isHighlighted
        }
    }


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let height = rect.height
        let rectInset = CGRect(x: 0, y: 0,width: height, height: height)
        let inset  = rectInset.insetBy(dx: 1,dy: 1)
        let context = UIGraphicsGetCurrentContext();
        let colorRef  = self.tintColor.cgColor
        let strokecolorRef  = strokeColor?.cgColor;
        let state = self.state;
        
        context!.setLineWidth(self.strokeWidth!)
        if (state == .highlighted) {
            context!.setFillColor(colorRef)
            context!.fillEllipse(in: inset)
            context!.fillPath()
        }
        else {
            context!.setStrokeColor(strokecolorRef!)
            context!.addEllipse(in: inset)
            context!.strokePath()
        }
        
    }
    
}

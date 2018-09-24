//
//  JABLEPopupView.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class JABLEPopupView: UIView {

    convenience init() {
        self.init(frame: CGRect.zero)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    internal func initView(){
        //set properties and add subviews
        self.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        //set frames
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
            cornerRadii: CGSize(width: 25, height: 25)).cgPath
        self.layer.mask = maskLayer
    }
}

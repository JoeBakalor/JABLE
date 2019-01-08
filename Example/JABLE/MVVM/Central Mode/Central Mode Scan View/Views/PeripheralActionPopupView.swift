//
//  PeripheralActionPopupView.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 1/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class PeripheralActionPopupView: UIView {
    
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

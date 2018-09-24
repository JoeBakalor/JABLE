//
//  GATTTableView.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class GATTView: UIView {
    
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
        //SET PROPERTIES FOR AND ADD SUBVIEWS

    }
    
    override func layoutSubviews() {
        
        //SET LAYOUT FOR SUBVIEWS
        super.layoutSubviews()
    }
    
}

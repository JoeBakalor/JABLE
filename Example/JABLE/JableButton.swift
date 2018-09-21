//
//  JableButton.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class JableButton: UIButton {
    
    var borderColor:UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
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
    convenience init(type buttonType: UIButtonType){
        self.init(frame: CGRect.zero)
        self.initView()
    }
    
    internal func initView(){
        self.setTitleColor(.black, for: .normal)
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10//Style.shared.cornerRadius
        self.layer.borderWidth = 4//Style.shared.borderWidth
        self.sizeToFit()
        
        self.addTarget(self, action: #selector(buttonSetSelected), for: .touchDown)
        self.addTarget(self, action: #selector(buttonSetSelected), for: .touchDragEnter)
        self.addTarget(self, action: #selector(buttonSetUnselected), for: .touchDragOutside)
        self.addTarget(self, action: #selector(buttonSetUnselected), for: .touchCancel)
        self.addTarget(self, action: #selector(buttonSetUnselected), for: .touchDragExit)
        self.addTarget(self, action: #selector(buttonSetUnselected), for: .touchUpInside)
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        self.frame = self.frame.insetBy(dx: -18.0, dy: -6)
    }
    
    @objc func buttonSetSelected(){
        self.backgroundColor = borderColor
        self.setTitleColor(.white, for: .normal)
    }
    
    @objc func buttonSetUnselected(){
        self.backgroundColor = .white
        self.setTitleColor(borderColor, for: .normal)
    }
    
}

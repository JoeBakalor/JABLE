//
//  GattServiceTableViewCell.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class GattTableSectionHeaderView: UIView{
    
    var sectionTitle: String?
    let expandButton = UIButton()
    var buttonSelected = false
    
    var tagNumber: Int?{
        didSet{
            guard let tag = tagNumber else { return }
            expandButton.tag = tag
        }
    }
    
    @objc var buttonHandler: ((UIButton) -> Void)?
    
    func setButtonHandler(handler: @escaping ((UIButton) -> Void)){
        self.buttonHandler = handler
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
    
    internal func initView(){
        //SET PROPERTIES FOR AND ADD SUBVIEWS
        expandButton.addTarget(self, action: #selector(handlePress), for: .touchDown)
        self.addSubview(expandButton)
    }
    
    override func layoutSubviews() {
        
        //SET LAYOUT FOR SUBVIEWS
        super.layoutSubviews()
        expandButton.backgroundColor = UIColor.blue
        expandButton.frame = self.bounds
    }
    
    @objc func handlePress(){
        self.buttonHandler?(self.expandButton)
    }
}


/*
class GattTableSecionHeaderView: UIView{
    
    var button: MenuNodeButton?
    var baseLayerView: UIView?
    var sectionTitle: String?
    var tagNumber: Int?
    var sectionColor: UIColor = UIColor.gray
    var headerImage: UIImage?
    var spaceConstrainedDisplayMode: Bool = false
    
    @objc var buttonHandler: ((UIButton) -> Void)?
    func setButtonHandler(handler: @escaping ((UIButton) -> Void)){
        self.buttonHandler = handler
    }
    
    var pressedButtonOrigin: CGPoint?
    var raisedButtonOrigin: CGPoint?
    var buttonSelected = false
    
    override func draw(_ rect: CGRect) {
        
        let borderWidth = rect.height*0.1
        let buttonBorderWidth = rect.height*0.075
        let buttonCornerRadii = rect.height*0.175
        
        let buttonBaseLayerSize = CGSize(width: rect.width - borderWidth*4, height: rect.height -  borderWidth*2)
        let buttonBaseLayerOrigin = CGPoint(x: rect.origin.x /*+ borderWidth*/, y: rect.origin.y + borderWidth*1.4)
        pressedButtonOrigin = buttonBaseLayerOrigin
        baseLayerView = UIView(frame: CGRect(origin: buttonBaseLayerOrigin, size: buttonBaseLayerSize))
        baseLayerView?.backgroundColor = UIColor.clear
        let baseLayerGradient = CAGradientLayer()
        baseLayerGradient.colors = [UIColor.white.cgColor, UIColor.lightGray.cgColor]
        baseLayerGradient.frame = (baseLayerView?.bounds)!
        baseLayerGradient.startPoint = CGPoint.zero;
        baseLayerGradient.endPoint = CGPoint(x: 1, y: 1)// CGPointMake(1, 1);
        baseLayerView?.layer.addSublayer(baseLayerGradient)
        baseLayerView?.layer.cornerRadius = buttonCornerRadii//12
        baseLayerView?.clipsToBounds = true
        baseLayerView?.layer.borderWidth = buttonBorderWidth//5
        baseLayerView?.layer.borderColor = UIColor.black.cgColor
        self.addSubview(baseLayerView!)
        
        let buttonSize = CGSize(width: rect.width - borderWidth*4, height: rect.height -  borderWidth*2)
        let buttonOrigin = CGPoint(x: rect.origin.x + borderWidth*1.4, y: rect.origin.y)// + borderWidth)
        raisedButtonOrigin = buttonOrigin
        
        button = MenuNodeButton(frame: CGRect(origin: buttonSelected ? buttonBaseLayerOrigin : buttonOrigin, size: buttonSize))
        button?.spaceConstrainedDisplayMode = self.spaceConstrainedDisplayMode
        button?.buttonLabel = sectionTitle!
        button?.buttonIcon = headerImage!
        button?.layer.cornerRadius = buttonCornerRadii//12
        button?.clipsToBounds = true
        button?.layer.borderWidth = buttonBorderWidth//rect.height*0.01
        button?.layer.borderColor = UIColor.black.cgColor
        button?.backgroundColor = sectionColor
        button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button?.addTarget(self, action: #selector(handlePress), for: .touchDown)
        
        if let tagNum = tagNumber{
            button?.tag = tagNum
        }
        self.addSubview(button!)
    }
    
    @objc func handlePress(){
        self.buttonHandler?(self.button!)
        
        guard let raisedButtonPosition = raisedButtonOrigin, let pressedButtonPostion = pressedButtonOrigin else { return }
        
        if buttonSelected{
            
            UIView.animate(withDuration: 0.25) {
                self.button?.frame.origin = raisedButtonPosition
            }
            buttonSelected = false
            
        } else{
            
            UIView.animate(withDuration: 0.25) {
                self.button?.frame.origin = pressedButtonPostion
            }
            buttonSelected = true
        }
        
    }
    
    override func prepareForInterfaceBuilder() {
        //button?.setTitleColor(UIColor.white, for: .normal)
    }
    
}
*/

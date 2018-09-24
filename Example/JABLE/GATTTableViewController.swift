//
//  GATTTableViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


class GATTTableViewController: UIView {
    
    let maskLayer = CAShapeLayer()
    let borderShape = CAShapeLayer()
    let gattTableView =  UITableView(frame: CGRect(), style: .grouped)
    
    let gattTableViewModel = GATTTableViewModel()
    lazy var gattTableData = gattTableViewModel.gattTableData
    
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
        borderShape.strokeColor = UIColor.black.cgColor
        borderShape.fillColor = nil;
        borderShape.lineWidth = self.bounds.height*0.015
        gattTableView.separatorStyle = .none
        gattTableView.backgroundColor = UIColor.clear
        gattTableView.delegate = self
        gattTableView.dataSource = self
        
        self.layer.addSublayer(borderShape)
        self.addSubview(gattTableView)
    }
    
    override func layoutSubviews() {
        //SET LAYOUT FOR SUBVIEWS
        super.layoutSubviews()
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        borderShape.frame = self.bounds
        borderShape.path = maskPath.cgPath
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section with TAG...\(button.tag)")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        
        guard let indices = gattTableData[section].sectionData.service.characteristics?.indices else { return }
        
        for row in indices{//.nodes.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = gattTableData[section].isExpanded
        gattTableData[section].isExpanded = !gattTableData[section].isExpanded
        
        if isExpanded {
            gattTableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            gattTableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    
}


extension GATTTableViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gattTableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !gattTableData[section].isExpanded{ return 0 }
        guard let rowCount = gattTableData[section].sectionData.service.characteristics?.count else { return 0}
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GATTTableViewCell()
        guard let uuid = gattTableData[indexPath.section].sectionData.service.characteristics?[indexPath.row].uuid else { return cell }
        cell.titleText = "\(uuid)"
        return cell
    }
    
}

extension GATTTableViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let view = customHeaderView()
        let view = GattTableSectionHeaderView()
        
        //view.spaceConstrainedDisplayMode = self.spaceConstrainedDisplayMode
        //view.button?.setTitleColor(UIColor.white, for: .normal)
        //view.sectionColor = tableSectionsArray[section].nodeGroupAccentColor//nodeHiglightColorArray[section]
        //view.headerImage = tableSectionsArray[section].sectionImage != nil ? tableSectionsArray[section].sectionImage! : #imageLiteral(resourceName: "teknikioLogo")
        
        if gattTableData[section].isExpanded{
            view.buttonSelected = true
        } else {
            view.buttonSelected = false
        }
        
        view.setButtonHandler { (buttonPressed) in
            self.handleExpandClose(button: buttonPressed)
        }
        
        view.tagNumber = section
        
        view.sectionTitle = "\(gattTableData[section].sectionData.service.uuid)"//.nodeGroupName//sectionHeaders[section]
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    /* Header heights */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.frame.height*0.11
    }
    
    /*  Row heights */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height*0.11
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}
/*
class customHeaderView: UIView{
    
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

class NodeButton: UIButton{
    
    override func draw(_ rect: CGRect) {
        
    }
    
}

*/





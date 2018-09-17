//
//  SideNavigationViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

import UIKit

class SideNavigationViewControllerNew: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sectionSpace:CGFloat = 30
    
    var delegate: TeknestNavigation?
    
    let titles = [
        "Peripheral Scan",
        "GATT Profile",
        //"My Inventions",
        //"Browse Projects",
        //"Browse Lessons",
        //"Log out",
        //"Help",
        //"Bluebirds",
        //"Update"
        //"Browse Projects",
        //"Browse Lessons",
        //"Log out",
        //"Help"
        //"Devices",
        //"Update"
    ]
    
    let tableView = UITableView()
    let backgroundView = UIImageView()
    
    let backgroundRoundRects = [CAShapeLayer(), CAShapeLayer()]
    let backgroundLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //backgroundView.image = #imageLiteral(resourceName: "teknikioBackground")
        backgroundView.contentMode = .scaleAspectFill
        tableView.backgroundView = backgroundView
        tableView.separatorStyle = .none
        
        backgroundRoundRects.forEach({
            backgroundLayer.addSublayer($0)
            $0.fillColor = UIColor.white.withAlphaComponent(0.666).cgColor
        })
        
        self.view.addSubview(tableView)
        tableView.layer.addSublayer(backgroundLayer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backgroundView.frame = self.view.bounds
        self.tableView.frame = self.view.bounds
        if tableView.numberOfSections != 2{ return }
        for i in 0..<tableView.numberOfSections{
            let firstIndex = IndexPath(row: 0, section: i)
            let lastIndex = IndexPath(row: tableView.numberOfRows(inSection: i)-1, section: i)
            let firstRect = tableView.rectForRow(at: firstIndex)
            let lastRect = tableView.rectForRow(at: lastIndex)
            let rect = CGRect(x: 20, y: firstRect.origin.y, width: self.view.frame.size.width-40, height: lastRect.origin.y - firstRect.origin.y + lastRect.size.height + CGFloat(15*(tableView.numberOfRows(inSection: i)-1)))
            backgroundRoundRects[i].path = UIBezierPath.init(roundedRect: rect, cornerRadius: 12).cgPath
        }
        backgroundLayer.removeFromSuperlayer()
        tableView.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{ return 0 }
        return sectionSpace
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{ return nil }
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0: return 200 * 0.5
        default: return 60
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        backgroundLayer.removeFromSuperlayer()
        tableView.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = SideNavigationTableViewCell()
            cell.titleText = titles[indexPath.row]
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        default:
            switch indexPath.row{
            case 0: delegate?.peripheralScanRequested()
            case 1: delegate?.gattProfileRequested()
            default: break
            }
        }
    }
    
}

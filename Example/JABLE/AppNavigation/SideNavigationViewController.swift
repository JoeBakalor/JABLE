//
//  SideNavigationViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

let USE_NEW_NAV = true

class SideNavigationViewControllerNew: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sectionSpace:CGFloat = 30
    
    var delegate: TeknestNavigation?
    
    let titles = [
        "Central Mode",
        "Peripheral Mode",
        "OTA Updates",
        "Help"
    ]
    
    let tableView               = UITableView()
    let backgroundView          = UIImageView()
    let backgroundRoundRects    = [CAShapeLayer(), CAShapeLayer()]
    let backgroundLayer         = CALayer()
    
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
            $0.fillColor = UIColor.white.withAlphaComponent(0.75).cgColor
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
        
        if USE_NEW_NAV{
            return 2
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if USE_NEW_NAV{
            switch section{
            case 0: return 1
            default: return titles.count
            }
        } else {
            return titles.count
        }
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
        
        if USE_NEW_NAV{
            switch indexPath.section {
            case 0:
                let cell = NavigationHeaderViewCell()
                //cell.imageView?.image = #imageLiteral(resourceName: "alpaca")
                return cell
            default:
                let cell = SideNavigationTableViewCell()
                cell.titleText = titles[indexPath.row]
                return cell
            }
        } else {
            let cell = SideNavigationTableViewCell()
            cell.titleText = titles[indexPath.row]
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if USE_NEW_NAV{
            switch indexPath.section {
            case 0: break
            default:
                switch indexPath.row{
                case 0: delegate?.centralModeRequested()
                case 1: delegate?.peripheralModeRequested()
                default: break
                }
            }
        } else {
            print("Side menu item selected ")
            switch indexPath.row{
            case 0: delegate?.centralModeRequested()
            case 1: delegate?.peripheralModeRequested()
            default: break
            }
        }
    }
    
}
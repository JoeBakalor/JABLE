//
//  AppNavigationController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

//
//  AppNavigationController.swift
//  Teknest
//
//  Created by Robby Kraft on 9/13/18.
//  Copyright © 2018 Joe Bakalor. All rights reserved.
//

import UIKit

protocol TeknestNavigation {
    func centralModeRequested()
    func peripheralModeRequested()
    func otaUpdatesRequested()
//    func dashboardRequested()
//    func myInventionsRequested()
//    func devicesRequested()
//    func browseProjectsRequested()
//    func browseLessonsRequested()
//    func helpRequested()
//    func demoRequested()
//    func updatesRequested()
}

class AppNavigationController: UINavigationController {
    
    let sideNavigation = SideNavigationViewControllerNew()
    let blurView = UIVisualEffectView()
    let sideNavHideOrigin = CGPoint(x: -400, y: 0)
    
    @objc func sideMenuButtonDidPress(){
        showSideMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background for navigation bar
        let navbarHeight:CGFloat = 44
        let statusBarView = UIView(frame: CGRect(x:0, y:0, width:view.frame.size.width, height: UIApplication.shared.statusBarFrame.height + navbarHeight))
        let blurEffect = UIBlurEffect(style: .extraLight) // Set any style you want(.light or .dark) to achieve different effect.
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = statusBarView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        statusBarView.addSubview(blurEffectView)
        self.view.insertSubview(statusBarView, belowSubview: self.navigationBar)
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        
        if #available(iOS 10.0, *) {
            blurView.effect = UIBlurEffect(style: .regular)
        } else {
            // Fallback on earlier versions
        }
        
        blurView.frame = self.view.bounds
        blurView.alpha = 0.0
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(hideSideMenu))
        blurView.addGestureRecognizer(tap)
        
        sideNavigation.delegate = self
        
        self.view.addSubview(blurView)
        self.view.addSubview(sideNavigation.view)
        
        sideNavigation.view.frame = CGRect(origin: sideNavHideOrigin, size: CGSize(width: 360, height: self.view.bounds.size.height))
    }
    
    @objc func hideSideMenu(){
        UIView.beginAnimations(nil, context: nil)
        blurView.alpha = 0.0
        sideNavigation.view.frame.origin = sideNavHideOrigin
        UIView.commitAnimations()
    }
    @objc func showSideMenu(){
        UIView.beginAnimations(nil, context: nil)
        blurView.alpha = 1.0
        sideNavigation.view.frame.origin = CGPoint.zero
        UIView.commitAnimations()
    }
    
    
}

extension AppNavigationController: TeknestNavigation {

    func load(_ viewController:UIViewController){
        self.setViewControllers([viewController], animated: true)
        hideSideMenu()
    }
    
    func centralModeRequested() {
        print("Peripheral scan view requested ")
        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "centralModeScanViewController"))
    }
    
    func peripheralModeRequested() {
        print("Gatt profile view requested ")
        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "gattProfileViewController"))
    }
    
    func otaUpdatesRequested() {
        print("OTA view requested ")
        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "otaUpdatesViewController"))
    }
    
//    func dashboardRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "newDashboardViewController"))
//    }
//    func devicesRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "devicesViewController"))
//    }
//    func updatesRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "otaViewController"))
//    }
//    func myInventionsRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "myInventionsViewController"))
//    }
//    func browseProjectsRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browseProjectsViewController"))
//    }
//    func browseLessonsRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browseLessonsViewController"))
//    }
//    func helpRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "helpViewController"))
//    }
//    func demoRequested() {
//        load(UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "demoViewController"))
//    }
    
    //    func dashboardRequested() { load(NewDashboardViewController()) }
    //    func myInventionsRequested() {  load(MyInventionsViewController()) }
    //    func devicesRequested() { load(DevicesViewController()) }
    //    func browseProjectsRequested() { load(BrowseProjectsViewController()) }
    //    func browseLessonsRequested() { load(BrowseLessonsViewController()) }
    //    func helpRequested( ){ load(HelpViewController()) }
    //    func demoRequested() { load(DemoViewController()) }
    //    func updatesRequested() {}
    
}

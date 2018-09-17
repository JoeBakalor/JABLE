//
//  HomeViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation



import UIKit

var testLogin = true

@objc protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}


/*  TEMPORARY HACK */
protocol TemporarySwitchToInventionBuilderDelegte {
    func bringUpInventionBuilder()
}

var bringUpInventionDelegate: TemporarySwitchToInventionBuilderDelegte?
/**/

class HomeViewController: UIViewController {
    
    var loaded = false
    
    //ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// View for user interface collection
    var collectionView: UICollectionView!
    
    /// Model for bluebird widgets
    var viewModel: BluebirdWidgetsViewModel!
    
    /// Define highligh colors to match branding
    let widgetHighlightColors: [UIColor] = [UIColor.teknikioYellow,
                                            UIColor.teknikioMagenta,
                                            UIColor.tekinkioLightBlue,
                                            UIColor.teknikioOrange,
                                            UIColor.teknikioDarkGreen,
                                            UIColor.teknikioRed,
                                            UIColor.teknikioBrightGreen,
                                            UIColor.tekinkioLightBlue]
    
    /* View Controllers used by side bar navigation */
    var dashbaordView: DashboardViewController?
    var newDashboardView: NewDashboardViewController?
    var myInventionsView: MyInventionsViewController?
    var browseProjectsView: BrowseProjectsViewController?
    var browseLessonsView: BrowseLessonsViewController?
    var helpView: HelpViewController?
    var demoView: DemoViewController?
    var devicesView: DevicesViewController?
    var updatesView: OTAViewController?
    
    /// Establish Bluebird widgets view controller state on loading
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let y = teknestCore.connectedThings
        setupUI()
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = false
        bringUpInventionDelegate = self
    }
    
    @IBAction func actionButtonPressed(_ sender: UIBarButtonItem) {
        print("Action Button Pressed")
        globalInventionBuilderDelegate?.saveInventionDialogRequested()
    }
    
    func setupViewControllersForScrollView(){
        
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        newDashboardView = self.storyboard?.instantiateViewController(withIdentifier: "newDashboardViewController") as! NewDashboardViewController?
        newDashboardView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        scrollView.addSubview((newDashboardView?.view)!)
        newDashboardView?.didMove(toParentViewController: self)
        
        myInventionsView = self.storyboard?.instantiateViewController(withIdentifier: "myInventionsViewController") as! MyInventionsViewController?
        myInventionsView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        scrollView.addSubview((myInventionsView?.view)!)
        myInventionsView?.didMove(toParentViewController: self)
    }
    
    /// Establish Bluebird widgets view controller state on appearing
    override func viewDidAppear(_ animated: Bool){
        
        //print("WidgetsViewController: viewDidAppear")
        //viewModel.open()
        //setupBindings()
        //setupCollectionView()
        //self.view.bringSubview(toFront: statusView)
        //self.view.bringSubview(toFront: tabBar)
        
        /*  Temporary */
        if testLogin{
            
            let transistion = CATransition()
            transistion.subtype = kCATransitionFade
            view.window!.layer.add(transistion, forKey: kCATransition)
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController?
            self.navigationController?.show(newView!, sender: self)
            
        } else {
            //            dashboardRequested()
        }
    }
    
    
    // Store, clean up Bluebird view controller state before disappearing
    override func viewWillDisappear(_ animated: Bool) {
        collectionView?.removeFromSuperview()
    }
    
    //    override func viewDidLayoutSubviews() {
    //        self.navigationController?.navigationBar.layer.isOpaque = true
    //        UINavigationBar.appearance().isOpaque = true
    //        //teknestCoreTests.setupDelegateView(view: self.view)
    //        //self.navigationController?.navigationBar.isTranslucent = false
    //
    //    }
    
    var delegate: CenterViewControllerDelegate?
    
    @IBAction func sideMenuRequested(_ sender: UIBarButtonItem) {
        delegate?.toggleLeftPanel?()
    }
}

extension HomeViewController: TemporarySwitchToInventionBuilderDelegte{
    
    func bringUpInventionBuilder() {
        delegate?.toggleLeftPanel?()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.demoRequested()
        })
    }
}


extension HomeViewController: TeknestNavigation{
    
    func updatesRequested() {
        print("try to move to OTA Updates")
        
        if updatesView != nil {
            
            self.scrollView.bringSubview(toFront: (updatesView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else {
            
            updatesView = self.storyboard?.instantiateViewController(withIdentifier: "otaViewController") as! OTAViewController?
            updatesView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((updatesView?.view)!)
            updatesView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
    }
    
    
    /*  Setup dashboard view controller and move to view */
    func devicesRequested(){
        
        print("try to move to dashboard")
        
        if devicesView != nil {
            
            self.scrollView.bringSubview(toFront: (devicesView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else {
            
            devicesView = self.storyboard?.instantiateViewController(withIdentifier: "devicesViewController") as! DevicesViewController?
            devicesView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((devicesView?.view)!)
            devicesView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
    }
    
    /*  Setup dashboard view controller and move to view */
    func dashboardRequested() {
        
        print("try to move to dashboard")
        
        if newDashboardView != nil {
            
            self.scrollView.bringSubview(toFront: (newDashboardView?.view)!)
            newDashboardView?.updateDashboardData()
            delegate?.toggleLeftPanel?()
            
        } else {
            
            
            self.newDashboardView = self.storyboard?.instantiateViewController(withIdentifier: "newDashboardViewController") as! NewDashboardViewController?
            self.newDashboardView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.newDashboardView?.view.layer.opacity = 0
            self.scrollView.addSubview((self.newDashboardView?.view)!)
            self.newDashboardView?.didMove(toParentViewController: self)
            
            
            UIView.animate(withDuration: 0.1) {
                self.newDashboardView?.view.layer.opacity = 1
            }
            
            if loaded == true{
                delegate?.toggleLeftPanel?()
            }
            loaded = true
            
        }
        
        
    }
    
    /*  Setup inventions view controller and move to view */
    func myInventionsRequested() {
        
        if myInventionsView != nil {
            
            self.scrollView.bringSubview(toFront: (self.myInventionsView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else{
            myInventionsView = self.storyboard?.instantiateViewController(withIdentifier: "myInventionsViewController") as! MyInventionsViewController?
            myInventionsView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((myInventionsView?.view)!)
            myInventionsView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
    }
    
    /*  Setup browse projects view controller and move to view */
    func browseProjectsRequested() {
        
        if browseProjectsView != nil {
            
            self.scrollView.bringSubview(toFront: (self.browseProjectsView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else {
            browseProjectsView = self.storyboard?.instantiateViewController(withIdentifier: "browseProjectsViewController") as! BrowseProjectsViewController?
            browseProjectsView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((browseProjectsView?.view)!)
            browseProjectsView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
    }
    
    /*  Setup browse lessons view controller and move to view */
    func browseLessonsRequested() {
        
        if browseLessonsView != nil {
            
            self.scrollView.bringSubview(toFront: (self.browseLessonsView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else {
            browseLessonsView = self.storyboard?.instantiateViewController(withIdentifier: "browseLessonsViewController") as! BrowseLessonsViewController?
            browseLessonsView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((browseLessonsView?.view)!)
            browseLessonsView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
    }
    
    /*  Setup help view controller and move to view */
    func helpRequested() {
        
        if helpView != nil {
            
            self.scrollView.bringSubview(toFront: (self.helpView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else {
            helpView = self.storyboard?.instantiateViewController(withIdentifier: "helpViewController") as! HelpViewController?
            helpView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((helpView?.view)!)
            helpView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
        
    }
    
    /*  Setup demo view controller and move to view */
    func demoRequested() {
        
        if demoView != nil {
            
            self.scrollView.bringSubview(toFront: (self.demoView?.view)!)
            delegate?.toggleLeftPanel?()
            
        } else {
            demoView = self.storyboard?.instantiateViewController(withIdentifier: "demoViewController") as! DemoViewController?
            demoView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.addSubview((demoView?.view)!)
            demoView?.didMove(toParentViewController: self)
            delegate?.toggleLeftPanel?()
        }
        
    }
    
}


extension HomeViewController
{
    
    /// Configure bluebird widgets view controller user interface
    func setupUI(){
        //Add gradient to background
        //        let gradient                    = CAGradientLayer()
        //        gradient.frame                  = self.view.bounds
        //        gradient.colors                 = [UIColor.teknikioPrimaryColor.cgColor, UIColor.teknikioPrimaryColor.cgColor]
        //        self.view.layer.insertSublayer(gradient, at: UInt32(0))
        //self.view.backgroundColor = UIColor.teknikioPrimaryColor
        //self.view.bringSubview(toFront: statusView)
    }
}


// MARK: - SidePanelViewControllerDelegate
extension HomeViewController: SidePanelViewControllerDelegate {
    
    func test() {
        //testScrollView()
        print("Delegate called from sidepanel ")
    }
}



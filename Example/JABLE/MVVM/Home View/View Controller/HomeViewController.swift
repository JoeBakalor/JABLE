////
////  HomeViewController.swift
////  JABLE_Example
////
////  Created by Joe Bakalor on 9/15/18.
////  Copyright © 2018 CocoaPods. All rights reserved.
////
//
//import Foundation
//
//
//
//import UIKit
//
//var testLogin = true
//
//@objc protocol CenterViewControllerDelegate {
//    @objc optional func toggleLeftPanel()
//    @objc optional func toggleRightPanel()
//    @objc optional func collapseSidePanels()
//}
//
//
///*  TEMPORARY HACK */
//protocol TemporarySwitchToInventionBuilderDelegte {
//    func bringUpInventionBuilder()
//}
//
//var bringUpInventionDelegate: TemporarySwitchToInventionBuilderDelegte?
///**/
//
//class HomeViewController: UIViewController {
//    
//    var loaded = false
//    
//    //ScrollView
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    /// View for user interface collection
//    var collectionView: UICollectionView!
//    
//    /// Model for bluebird widgets
//    //var viewModel: BluebirdWidgetsViewModel!
//    
//    /// Establish Bluebird widgets view controller state on loading
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        //let y = teknestCore.connectedThings
//        self.edgesForExtendedLayout = UIRectEdge.all
//        self.extendedLayoutIncludesOpaqueBars = false
//        bringUpInventionDelegate = self
//    }
//    
//    @IBAction func actionButtonPressed(_ sender: UIBarButtonItem) {
//        print("Action Button Pressed")
//        //g//lobalInventionBuilderDelegate?.saveInventionDialogRequested()
//    }
//    
//    func setupViewControllersForScrollView(){
//    }
//    
//    /// Establish Bluebird widgets view controller state on appearing
//    override func viewDidAppear(_ animated: Bool){
//        
//        //print("WidgetsViewController: viewDidAppear")
//        //viewModel.open()
//        //setupBindings()
//        //setupCollectionView()
//        //self.view.bringSubview(toFront: statusView)
//        //self.view.bringSubview(toFront: tabBar)
//        
//        /*  Temporary */
//        if testLogin{
//            
////            let transistion = CATransition()
////            transistion.subtype = kCATransitionFade
////            view.window!.layer.add(transistion, forKey: kCATransition)
////            let newView = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController?
////            self.navigationController?.show(newView!, sender: self)
//            
//        } else {
//            //            dashboardRequested()
//        }
//    }
//    
//    
//    // Store, clean up Bluebird view controller state before disappearing
//    override func viewWillDisappear(_ animated: Bool) {
//        collectionView?.removeFromSuperview()
//    }
//    
//    var delegate: CenterViewControllerDelegate?
//    
//    @IBAction func sideMenuRequested(_ sender: UIBarButtonItem) {
//        delegate?.toggleLeftPanel?()
//    }
//}
//
//extension HomeViewController: TemporarySwitchToInventionBuilderDelegte{
//    
//    func bringUpInventionBuilder() {
//        delegate?.toggleLeftPanel?()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
//            //self.demoRequested()
//        })
//    }
//}
//
//

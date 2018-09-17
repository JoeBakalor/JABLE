//
//  ContainerViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
    
    enum SlideOutState {
        case collapsed
        case leftPanelExpanded
    }
    
    var centerNavigationController: UINavigationController!
    var centerViewController: HomeViewController!
    var leftViewController: SideNavigationViewControllerNew?
    
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = currentState != .collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var centerPanelExpandedOffset: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        centerPanelExpandedOffset = centerNavigationController.view.frame.width/2 - 40
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
    }
    
    
}

// MARK: CenterViewController delegate
extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        if notAlreadyExpanded { addLeftPanelViewController()}
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch currentState {
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        
        guard leftViewController == nil else { return }
        
        /*  only create if it doesnt exits already */
        if let vc = UIStoryboard.leftViewController() {
            print("Create and add side view controller")
            addChildSidePanelController(vc)
            leftViewController = vc
            
            //            leftViewController?.delegate = centerViewController
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SideNavigationViewControllerNew) {
        
        //        sidePanelController.delegate = centerViewController
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    
    func animateLeftPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .collapsed
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        },
                       completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

// MARK: Gesture recognizer
extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch recognizer.state {
            
        case .began:
            
            if currentState == .collapsed {
                
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                } else {
                    //addRightPanelViewController()
                }
                
                showShadowForCenterViewController(true)
            }
            
        case .changed:
            
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            
            if let _ = leftViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            }
            
        default:
            break
        }
    }
}

private extension UIStoryboard {
    
    static func main() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func leftViewController() -> SideNavigationViewControllerNew? {
        return main().instantiateViewController(withIdentifier: "sideNavigationViewControllerNew") as? SideNavigationViewControllerNew
    }
    
    static func centerViewController() -> HomeViewController? {
        return main().instantiateViewController(withIdentifier: "homeViewController") as? HomeViewController
    }
}

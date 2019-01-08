//
//  MenuLevelController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class MenuLevelViewController: UIViewController {
    
    private let blurView                = UIVisualEffectView()
    private let popupView               = JABLEPopupView()
    var popupViewShown          = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? AppNavigationController  else {return}
        let sideMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-alt32_32"), style: .plain, target: nav, action: Selector(("sideMenuButtonDidPress")))
        self.navigationItem.leftBarButtonItem = sideMenuButton
        self.navigationItem.setLeftBarButton(sideMenuButton, animated: false)
        
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0.0
        self.view.addSubview(blurView)
        self.view.addSubview(popupView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let popupViewWidth = self.view.bounds.width*0.9
        let popupViewHeight = self.view.bounds.height*0.75
        let popupXOrigin = (self.view.bounds.width - popupViewWidth)/2
        let popupYOrigin = (self.view.bounds.height - popupViewHeight)
        
        blurView.frame = self.view.bounds
        popupView.frame = CGRect(
            origin: CGPoint(x: popupXOrigin, y: popupYOrigin),
            size: CGSize(width: popupViewWidth, height: popupViewHeight))
        popupView.frame.origin.y += self.view.bounds.height
        
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.addTarget(self, action: #selector(togglePopupView))
        popupView.addGestureRecognizer(gesture)
    }
    
    
    @objc func togglePopupView(){
        if popupViewShown{
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(.easeInOut)
            blurView.alpha = 0.0
            popupView.frame.origin.y += self.view.bounds.height
            UIView.commitAnimations()
            popupViewShown = false
        }
        else {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(.easeInOut)
            blurView.alpha = 1.0
            popupView.frame.origin.y -= self.view.bounds.height
            UIView.commitAnimations()
            popupViewShown = true
        }
    }
    
}

//
//  PeripheralScanViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CentralModeScanViewController: MenuLevelViewController {

    @IBOutlet weak var collectionView   : UICollectionView!
    private var viewModel               : CentralModeScanViewModel!
    private let blurView                = UIVisualEffectView()
    private let popupView               = JABLEPopupView()
    private var popupViewShown          = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        viewModel = CentralModeScanViewModel(collectionView: collectionView)
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 0.0
        self.view.addSubview(blurView)
        self.view.addSubview(popupView)
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        blurView.frame = self.view.bounds
        let popupViewWidth = self.view.bounds.width*0.9
        let popupViewHeight = self.view.bounds.height*0.75
        let popupXOrigin = (self.view.bounds.width - popupViewWidth)/2
        let popupYOrigin = (self.view.bounds.height - popupViewHeight)
        popupView.frame = CGRect(
            origin: CGPoint(x: popupXOrigin, y: popupYOrigin),
            size: CGSize(width: popupViewWidth, height: popupViewHeight))
        popupView.frame.origin.y += self.view.bounds.height
        
        /*DEBUGGING ONLY*/
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.addTarget(self, action: #selector(togglePopupView))
        popupView.addGestureRecognizer(gesture)
    }
    
    func setupBindings(){
        viewModel.selectedScanResult.bind { [weak self] (selectedScanResult) in
            /*HIDE IF NIL, SHOW IF NOT */
            guard let realSelf = self else { return }
            if let validResult = selectedScanResult{
                if realSelf.popupViewShown {
                    return
                }
                else {
                    realSelf.togglePopupView()
                }
            }
            else {
                if realSelf.popupViewShown { realSelf.togglePopupView() }
            }
        }
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

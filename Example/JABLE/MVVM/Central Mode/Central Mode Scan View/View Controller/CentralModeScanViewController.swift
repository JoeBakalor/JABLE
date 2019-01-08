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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        viewModel = CentralModeScanViewModel(collectionView: collectionView)
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
}

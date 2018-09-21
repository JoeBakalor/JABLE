//
//  PeripheralScanViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CentralModeScanViewController: MenuLevelViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: CentralModeScanViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        viewModel = CentralModeScanViewModel(collectionView: collectionView)
    }
}

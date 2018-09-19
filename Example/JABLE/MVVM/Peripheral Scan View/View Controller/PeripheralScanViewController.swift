//
//  PeripheralScanViewController.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PeripheralScanViewController: MenuLevelViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: PeripheralScanViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.JableDarkGray
        viewModel = PeripheralScanViewModel(collectionView: collectionView)
    }
}

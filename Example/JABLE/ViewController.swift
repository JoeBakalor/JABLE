//
//  ViewController.swift
//  JABLE
//
//  Created by jmbakalor@gmail.com on 03/01/2018.
//  Copyright (c) 2018 jmbakalor@gmail.com. All rights reserved.
//

import UIKit
import JABLE

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: DeviceDiscoveryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.JableDarkGray
        viewModel = DeviceDiscoveryViewModel(collectionView: collectionView)
    }

}


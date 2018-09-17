//
//  PeripheralScanViewModel.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import JABLE

class PeripheralScanViewModel: NSObject{
    
    private var bleManager: BLEManager!
    private weak var jableCollectionViewManager: JableCollectionViewManager!
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        bleManager = BLEManager()
        jableCollectionViewManager = JableCollectionViewManager(collectionView: collectionView)
        bleManager.bleDiscoveryDelegate = self
    }
}

extension PeripheralScanViewModel: BLEDiscoveryDelegate{
    
    func didDiscoveryNewPeripheral(advData: FriendlyAdvdertisment) {
        jableCollectionViewManager.data.append(advData)
    }
    
}

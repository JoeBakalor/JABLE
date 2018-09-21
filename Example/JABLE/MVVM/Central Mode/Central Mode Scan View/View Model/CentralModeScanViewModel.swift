//
//  PeripheralScanViewModel.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import JABLE

class CentralModeScanViewModel: NSObject{
    
    private var bleManager: BLEManager!
    private var jableCollectionViewManager: JableCollectionViewManager!
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        bleManager = BLEManager()
        jableCollectionViewManager = JableCollectionViewManager(collectionView: collectionView)
        bleManager.bleDiscoveryDelegate = self
    }
}

extension CentralModeScanViewModel: BLEDiscoveryDelegate{

    func processedScanResult(processedResult: TrackedScanResult) {
        
        jableCollectionViewManager.processNewData(newData: processedResult)
    }
    
    
    func didUpdateManagedList(updatedList: [TrackedScanResult]) {
        print("===========> UPDATED PERIPHERAL LIST")
        //jableCollectionViewManager.data = updatedList
    }
    
    
    func didDiscoveryNewPeripheral(advData: FriendlyAdvertisement) {
        //jableCollectionViewManager.data.append(advData)
    }
    
}

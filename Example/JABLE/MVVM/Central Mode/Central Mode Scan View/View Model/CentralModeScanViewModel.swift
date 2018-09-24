//
//  PeripheralScanViewModel.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/15/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import JABLE

let bleManager = BLEManager()

class CentralModeScanViewModel: NSObject{
    
    var selectedScanResult: Bindable<TrackedScanResult?> = Bindable(nil)
    
    private var jableCollectionViewManager: JableCollectionViewManager!
    init(collectionView: UICollectionView) {
        super.init()
        jableCollectionViewManager = JableCollectionViewManager(collectionView: collectionView, delegate: self)
        bleManager.bleDiscoveryDelegate = self
    }
}

extension CentralModeScanViewModel: BLEDiscoveryDelegate{
    
    func processedScanResult(processedResult: TrackedScanResult) {
        jableCollectionViewManager.processNewData(newData: processedResult)
    }
}

extension CentralModeScanViewModel: JableCollectionManagerDelegate{
    
    func userSelected(scanResult: TrackedScanResult) {
        selectedScanResult.value = scanResult
    }
    
}

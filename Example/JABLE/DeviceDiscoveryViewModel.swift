//
//  DeviceDiscoveryViewModel.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import JABLE
class DeviceDiscoveryViewModel: NSObject{
    
    var bleManager: BLEManager!
    var jableCollectionViewManager: JableCollectionViewManager!
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        bleManager = BLEManager()
        jableCollectionViewManager = JableCollectionViewManager(collectionView: collectionView)
        //setupBindings()
        bleManager.bleDiscoveryDelegate = self
    }
    
    func setupBindings(){
        bleManager.discoveredPeripherals.bind { [weak self] (adv) in
            print("Updated discovered peripherals")
            guard let realSelf = self else { return }
            //realSelf.jableCollectionViewManager.data = adv
        }
    }
}
extension DeviceDiscoveryViewModel: BLEDiscoveryDelegate{
    func didUpdateManagedList(updatedList: [TrackedScanResult]) {
        
    }
    
    
    func didDiscoveryNewPeripheral(advData: FriendlyAdvertisement) {
        //jableCollectionViewManager.data.append(advData)
    }
}

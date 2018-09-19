//
//  ScanResultManager.swift
//  CorePlot
//
//  Created by Joe Bakalor on 9/14/18.
//

import Foundation
import CoreBluetooth

struct TrackedScanResult{
    var rssiArray: [Int]
    var currentAdvData: FriendlyAdvertisement
    var lastSeen: Date
}

class ScanResultManager: NSObject{
    
    private var managedScanResult: [CBPeripheral : TrackedScanResult] = [:]
    
    func newScanResult(peripheral: CBPeripheral, advData: FriendlyAdvertisement){
        
        if managedScanResult[peripheral] != nil{
            
            managedScanResult[peripheral]?.currentAdvData = advData
            if let newRssi = advData.rssi { managedScanResult[peripheral]?.rssiArray.append(newRssi) }
            managedScanResult[peripheral]?.lastSeen = Date()
            
        } else {
            
            managedScanResult[peripheral] = TrackedScanResult(
                rssiArray: advData.rssi != nil ? [advData.rssi!] : [],
                currentAdvData: advData,
                lastSeen: Date())
        }
    }
}

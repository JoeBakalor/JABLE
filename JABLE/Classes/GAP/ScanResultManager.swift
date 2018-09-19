//
//  ScanResultManager.swift
//  CorePlot
//
//  Created by Joe Bakalor on 9/14/18.
//

import Foundation
import CoreBluetooth

public struct TrackedScanResult{
    public var rssiArray: [Int]
    public var currentAdvData: FriendlyAdvertisement
    public var lastSeen: Date
}

open class ScanResultManager: NSObject{
    
    private var managedScanResult: [CBPeripheral : TrackedScanResult] = [:]
    
    public func newScanResult(peripheral: CBPeripheral, advData: FriendlyAdvertisement) -> [TrackedScanResult]{
        
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
        
        let managedResult = managedScanResult.map { (value) -> TrackedScanResult in
            return value.value
        }
        
        return managedResult
    }
}

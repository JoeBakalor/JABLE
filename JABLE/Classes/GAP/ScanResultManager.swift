//
//  ScanResultManager.swift
//  CorePlot
//
//  Created by Joe Bakalor on 9/14/18.
//

import Foundation
import CoreBluetooth

public struct TrackedScanResult{
    public var resultID         : Int
    public var isNew            : Bool
    public var rssiArray        : [Int]
    public var currentAdvData   : FriendlyAdvertisement
    public var lastSeen         : Date
}

open class ScanResultManager: NSObject{
    
    private var managedScanResult: [CBPeripheral : TrackedScanResult] = [:]
    
    public func processScanResult(peripheral: CBPeripheral, advData: FriendlyAdvertisement) -> TrackedScanResult?{
        
        if managedScanResult[peripheral] != nil{
            
            managedScanResult[peripheral]?.isNew = false
            managedScanResult[peripheral]?.currentAdvData = advData
            
            if let newRssi = advData.rssi {
                if let rssiCount = managedScanResult[peripheral]?.rssiArray.count{
                    if rssiCount < 10{
                        managedScanResult[peripheral]?.rssiArray.append(newRssi)
                    } else {
                        managedScanResult[peripheral]?.rssiArray.removeFirst()
                        managedScanResult[peripheral]?.rssiArray.append(newRssi)
                    }
                }
            }
            if let lastSeen = managedScanResult[peripheral]?.lastSeen{
                if Date().timeIntervalSince(lastSeen) > 0.5 {
                    managedScanResult[peripheral]?.lastSeen = Date()
                    return managedScanResult[peripheral]
                }
            }
            return nil
        }
        else {
            
            managedScanResult[peripheral] = TrackedScanResult(
                resultID: globalIdManager.newScanResultID(),
                isNew: true,
                rssiArray: advData.rssi != nil ? [advData.rssi!] : [],
                currentAdvData: advData,
                lastSeen: Date())
            
            return managedScanResult[peripheral]
        }

    }
}

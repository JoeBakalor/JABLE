//
//  JABLEiDManager.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/12/18.
//

import Foundation

let globalIdManager = JABLEiDManager()

class JABLEiDManager: NSObject{
    
    private var currentAvailablePeripheralID: Int = 0
    private var currentAvailableScanResultID: Int = 0
    
    func newPeripheralID() -> Int{
        defer { currentAvailablePeripheralID += 1 }
        
        let newID = currentAvailablePeripheralID
        return newID
    }
    
    func newScanResultID() -> Int{
        defer { currentAvailableScanResultID += 1 }
        
        let newID = currentAvailableScanResultID
        return newID
    }
}

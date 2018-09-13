//
//  JABLEiDManager.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/12/18.
//

import Foundation

typealias JABLEPeripheralID = Int

class JABLEiDManager: NSObject{
    
    var currentAvailablePeripheralID: Int = 0
    
    func newPeripheralID() -> JABLEPeripheralID{
        let newID = currentAvailablePeripheralID
        currentAvailablePeripheralID += 1
        return newID
    }
    
}

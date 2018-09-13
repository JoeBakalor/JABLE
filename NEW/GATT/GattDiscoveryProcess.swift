//
//  GattDiscoveryProcess.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

struct GattDiscoveryProcess{
    
    var unprocessedServices: [CBService] = []
    var unprocessedCharacteristics: [CBCharacteristic] = []
    var gattProfile: JABLEGattProfile
    var discoveryAgent: GattDiscoveryAgent
    
    init(gatt: JABLEGattProfile, peripheral: CBPeripheral) {
        self.gattProfile = gatt
        self.discoveryAgent = GattDiscoveryAgent(gattProfile: gatt, peripheral: peripheral)
    }
}

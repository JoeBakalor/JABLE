//
//  BLEManager.swift
//  BLU
//
//  Created by Joe Bakalor on 2/23/18.
//  Copyright © 2018 Joe Bakalor. All rights reserved.
//

import Foundation
import CoreBluetooth
import JABLE

let bleManager = BLEManager()

class BLEManager: NSObject{
    
    enum ScanStatus{
        case scanning
        case stopped
        case pendingStart
    }
    
    var _scanStatus = ScanStatus.stopped
    var _ready: Bool = false
    var _bleManager: JABLE!
    var _gatt: JABLE_GATT.JABLE_GATTProfile?
    var _connectionCount = 0
    
    override init() {
        super.init()
        _bleManager = JABLE(jableDelegate: self, gattProfile: &_gatt, autoGattDiscovery: false)
    }
    
    func startScanning(){
        
        guard _ready == true else {_scanStatus = .pendingStart;  return}
        _bleManager.startScanningForPeripherals(withServiceUUIDs: nil)
    }
    
}

extension BLEManager: JABLEDelegate{
    func jable(isReady: Void) {
        
    }
    
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvdertismentData) {
        
    }
    
    func jable(completedGattDiscovery: Void) {
        
    }
    
    func jable(updatedRssi rssi: Int) {
        
    }
    
    func jable(foundServices services: [CBService]) {
        
    }
    
    func jable(foundCharacteristicsFor service: CBService, characteristics: [CBCharacteristic]) {
        
    }
    
    func jable(foundDescriptorsFor characteristic: CBCharacteristic, descriptors: [CBDescriptor]) {
        
    }
    
    func jable(updatedCharacteristicValueFor characteristic: CBCharacteristic, value: Data) {
        
    }
    
    func jable(updatedDescriptorValueFor descriptor: CBDescriptor, value: Data) {
        
    }
    
    func jable(connected: Void) {
        
    }
    
    func jable(disconnected: Void) {
         
    }
    
    
    /*func foundPeripheral(peripheral: CBPeripheral, advertismentData: FriendlyAdvdertismentData) {
        _bleManager.stopScanning()
        _scanStatus = .stopped
        _bleManager.connect(toPeripheral: peripheral, withTimeout: 5)
        print("BLEManager: Found Peripheral: \(peripheral)\r\nAdvertisment Data: \n\(advertismentData)\n\r")
        
        
    }
    
    func ready() {
        print("JABLE Ready")
        _ready = true
        guard _scanStatus == .pendingStart else {return}
        _scanStatus = .scanning
        _bleManager.startScanningForPeripherals(withServiceUUIDs: nil)
    }
    
    func gattDiscoveryCompleted() {
        
    }
    
    func rssiUpdated(to rssi: Int) {
        
    }
    
    func foundServices(services: [CBService]) {
        
        print("Found Services: \(services)")
        
    }
    
    func foundCharacteristics(forService service: CBService, characteristics: [CBCharacteristic]) {
        
    }
    
    func foundDescriptors(forCharacteristic characteristic: CBCharacteristic, descriptors: [CBDescriptor]) {
        
    }
    
    func valueUpdated(forCharacteristic characteristic: CBCharacteristic, value: Data) {
        
    }
    
    func valueUpdated(forDescriptor descriptor: CBDescriptor, value: Data) {
        
    }
    
    func connected(){
        print("Connected")
        _connectionCount += 1
        print("Connection Count = \(_connectionCount)")
        _bleManager.startScanningForPeripherals(withServiceUUIDs: nil)
        //_bleManager.discoverServices(with: nil)
    }
    
    func disconnected(){
        _connectionCount -= 1
        print("Connection Count = \(_connectionCount)")
        if _scanStatus != .scanning{
            _bleManager.startScanningForPeripherals(withServiceUUIDs: nil)
        }
    }*/
    
}



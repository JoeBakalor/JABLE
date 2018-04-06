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

protocol PeripheralScanDelegate{
    func updatedPeripheralList(peripherals: [(peripheral: CBPeripheral, advData: FriendlyAdvdertismentData)])
}

protocol PeripheralConnectionDelegate {
    func connected()
}

@objc
protocol GattDiscoveryDelegate{
    @objc optional func foundServices(services: [CBService])
    @objc optional func foundCharacteristics(characteristics: [CBCharacteristic])
}

class BLEManager: JABLE{
    
    enum ScanStatus{
        case scanning
        case stopped
        case pendingStart
    }
    
    //  Instance variables
    private var _bleManager: JABLE!
    private var _gatt: JABLE_GATT.JABLE_GATTProfile?
    
    //  State variables
    var _scanStatus = ScanStatus.stopped
    var _ready: Bool = false
    
    //  Protocol instances
    private var _peripheralScanDelegate: PeripheralScanDelegate?
    private var _peripheralConnectionDelegate: PeripheralConnectionDelegate?
    private var _gattDiscoveryDelegate: GattDiscoveryDelegate?
    
    //  Internal reference variables
    private var _discoveredPeripherals: [(peripheral: CBPeripheral, advData: FriendlyAdvdertismentData)] = []
    private var _currentlySelectedService: CBService?
    private var _currentlySelectedCharacteristic: CBCharacteristic?
    

    
    init() {
        super.init(jableDelegate: nil, gattProfile: &_gatt, autoGattDiscovery: false)
        super.setJableDelegate(jableDelegate: self)
    }
}

//MARK:
extension BLEManager{
    
    func setSelectedService(selectedService: CBService){
        _currentlySelectedService = selectedService
    }
    
    func setSelectedCharacteristic(selectedCharacteristic: CBCharacteristic){
        _currentlySelectedCharacteristic = selectedCharacteristic
    }
    
    func setPeripheralScanDelegate(peripheralScanDelegate: PeripheralScanDelegate){
        _peripheralScanDelegate = peripheralScanDelegate
    }
    
    func setPeripheralConnectionDelegate(peripheralConnectionDelegate: PeripheralConnectionDelegate){
        _peripheralConnectionDelegate = peripheralConnectionDelegate
    }
    
    func setGattDiscoveryDelegate(gattDiscoveryDelegate: GattDiscoveryDelegate){
        _gattDiscoveryDelegate = gattDiscoveryDelegate
    }
}


extension BLEManager
{
    func startScanning(){
        guard _ready == true else {_scanStatus = .pendingStart;  return}
        _bleManager.startScanningForPeripherals(withServiceUUIDs: nil)
    }
    
    func connect(peripheral: CBPeripheral){
        _bleManager.connect(toPeripheral: peripheral, withTimeout: 5)
    }
    
    func discoverServcices(){
        _bleManager.discoverServices(with: nil)
    }
    
    func discoverCharacteristics(){
        if let service = _currentlySelectedService{
            _bleManager.discoverCharacteristics(forService: service, withUUIDS: nil)
        }
    }
}

extension BLEManager: JABLEDelegate
{
    func jable(disconnectedWithReason reason: Error?) {
        
    }
    
    func jable(updatedRssi rssi: Int) {
    }
    
    func jable(isReady: Void) {
        _ready = true
        guard _scanStatus == .pendingStart else {return}
    }
    
    func jable(connected: Void) {
        print("Connected")
        _peripheralConnectionDelegate?.connected()
    }
    
    func jable(disconnected: Void) {
        print("")
    }
    
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvdertismentData){
        
        //  Check for duplicate, if duplicate then update data
        var duplicate = false
        
        let new = _discoveredPeripherals.map({ (oldPeripheral, oldAdvDa)  -> (CBPeripheral, FriendlyAdvdertismentData) in
            if oldPeripheral == peripheral{// duplicate found
                
                duplicate = true
                return (peripheral, advertisementData)
                
            }else{//  not a duplicate
                
                return (oldPeripheral, oldAdvDa)
            }
        })
        
        //  Use new list if duplicate else append new peripheral
        guard duplicate == false else { print("Duplicate found"); _discoveredPeripherals = new; return}
        _discoveredPeripherals.append((peripheral: peripheral, advertisementData))
        _peripheralScanDelegate?.updatedPeripheralList(peripherals: _discoveredPeripherals)
    }
    
    func ready() {
        _ready = true
        guard _scanStatus == .pendingStart else {return}
    }
    
    func jable(completedGattDiscovery: Void){
    }
    
    func jable(foundServices services: [CBService]){//foundServices(services: [CBService]) {
        print("BLEManager: found services")
        _gattDiscoveryDelegate?.foundServices!(services: services)
    }
    
    func jable(foundCharacteristicsFor service: CBService, characteristics: [CBCharacteristic]){
        print("BLEManager: found characteristic")
        _gattDiscoveryDelegate?.foundCharacteristics!(characteristics: characteristics)
    }
    
    func jable(foundDescriptorsFor characteristic: CBCharacteristic, descriptors: [CBDescriptor]){
    }
    
    func jable(updatedCharacteristicValueFor characteristic: CBCharacteristic, value: Data){
    }
    
    func jable(updatedDescriptorValueFor descriptor: CBDescriptor, value: Data){
    }
    
}











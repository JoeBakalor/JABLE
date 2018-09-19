

import Foundation
import CoreBluetooth
import JABLE

class BLEManager: NSObject{
    
    private var jable: JABLENew!
    
    var discoveredPeripherals: Bindable<[FriendlyAdvertisement]> = Bindable([])
    var _discoveredPeripherals: [FriendlyAdvertisement] = []
    var bleDiscoveryDelegate: BLEDiscoveryDelegate?
    

    
    override init() {
        super.init()
        print("Initialize JABLE")
        jable = JABLENew()
        jable.setDelegate(delegate: self)
        jable.startLookingForPeripherals(withServiceUUIDs: nil)
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
    }
    
    @objc func stop(){
        jable.stopLookingForPeripherals()
    }

}

protocol BLEDiscoveryDelegate{
    func didDiscoveryNewPeripheral(advData: FriendlyAdvertisement)
}


extension BLEManager: JABLEDelegateNew{
    
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvertisement, raw: [String : Any]) {
        print("Raw adv data: \(peripheral)")
    }
    

    
    
    func jable(isReady: Void) {
        
    }
    
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvertisement) {
        
        bleDiscoveryDelegate?.didDiscoveryNewPeripheral(advData: advertisementData)
        //print("Found peripheral: \(advertisementData)")
        _discoveredPeripherals.append(advertisementData)
        discoveredPeripherals.value = _discoveredPeripherals
        
    }
    
    func jable(completedGattDiscovery: Void) {
        
    }
    
    func jable(updatedRssi rssi: Int, forPeripheral peripheral: CBPeripheral) {
        
    }
    
    func jable(foundServices services: [CBService], forPeripheral peripheral: CBPeripheral) {
        
    }
    
    func jable(foundCharacteristicsFor service: CBService, characteristics: [CBCharacteristic]) {
        
    }
    
    func jable(foundDescriptorsFor characteristic: CBCharacteristic, descriptors: [CBDescriptor]) {
        
    }
    
    func jable(updatedCharacteristicValueFor characteristic: CBCharacteristic, value: Data, onPeripheral peripheral: CBPeripheral) {
        
    }
    
    func jable(updatedDescriptorValueFor descriptor: CBDescriptor, value: Data) {
        
    }
    
    func jable(connectedTo peripheral: CBPeripheral) {
        
    }
    
    func jable(disconnectedWithReason reason: Error?, from peripheral: CBPeripheral) {
        
    }
    
    
}


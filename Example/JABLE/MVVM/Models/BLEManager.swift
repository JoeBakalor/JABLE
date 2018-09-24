

import Foundation
import CoreBluetooth
import JABLE

class BLEManager: NSObject{
    
    private var jable: JABLECentral!
    
    var discoveredPeripherals: Bindable<[FriendlyAdvertisement]> = Bindable([])
    var _discoveredPeripherals: [FriendlyAdvertisement] = []
    var bleDiscoveryDelegate: BLEDiscoveryDelegate?
    
    private var scanResultManager = ScanResultManager()

    
    override init() {
        super.init()
        print("Initialize JABLE")
        jable = JABLECentral()
        jable.setDelegate(delegate: self)
        jable.startLookingForPeripherals(withServiceUUIDs: nil)
        //let timer = Timer.scheduledTimer(timeInterval: 10000, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
    }
    
    @objc func stop(){
        jable.stopLookingForPeripherals()
    }
}

protocol BLEDiscoveryDelegate{
    func processedScanResult(processedResult: TrackedScanResult)
}


extension BLEManager: JABLEDelegateNew{

    func jable(isReady: Void) {
        
    }
    
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvertisement) {
    
        guard let processedResult = scanResultManager.processScanResult(peripheral: peripheral, advData: advertisementData) else { return }
        //print("BLE Manger processed scan result: \(processedResult)")
        bleDiscoveryDelegate?.processedScanResult(processedResult: processedResult)
        
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


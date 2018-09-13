//
//  JABLEDelegate.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

public protocol JABLEDelegateNew{
    func jable(isReady: Void)
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvdertisment)
    func jable(completedGattDiscovery: Void)
    func jable(updatedRssi rssi: Int, forPeripheral peripheral: CBPeripheral)
    func jable(foundServices services: [CBService])
    func jable(foundCharacteristicsFor service: CBService, characteristics: [CBCharacteristic])
    func jable(foundDescriptorsFor characteristic: CBCharacteristic, descriptors: [CBDescriptor])
    func jable(updatedCharacteristicValueFor characteristic: CBCharacteristic, value: Data, onPeripheral peripheral: CBPeripheral)
    func jable(updatedDescriptorValueFor descriptor: CBDescriptor, value: Data)
    func jable(connectedTo peripheral: CBPeripheral)
    func jable(disconnectedWithReason reason: Error?, from peripheral: CBPeripheral)//test
}

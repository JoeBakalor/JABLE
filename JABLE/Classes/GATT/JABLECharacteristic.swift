//
//  JABLECharacteristic.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

public class JABLECharacteristic{
    
    public var uuid: CBUUID
    public var descriptors: [JABLEDescriptor]
    weak public var assignToCharacteristic: CBCharacteristic?
    
    public init(characteristicUUID: CBUUID, assignTo characteristic: CBCharacteristic?, descriptors: [JABLEDescriptor]){
        self.uuid = characteristicUUID
        self.descriptors = descriptors
        self.assignToCharacteristic = characteristic
    }
}

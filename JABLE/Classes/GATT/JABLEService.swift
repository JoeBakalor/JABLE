//
//  JABLEService.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

open class JABLEService{
    
    public var uuid                 : CBUUID
    public var characteristics      : [JABLECharacteristic]
    weak public var assignToService : CBService? 
    
    public init(serviceUUID: CBUUID, assignTo service: CBService?, characteristics: [JABLECharacteristic]){
        self.uuid = serviceUUID
        self.characteristics = characteristics
        self.assignToService = service
    }
}







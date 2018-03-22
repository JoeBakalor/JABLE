//
//  JABLE_SIGServices.swift
//  JABLE
//
//  Created by Joe Bakalor on 3/21/18.
//

import Foundation
import CoreBluetooth

//let hearRateService = 1

#if heartRateService
let HEART_RATE_SERVICE_UUID = CBUUID(string: "180D")
let HEART_RATE_VALUE_CHARACTERISTIC_UUID = CBUUID(string: "180D")
var HeartRateService: CBService?
    var heartRateCharacteristic: CBCharacteristic?
    
var JABLE_HeartRateService = JABLE_GATT.JABLE_Service?
#endif

let test = JABLE_SIGServices()

class JABLE_SIGServices: NSObject{
    
    override init() {
        super.init()
        #if hearRateService
            JABLE_HeartRateService = JABLE_GATT.JABLE_Service(
                serviceUUID: HEART_RATE_SERVICE_UUID,
                whenFound: assignTo(&HeartRateService),
                characteristics: [
                    JABLE_GATT.JABLE_Characteristic(
                        characteristicUUID: HEART_RATE_VALUE_CHARACTERISTIC_UUID,
                        whenFound: assignTo(&heartRateCharacteristic),
                        descriptors: nil)
                ])
        #endif
        
    }
}

//
//  GattExample.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 3/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CoreBluetooth
import JABLE


//  Example GATT Service, Characteristic, and Descriptor UUIDs

/*SERVICE*/let HEART_RATE_SERVICE_UUID = CBUUID(string: "180D")
/***CHARACTERISTIC***/let HEART_RATE_MEASUREMENT_CHARACTERISTIC_UUID = CBUUID(string: "2A37")
/**********DESCRIPTOR**********/let CLIENT_CHARACTERISTIC_CONFIGURATION_UUID = CBUUID(string: "2902")
/***CHARACTERISTIC***/let BODY_SENSOR_LOCATION_CHARACTERISTIC_UUID = CBUUID(string: "2A38")
/***CHARACTERISTIC***/let HEART_RATE_CONTROL_POINT_CHARACTERISTIC_UUID = CBUUID(string: "2A39")



class GattExample: NSObject{
    
    var heartRateService: CBService?
    var heartRateMeasurementCharacteristic: CBCharacteristic?
    var heartRateMeasurementCharacteristicCCCDescriptor: CBDescriptor?
    var bodySensorLocationCharacteristic: CBCharacteristic?
    var heartRateControlPointCharcteristic: CBCharacteristic?
    
    var gattProfile: JABLE_GATT.JABLE_GATTProfile?
    
    override init() {

        gattProfile = JABLE_GATT.JABLE_GATTProfile(
            services:
            [
                JABLE_GATT.JABLE_Service(
                    serviceUUID: HEART_RATE_SERVICE_UUID,
                    whenFound: assignTo(&heartRateService),
                    characteristics:
                    [
                        JABLE_GATT.JABLE_Characteristic(
                            
                            characteristicUUID: HEART_RATE_MEASUREMENT_CHARACTERISTIC_UUID,
                            whenFound: assignTo(&heartRateMeasurementCharacteristic),
                            descriptors:
                            [
                                JABLE_GATT.JABLE_Descriptor(
                                    descriptorUUID: CLIENT_CHARACTERISTIC_CONFIGURATION_UUID,
                                    whenFound: assignTo(&heartRateMeasurementCharacteristicCCCDescriptor))
                            ]
                        ),
                        JABLE_GATT.JABLE_Characteristic(
                            characteristicUUID: BODY_SENSOR_LOCATION_CHARACTERISTIC_UUID,
                            whenFound: assignTo(&bodySensorLocationCharacteristic),
                            descriptors: nil
                        ),
                        JABLE_GATT.JABLE_Characteristic(
                            characteristicUUID: HEART_RATE_CONTROL_POINT_CHARACTERISTIC_UUID,
                            whenFound: assignTo(&heartRateControlPointCharcteristic),
                            descriptors: nil
                        )
                    ]
                )
            ]
        )
    }
}

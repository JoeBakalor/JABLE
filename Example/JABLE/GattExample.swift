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


import Foundation
import CoreBluetooth

/*ENVIRONMENTAL SERVICE UUIDS*/
let UUID_SERVICE_ENVIRONMENTAL           = CBUUID(string: "00001000-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_TEMPERATURE      = CBUUID(string: "00001001-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_HUMIDITY         = CBUUID(string: "00001002-C356-78AB-3C46-339399E84975")

/*MOTION SERVICE UUIDS*/
let UUID_SERVICE_MOTION                  = CBUUID(string: "00002000-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_ACCELERATION     = CBUUID(string: "00002001-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_GYROSCOPE        = CBUUID(string: "00002002-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_MAGNETOMETER     = CBUUID(string: "00002003-C356-78AB-3C46-339399E84975")

/*UART SERVICE UUIDS*/
let UUID_SERVICE_UART                    = CBUUID(string: "00005000-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_TX               = CBUUID(string: "00005001-C356-78AB-3C46-339399E84975")
let UUID_CHARACTERISTIC_RX               = CBUUID(string: "00005002-C356-78AB-3C46-339399E84975")

class GattExample: JABLEGattProfile{
    
    var temperature                     : Bindable<Float?>      = Bindable(nil)
    var humidity                        : Bindable<Float?>      = Bindable(nil)
    var accelerometer                   : Bindable<[Float]?>    = Bindable(nil)
    var gyroscope                       : Bindable<[Float]?>    = Bindable(nil)
    var magnetometer                    : Bindable<[Float]?>    = Bindable(nil)
    var txChar                          : Bindable<Any?>        = Bindable(nil)
    var rxChar                          : Bindable<Any?>        = Bindable(nil)
    
    var environmentalService            : CBService?
    var temperatureCharacteristic       : CBCharacteristic?
    var humidityCharacteristic          : CBCharacteristic?
    
    var motionService                   : CBService?
    var accelerationCharacteristic      : CBCharacteristic?
    var gyroscopeCharacteristic         : CBCharacteristic?
    var magnetometerCharacteristc       : CBCharacteristic?
    
    var uartService                     : CBService?
    var txCharacteristic                : CBCharacteristic?
    var rxCharacteristic                : CBCharacteristic?
    
    
    init() {
        super.init(services:[
            
            /* ENVIRONMENTAL SERVICE */
            JABLEService(serviceUUID: UUID_SERVICE_ENVIRONMENTAL,
                         assignTo: environmentalService,
                         characteristics: [
                            JABLECharacteristic(characteristicUUID: UUID_CHARACTERISTIC_TEMPERATURE,
                                                assignTo: temperatureCharacteristic,
                                                descriptors: []),
                            JABLECharacteristic(characteristicUUID: UUID_CHARACTERISTIC_HUMIDITY,
                                                assignTo: humidityCharacteristic,
                                                descriptors: [])]),
            /* MOTION SERVICE */
            JABLEService(serviceUUID: UUID_SERVICE_MOTION,
                         assignTo: motionService,
                         characteristics: [
                            JABLECharacteristic(characteristicUUID: UUID_CHARACTERISTIC_ACCELERATION,
                                                assignTo: accelerationCharacteristic,
                                                descriptors: [])]),
            /* UART SERVICE */
            JABLEService(serviceUUID: UUID_SERVICE_UART,
                         assignTo: uartService,
                         characteristics: [
                            JABLECharacteristic(characteristicUUID: UUID_CHARACTERISTIC_TX,
                                                assignTo: txCharacteristic,
                                                descriptors: []),
                            JABLECharacteristic(characteristicUUID: UUID_CHARACTERISTIC_RX,
                                                assignTo: rxCharacteristic,
                                                descriptors: [])])
            ]
        )
    }
}















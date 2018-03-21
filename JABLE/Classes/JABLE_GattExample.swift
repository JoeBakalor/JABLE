//
//  JABLE_GattExample.swift
//  Pods-JABLE_Example
//
//  Created by Joe Bakalor on 2/23/18.
//
import Foundation
import CoreBluetooth


//DEFINE STIDGET SERVICE AND CHARACTERISTIC UUIDS
let JABLE_PRIMARY_SERVICE_UUID = CBUUID(string: "f79b4eb3-1b6e-41f2-8d65-d346b4ef5685")
let JABLE_RGB_LED_CHARACTERISTIC_UUID = CBUUID(string: "f79b4eb4-1b6e-41f2-8d65-d346b4ef5685")
let JABLE_ACCEL_RPM_GYRO_CHARACTERISTIC_UUID = CBUUID(string: "f79b4eb5-1b6e-41f2-8d65-d346b4ef5685")
let JABLE_TEMP_CHARACTERISTIC_UUID = CBUUID(string: "2A6E")


public class JABLE_GattExample: NSObject{
    
    //Create access variables
    var primaryService                  : CBService?
        var RGBLedCharacteristic        : CBCharacteristic?
        var accelRpmGyroCharacteristic  : CBCharacteristic?
        var tempCharacteristic          : CBCharacteristic?
    
    //var jableGattProfile: JABLE_GATT.JABLE_GATTProfile?
    
    override init() {
        super.init()
        
        //let serviceOne = JABLE_GATT.serviceNew
        /*var serviceOne = JABLE_GATT.service(service: &primaryService, uuid: JABLE_PRIMARY_SERVICE_UUID)
        let characteristicOne = JABLE_GATT.characteristic(characteristic: &RGBLedCharacteristic, uuid: JABLE_RGB_LED_CHARACTERISTIC_UUID, enableNotifications: false, descriptors: nil)
        let characteristicTwo = JABLE_GATT.characteristic(characteristic: &accelRpmGyroCharacteristic, uuid: JABLE_ACCEL_RPM_GYRO_CHARACTERISTIC_UUID, enableNotifications: false, descriptors: nil)
        let characteristicThree = JABLE_GATT.characteristic(characteristic: &tempCharacteristic, uuid: JABLE_TEMP_CHARACTERISTIC_UUID, enableNotifications: false, descriptors: nil)
        let services = JABLE_GATT.JABLE_Service(service: &serviceOne, characteristics: [characteristicOne, characteristicTwo, characteristicThree])
        
        jableGattProfile = JABLE_GATT.JABLE_GATTProfile(services: [services])*/
        
    }
    
}


class GattItem<T>
{
    typealias gattAssigner = (T) -> Void
    var gattItem: T

    
    init(_ item: T){
        gattItem = item
    }
}



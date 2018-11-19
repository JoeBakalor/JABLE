//
//  CoreBluetoothExtensions.swift
//  CorePlot
//
//  Created by Joe Bakalor on 10/23/18.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic{
    
    func dataBytes() -> [UInt8]{
        
        var data: Data? = self.value
        var dataBytes = [UInt8](repeating: 0, count: data!.count)
        (data! as NSData).getBytes(&dataBytes, length: data!.count)
        
        var hexValue = ""
        for value in data!{
            let hex = String(value, radix: 16)
            hexValue = hexValue + "0x\(hex) "
        }
        //print("Raw Hex = \(hexValue)")
        return dataBytes
    }
    
    func getAsciiString() -> String?{
        return String(bytes: self.dataBytes(), encoding: .utf8)
    }
    
    func friendlyProperties() -> CharacteristicProperties{
        return CharacteristicProperties(characteristic: self)
    }
}

/* Not working unless defined here.  Should not be an issues..?*/
public struct CharacteristicProperties{
    
    public var read: Bool
    public var write: Bool
    public var indicate: Bool
    public var notify: Bool
    public var broadcast: Bool
    public var writeWithoutResponse: Bool
    public var indicateEncryptionRequired: Bool
    public var authenticatedSignedWrites: Bool
    public var extendedProperties: Bool
    public var notifyEncryptionRequired: Bool
    
    public init(characteristic: CBCharacteristic){
        self.read                       = characteristic.properties.contains(.read)
        self.write                      = characteristic.properties.contains(.write)
        self.indicate                   = characteristic.properties.contains(.indicate)
        self.notify                     = characteristic.properties.contains(.notify)
        self.broadcast                  = characteristic.properties.contains(.broadcast)
        self.writeWithoutResponse       = characteristic.properties.contains(.writeWithoutResponse)
        self.indicateEncryptionRequired = characteristic.properties.contains(.indicateEncryptionRequired)
        self.authenticatedSignedWrites  = characteristic.properties.contains(.authenticatedSignedWrites)
        self.extendedProperties         = characteristic.properties.contains(.extendedProperties)
        self.notifyEncryptionRequired   = characteristic.properties.contains(.notifyEncryptionRequired)
    }
    
}

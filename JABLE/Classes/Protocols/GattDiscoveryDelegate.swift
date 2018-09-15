//
//  GattDiscoveryDelegate.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/13/18.
//

import Foundation
import CoreBluetooth

//MARK: GATT DISCOVERY DELEGATE PROTOCOL DEFINITION
@objc protocol GattDiscoveryDelegate{
    func central(didFind services: [CBService])
    func central(didFind characteristics: [CBCharacteristic], forService service: CBService)
    @objc optional func central(didFind descriptors: [CBDescriptor], forCharacteristic: CBCharacteristic)
}

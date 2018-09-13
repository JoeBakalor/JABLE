//
//  JABLEApi.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

protocol JABLEapi{
    func startLookingForPeripherals(withServiceUUIDs  uuids: [CBUUID]?)
    func stopLookingForPeripherals()
    func connect(toPeripheral peripheral: CBPeripheral, withOptions connectionOptions: ConnectionOptions)
    func diconnect(fromPeripheral peripheral: CBPeripheral)
    func disconnectAll()
    func discoverServices(withUUIDs uuids: [CBUUID]?, for peripheral: CBPeripheral)
    func discoverCharacteristics(forService service: CBService, withUUIDS uuids: [CBUUID]?, for peripheral: CBPeripheral)
    func write(value: Data, toCharacteristic characteristic: CBCharacteristic)
    func write(value: Data, toDescriptor descriptor: CBDescriptor)
    func read(valueFor characteristic: CBCharacteristic)
    func setup(gattProfile: JABLEGattProfile, forPeripheral peripheral: CBPeripheral)
    func RSSI()
}

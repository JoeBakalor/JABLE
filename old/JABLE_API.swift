//
//  JABLE_API.swift
//  Pods-JABLE_Example
//
//  Created by Joe Bakalor on 2/23/18.
//

import Foundation
import CoreBluetooth

protocol JABLE_API{
    func startScanningForPeripherals(withServiceUUIDs uuids: [CBUUID]?)
    func stopScanning()
    func connect(toPeripheral peripheral: CBPeripheral, withTimeout timeout: Int)
    func diconnect()
    func discoverServices(with uuids: [CBUUID]?, for peripheral: CBPeripheral)
    func discoverCharacteristics(forService service: CBService, withUUIDS uuids: [CBUUID]?, for peripheral: CBPeripheral)
    func write(value: Data, toCharacteristic characteristic: CBCharacteristic)
    func write(value: Data, toDescriptor descriptor: CBDescriptor)
    func read(valueFor characteristic: CBCharacteristic)
    func RSSI()
}


//
//  BLETopLevelController.swift
//  SelectComfort
//
//  Created by Joe Bakalor on 9/25/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol JABLEDelegate{
    
    func ready()
    func foundPeripheral(peripheral: CBPeripheral)
    func gattDiscoveryCompleted()
    
    func rssiUpdated(to rssi: Int)
    func foundServices(services: [CBService])
    func foundCharacteristics(forService service: CBService, characteristics: [CBCharacteristic])
    func foundDescriptors(forCharacteristic characteristic: CBCharacteristic, descriptors: [CBDescriptor])
    
    func valueUpdated(forCharacteristic characteristic: CBCharacteristic, value: Data)
    func valueUpdated(forDescriptor descriptor: CBDescriptor, value: Data)
    
}

//MARK: Use JABLE when GATT structure is known
public class JABLE: NSObject, GattDiscoveryCompletionDelegate
{
    fileprivate var _connectedPeripheral: CBPeripheral?
    fileprivate var _gattDiscoveryDelegate: GattDiscoveryDelegate?
    fileprivate var _jableCentralController: JABLE_CentralController!
    fileprivate var _jableGattProfile: JABLE_GATT?
    fileprivate var _jableDelegate: JABLEDelegate!
    fileprivate var _autoDiscovery: Bool = false
    fileprivate var _serviceDiscoveryUuids: [CBUUID] = []
    
    
    //CLASS INITIALIZATION
    init(jableDelegate: JABLEDelegate, gattProfile: inout JABLE_GATT.JABLE_GATTProfile?, autoGattDiscovery: Bool)
    {
        super.init()
        
        //Set JABLE delegate
        _jableDelegate = jableDelegate
        
        //INIT CENTRAL CONTROLLER WITHOUT GATT STRUCTURE, WE WILL DO THIS OURSELVES
        _jableCentralController = JABLE_CentralController(gapEventDelegate: self, gattEventDelegate: self, gattDiscoveryDelegate: self)
        
        
        //Check if auto gatt discovery is enabled and gatt profile is not nil
        guard autoGattDiscovery == true && gattProfile != nil else { return }
        
        //Initialize JABLE_GATT
        _autoDiscovery = true
        _jableGattProfile = JABLE_GATT(gattProfile: &gattProfile!, gattDiscoveryCompetionDelegate: self)//, controller: self)
        
        for includedService in (gattProfile?.services)!{
            _serviceDiscoveryUuids.append((includedService.service?.uuid)!)
        }
        
    }
    
    func gattDiscoveryCompleted() {
        print("Gatt discovery completed")
        _jableDelegate.gattDiscoveryCompleted()
    }
    
}

//MARK: JABLE_API API
extension JABLE: JABLE_API
{
    func RSSI() {
        
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func startScanningForPeripherals(withServiceUUIDs uuids: [CBUUID]?)
    {
        _jableCentralController.startScanningForPeripherals(withServiceUUIDS: uuids)
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func stopScanning()
    {
        _jableCentralController.stopScanning()
    }
    
    //CONNECT TO SPECIFIED PERIPHERAL USING TIMEOUT(SECONDS)
    //DISCONNECT FROM CONNECTED PERIPHERAL
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func connect(toPeripheral peripheral: CBPeripheral, withTimeout timeout: Int)
    {
        _jableCentralController.attemptConnection(toPeriperal: peripheral, timeout: timeout)
    }
    
    //DISCONNECT FROM CONNECTED PERIPHERAL
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func diconnect()
    {
        guard _connectedPeripheral != nil else { return }
        _jableCentralController.disconnect()
    }
    
    //DISCOVER SERVICES FOR CONNECTED PERIPHERAL. OPTIONALLY PROVIDE LIST OF SERVICE
    //UUIDS TO DISCOVER. TO DISCOVER ALL, SPECIFY NIL
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func discoverServices(with uuids: [CBUUID]?)
    {
        guard _connectedPeripheral != nil else { return }
        _jableCentralController.discoverServices(with: uuids)
        
    }
    
    //DISCOVER CHARACTERISTICS FOR SERVICE. OPTIONALLY PROVIDE LIST OF CHARACTERISTICS
    //UUIDS TO DISCOVER. TO DISCOVER ALL, SPECIFY NIL
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func discoverCharacteristics(forService service: CBService, withUUIDS uuids: [CBUUID]?)
    {
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.discoverCharacteristics(forService: service, with: uuids)
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func write(value: Data, toCharacteristic characteristic: CBCharacteristic)
    {
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.writeCharacteristic(value: value, characteristic: characteristic)
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func write(value: Data, toDescriptor descriptor: CBDescriptor)
    {
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.writeDescriptor(value: value, descriptor: descriptor)
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func read(valueFor characteristic: CBCharacteristic){
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.readValue(forCharacteristic: characteristic)
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func enableNotifications(forCharacteristic characteristic: CBCharacteristic)
    {
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.enableNotifications(forCharacteristic: characteristic)
    }
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func disableNotifications(forCharacteristic characteristic: CBCharacteristic)
    {
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.disableNotifications(forCharacteristic: characteristic)
    }
    
    
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parmeters:
     
     Additional details
     
     */
    func updateRSSI()
    {
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.checkRssi()
    }
}

//MARK: GAP EVENT DELEGATE METHODS
extension JABLE: GapEventDelegate
{
    internal func centralController(foundPeripheral peripheral: CBPeripheral, with advertisementData: [String : Any], rssi RSSI: Int)
    {
        if true{
            print("ADVERTISEMENT DATA = \(advertisementData)")
            //Advertisment Data Keys
            let connectable           = advertisementData["kCBAdvDataIsConnectable"] as? NSNumber
            print("CONNECTABLE = \(String(describing: connectable))")
            
            let manufacturerData      = advertisementData["kCBAdvDataManufacturerData"] as? NSData
            print("MANUFACTURER DATA = \(String(describing: manufacturerData))")
            
            let overflowServiceUUIDs  = advertisementData["kCBAdvDataOverflowServiceUUIDs"] as? [CBUUID]
            print("OVERFLOW SERVICE UUIDS = \(String(describing: overflowServiceUUIDs))")
            
            let serviceData           = advertisementData["kCBAdvDataServiceData"] as? [CBUUID : NSData]
            print("SERVICE DATA = \(String(describing: serviceData))")
            
            let services              = advertisementData["kCBAdvDataServiceUUIDs"] as? [UUID]
            print("SERVICES = \(String(describing: services))")
            
            let solicitedServiceUUIDs = advertisementData["kCBAdvDataSolicitedServiceUUIDs"] as? [CBUUID]
            print("SOLICITED SERVICE UUIDS = \(String(describing: solicitedServiceUUIDs))")
            
            let txPowerLevel          = advertisementData["kCBAdvDataTxPowerLevel"] as? NSNumber
            print("TX POWER LEVEL = \(String(describing: txPowerLevel))")
            
            let localName             = advertisementData["kCBAdvDataLocalName"] as? String
            print("LOCAL NAME = \(String(describing: localName))")
        }
    }
    
    internal func centralController(connectedTo peripheral: CBPeripheral)
    {
        _connectedPeripheral = peripheral
        if _autoDiscovery{
            _jableCentralController.startScanningForPeripherals(withServiceUUIDS: nil)
        }
    }
    
    internal func centralController(failedToConnectTo peripheral: CBPeripheral, with error: Error?)
    {
        _connectedPeripheral = nil
    }
    
    internal func centralController(disconnectedFrom peripheral: CBPeripheral, with error: Error?)
    {
        print("Peripheral Disconnected")
        _connectedPeripheral = nil
        
    }
    
    internal func centralController(updatedBluetoothStatusTo status: BluetoothState)
    {
        print("Updated Bluetooth Status to \(status)")
        switch status{
        case .off: print("radio off")
        case .on: print("radio on"); _jableDelegate.ready()
        case .resetting: print("radio resetting")
        case .unauthorized: print("unauthorized")
        case .unsupported: print("unsupported")
        case .unknown: print("Unknown")
        }
    }
}

//MARK: GATT EVENT DELEGATE METHODS
extension JABLE: GATTEventDelegate
{
    internal func gattClient(recievedNewValueFor characteristic: CBCharacteristic, value: Data?, error: Error?)
    {
        
    }
    
    internal func gattClient(wroteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        
    }
    
    internal func gattClient(updatedNotificationStatusFor characteristic: CBCharacteristic, error: Error?)
    {
        
    }
    
    internal func gattClient(recievedNewValueForD descriptor: CBDescriptor, value: Any?, error: Error?)
    {
        
    }
    
    internal func gattClient(wroteValueForD descriptor: CBDescriptor, error: Error?)
    {
        
    }
    
    internal func gattClient(updatedRssiFor peripheral: CBPeripheral, rssi: Int, error: Error?)
    {
        _jableDelegate.rssiUpdated(to: rssi)
    }
}

//MARK: GATT DISCOVERY DELEGATE METHODS
extension JABLE: GATTDiscoveryDelegate
{
    internal func gattClient(foundServices services: [CBService]?, forPeripheral peripheral: CBPeripheral, error: Error?)
    {
        
        if let discoveredServices = services{
            print("Found services: \(discoveredServices)")
        }
        
    }
    
    internal func gattClient(foundCharacteristics characteristics: [CBCharacteristic]?, forService service: CBService, error: Error?)
    {
        if let discoveredCharacteristics = characteristics{
            print("Found characteristics: \(discoveredCharacteristics)")
        }
    }
    
    internal func gattClient(foundDescriptors discriptors: [CBDescriptor]?, forCharacteristic: CBCharacteristic, error: Error?)
    {
        
    }
    
}


//
//  JABLE_GattClient.swift
//  JABLE
//
//  Created by Joe Bakalor on 2/21/18.

import Foundation
import CoreBluetooth


//MARK: DEBUG CONFIGURATION
struct DebugConfiguration{
    var debugPeripheral             = false
    var debugServices               = false
    var debugCharacteristics        = false
    var debugDescriptors            = false
}

//MARK: GATT Event Delegate Protocol Definition
protocol GATTEventDelegate: class{
    func gattClient(recievedNewValueFor characteristic: CBCharacteristic, value: Data?, error: Error?)
    func gattClient(wroteValueFor characteristic: CBCharacteristic, error: Error?)
    func gattClient(updatedNotificationStatusFor characteristic: CBCharacteristic, error: Error?)
    
    func gattClient(recievedNewValueForD descriptor: CBDescriptor, value: Any?, error: Error?)
    func gattClient(wroteValueForD descriptor: CBDescriptor, error: Error?)
    func gattClient(updatedRssiFor peripheral: CBPeripheral, rssi: Int, error: Error?)
}

//MARK: GATT DISCOVERY DELEGATE PROTOCOL DEFINITION
protocol GATTDiscoveryDelegate{
    func gattClient(foundServices services: [CBService]?, forPeripheral peripheral: CBPeripheral, error: Error?)
    func gattClient(foundCharacteristics characteristics: [CBCharacteristic]?, forService service: CBService, error: Error?)
    func gattClient(foundDescriptors discriptors: [CBDescriptor]?, forCharacteristic: CBCharacteristic, error: Error?)
}

//MARK:  BASE CLASS
public class JABLE_GattClient: NSObject, CBPeripheralDelegate
{
    //
    fileprivate var _gattEventDelegate: GATTEventDelegate?
    fileprivate var _gattDiscoveryDelegate: GATTDiscoveryDelegate?
    fileprivate var _gattServer: CBPeripheral!
    
    //CLASS INITIALIZATION - ONLY SETUP TO MANAGE A SINGLE PERIPHERAL AT A TIME BUT
    //POSSIBLE TO CREATE ADDITIONAL INSTANCES OF THIS CLASS FOR EACH PERIPHERAL
    init(withPeripheral peripheral: CBPeripheral, gattEventDelegate: GATTEventDelegate?, gattDiscoveryDelegate: GATTDiscoveryDelegate?)
    {
        super.init()
        
        //Set peripheral delegate
        peripheral.delegate = self
        
        //Set GATT server
        _gattServer = peripheral
        
        //Set GATT Event delegate
        _gattEventDelegate = gattEventDelegate
        
        //Set GATT Discovery Delegate
        _gattDiscoveryDelegate = gattDiscoveryDelegate
    }
    
    //CONFIGURE DEBUG OUTPUT
    func setDebugConfiguration(debugConfiguration: DebugConfiguration)
    {
        
    }
}

//MARK:  PERIPHERAL STATE UPDATES
public extension JABLE_GattClient
{
    //RSSI VALUE WAS UPDATED FOR PERIPHERAL
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?)
    {
        _gattEventDelegate?.gattClient(updatedRssiFor: peripheral, rssi: RSSI.intValue, error: error)
    }
    
    //PERIPHERAL UPDATED BT FRIENDLY NAME
    func peripheralDidUpdateName(_ peripheral: CBPeripheral)
    {
    }
    
    //USE THIS TO SEND DATA RATHER THAN SENDING USING WRITE WITH RESPONSE
    //THIS WILL ALLOW RELIABILITY EVEN WHEN USING WRITE W/0 RESPONSE
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral)
    {
    }
    
    //CALL THIS TO INITIATE A READ OF THE RSSI, DIDREADRSSI CALLED BY COREBT AFTER
    func getRssi()
    {
        if let peripheral = _gattServer{
            peripheral.readRSSI()
        }
    }
}

//MARK: GATT ACTION METHODS
extension JABLE_GattClient
{
    
    /**
     Discover gatt services
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
     Additional details
     
     */
    func startServiceDiscovery(services: [CBUUID]?)
    {
        _gattServer.discoverServices(services)
    }
    
    //DISCOVER CHARCTERISTICS FOR SERVICES, SET CHARACTERISTICS TO NIL TO FIND ALL
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
     Additional details
     
     */
    func startCharacteristicDiscovery(forService service: CBService, forCharacteristics characteristics: [CBUUID]?)
    {
        _gattServer?.discoverCharacteristics(characteristics, for: service)
    }
    
    /**
     Write value to characteristic
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
     Additional details
     
     */
    func writeCharacteristicValue(forCharacteristic characteristic: CBCharacteristic, value: Data, withResponse: Bool)//,dataType: enum(HEX, ASCII, ETC)
    {
        _gattServer?.writeValue(value, for: characteristic, type: .withResponse)
    }
    
    /**
     Read value for characteristic
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
     Additional details
     
     */
    func readCharacteristicValue(for characteristic: CBCharacteristic)
    {
        _gattServer?.readValue(for: characteristic)
    }
    
    //DISCOVER DISCRIPTORS FOR CHARACTERISTIC
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
     Additional details
     
     */
    func startDiscriptorDiscovery(forCharacteristic characteristic: CBCharacteristic)
    {
        _gattServer?.discoverDescriptors(for: characteristic)
    }
    
    //WRITE VALUE TO DESCRIPTOR
    /**
     Description
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
     Additional details
     
     */
    func writeDescriptorValue(forDescriptor descriptor: CBDescriptor, value: Data)
    {
        _gattServer?.writeValue(value, for: descriptor)
    }
    
}

//MARK:  SERVICE DELEGATE METHODS
public extension JABLE_GattClient
{
    
    //PERIPHERAL MODIFIED SERVICES ON GATTSERVER
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService])
    {
        
    }
    
    //DISCOVERED SERVICES FOR PERIPHERAL
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        let foundServices = peripheral.services
        //print("Found Services: \(foundServices)")
        //call delegate method
        _gattDiscoveryDelegate?.gattClient(foundServices: foundServices, forPeripheral: peripheral, error: error)
    }
}

//MARK:  CHARACTERISTIC DELEGATE METHODS
public extension JABLE_GattClient
{
    //DISCOVERED CHARACTERISTICS FOR SERVICE
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        let foundCharacteristics = service.characteristics
        print("Found Characteristics")
        //call delegate method
        _gattDiscoveryDelegate?.gattClient(foundCharacteristics: foundCharacteristics, forService: service, error: error)
    }
    
    //VALUE WAS UPDATED FOR CHARACTERISTIC
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        let updatedValue = characteristic.value
        
        //cString(describing: all d)elegate methods
        print("JABLE_GattClient: Char value updated")
        _gattEventDelegate?.gattClient(recievedNewValueFor: characteristic, value: updatedValue, error: error)
    }
    
    //VALUE WAS WRITTEN TO CHARACTERISTIC
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        //print("JABLE_GattClient: Wrote value for \(characteristic)")
        //call delegate method
        _gattEventDelegate?.gattClient(wroteValueFor: characteristic, error: error)
    }
    
    //NOTIFICATION STATE WAS UPDATED FOR CHARACTERISTIC
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)
    {
        //call delegate method
        _gattEventDelegate?.gattClient(updatedNotificationStatusFor: characteristic, error: error)
    }
    
}

//MARK:  DESCRIPTOR DELEGATE METHODS
public extension JABLE_GattClient
{
    //DISCOVERD DESCRIPTORS FOR CHARACTERISTIC
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?)
    {
        let foundDescriptors = characteristic.descriptors
        
        //Call delegate method
        _gattDiscoveryDelegate?.gattClient(foundDescriptors: foundDescriptors, forCharacteristic: characteristic, error: error)
    }
    
    //VALUE WAS UPDATED FOR DESCRIPTOR
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?)
    {
        let updatedValue = descriptor.value
        
        //Call delegate methods
        _gattEventDelegate?.gattClient(recievedNewValueForD: descriptor, value: updatedValue, error: error)
    }
    
    //VALUE WAS WRITTEN FOR DESCRIPTOR
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?)
    {
        
        //Call delegate method
        _gattEventDelegate?.gattClient(wroteValueForD: descriptor, error: error)
    }
}























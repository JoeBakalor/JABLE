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
    
    func jable(isReady: Void)
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvdertismentData)
    func jable(completedGattDiscovery: Void)
    
    func jable(updatedRssi rssi: Int)
    func jable(foundServices services: [CBService])
    func jable(foundCharacteristicsFor service: CBService, characteristics: [CBCharacteristic])
    func jable(foundDescriptorsFor characteristic: CBCharacteristic, descriptors: [CBDescriptor])
    
    func jable(updatedCharacteristicValueFor characteristic: CBCharacteristic, value: Data)
    func jable(updatedDescriptorValueFor descriptor: CBDescriptor, value: Data)
    
    func jable(connected: Void)
    func jable(disconnectedWithReason reason: Error?)
    
}

public struct FriendlyAdvdertismentData: CustomStringConvertible{
    public var connectable: Bool?
    public var manufacturerData: NSData?
    public var overflowServiceUUIDs: [CBUUID]?
    public var serviceData: [CBUUID: NSData]?
    public var services: [UUID]?
    public var solicitedServiceUUIDs: [CBUUID]?
    public var transmitPowerLevel: NSNumber?
    public var localName: String?
    public var rssi: Int?
    public var timeStamp: Date?
    public var seen: Int = 0
    public var advIntervalEstimate: Double?
    
    public var description: String{
        let noValue = "NO VALUE"
        let connectablePrintValue           = self.connectable != nil ? "\(self.connectable!)" : noValue
        let manufacturerDataPrintValue      = self.manufacturerData != nil ? "\(self.manufacturerData!)" : noValue
        let overflowServiceUUIDsPrintValue  = self.overflowServiceUUIDs != nil ? "\(self.overflowServiceUUIDs!)" : noValue
        let serviceDataPrintValue           = self.serviceData != nil ? "\(self.serviceData!)" : noValue
        let servicesPrintValue              = self.services != nil ? "\(self.services!)" : noValue
        let solicitedServiceUUIDsPrintValue = self.solicitedServiceUUIDs != nil ? "\(self.solicitedServiceUUIDs!)" : noValue
        let transmitPowerLevelPrintValue    = self.transmitPowerLevel != nil ? "\(self.transmitPowerLevel!)" : noValue
        let localNamePrintValue             = self.localName != nil ? "\(self.localName!)" : noValue
        let rssiPrintValue                  = self.rssi != nil ? "\(self.rssi!)" : noValue
        let timeStampPrintValue             = self.timeStamp != nil ? "\(self.timeStamp!)" : noValue
        let advIntervalEstimatePrintValue   = self.advIntervalEstimate != nil ? "\(self.advIntervalEstimate!)" : noValue
        
        return ("\n\r   Conectable: \(connectablePrintValue)\n\r   Manufacturer Data: \(manufacturerDataPrintValue)\n\r   Overflow Service UUIDs: \(overflowServiceUUIDsPrintValue)\n\r   ServiceData: \(serviceDataPrintValue)\n\r   Services: \(servicesPrintValue)\n\r   Solicited Service UUIDs: \(solicitedServiceUUIDsPrintValue)\n\r   Transmit Power Level: \(transmitPowerLevelPrintValue)\n\r   Local Name: \(localNamePrintValue)\n\r   RSSI: \(rssiPrintValue)\n\r  Adv Estimate: \(advIntervalEstimatePrintValue)")
    }
}

public struct JABLEScanFilter{
    public var name: String?
    public var rssiGreaterThan: Int?
    public var devicesHasName: Bool?
    public var connectableDeviceOnly: Bool?
    public init(_name: String?, _rssiGreaterThan: Int?, _deviceHasName: Bool?, _connectableDeviceOnly: Bool?){
        self.name = _name
        self.rssiGreaterThan = _rssiGreaterThan
        self.devicesHasName = _deviceHasName
        self.connectableDeviceOnly = _connectableDeviceOnly
    }
}

public struct JABLECharacteristicProperties{
    public var read = false//characteristic.properties.contains(.read)
    public var write = false//characteristic.properties.contains(.write)
    public var indicate = false//characteristic.properties.contains(.indicate)
    public var notify = false//characteristic.properties.contains(.notify)
    
    public var broadcast = false//characteristic.properties.contains(.broadcast)
    public var writeWithoutResponse = false//characteristic.properties.contains(.writeWithoutResponse)
    
    public var indicateEncryptionRequired = false//characteristic.properties.contains(.indicateEncryptionRequired)
    public var authenticatedSignedWrites = false//characteristic.properties.contains(.authenticatedSignedWrites)
    
    public var extendedProperties = false//characteristic.properties.contains(.extendedProperties)
    public var notifyEncryptionRequired = false//characteristic.properties.contains(.notifyEncryptionRequired)

}


//MARK: Use JABLE when GATT structure is known
open class JABLE: NSObject, GattDiscoveryCompletionDelegate, JABLE_API
{
    fileprivate var _connectedPeripheral: CBPeripheral?
    fileprivate var _gattDiscoveryDelegate: GattDiscoveryDelegate?
    fileprivate var _jableCentralController: JABLE_CentralController!
    fileprivate var _jableGattProfile: JABLE_GATT?
    fileprivate var _jableDelegate: JABLEDelegate!
    fileprivate var _autoDiscovery: Bool = false
    fileprivate var _serviceDiscoveryUuids: [CBUUID] = []
    fileprivate var _scanFilter: JABLEScanFilter?
    fileprivate var _unprocessedServices: [CBService]?
    
    
    //var test: JABLE_GATT.JABLE_GATTProfile?

    /**
     JABLE initialization
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     
        - jableDelegate:      Delegate to receive all JABLE generated events
     
        - gattProfile:        Reference to the GATT profile that should be populated upon GATT discovery
     
        - autoGattDiscovery:  Set to true to enable automatic service and characteristic discovery using
                              the provide GATT profile
     
     JABLE provides central mode functionality inlcuding GAP and GAP event management, GATT a GATT event managment
     in a single library making BLE integration easier than managing and adopting multiple delegate protocols.  JABLE
     automatically manages peripheral connectivity and decreases the number of parameters required to interact with
     a peripheral GATT profile.  JABLE also provide automated GATT profile discovery
     
     */
    public init(jableDelegate: JABLEDelegate, gattProfile: inout JABLE_GATT.JABLE_GATTProfile?, autoGattDiscovery: Bool){
        
        super.init()
        
        //test = gattProfile
        
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
        
        print("JABLE: Started")
    }
    
    
    /**
     Read the name of the currently connected peripheral
     
     - Author:
     Joe Bakalor
     
     - returns:
     The name of the currently connected peripheral or NA if invalid
     
     - throws:
     nothing
     
     Only one scan filter supported currently
     */
    public func peripheralName() -> String{
        guard let peripheral = _connectedPeripheral else { return "NA"}
        guard let name = peripheral.name else { return "NA"}
        return name
    }
    /**
     Add scan filter to peripheral scan results
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
        - filter: JABLEScanFilter defining what peripherals should be removed from scan results
     
     Only one scan filter supported currently
     
     */
    public func addScanFilter(filter: JABLEScanFilter){
        
        _scanFilter = filter
    }
    
    
    /**
     Initiate RSSI update
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     This will trigger an RSSI read on the connected peripheral.  When completed the
     didUpdateRssi delegate method will be called
     */
    public func RSSI() {
        
        _jableCentralController.checkRssi()
    }
    
    
    /**
     Initiate scanning for bluetooth low energy peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
        - uuids: service uuids that peripherals should contain. Specify nil to scan for all peripherals
     
     Starts scanning for advertising BLE peripherals that include the specified service UUIDs in their
     advertisment data
     
     */
    public func startScanningForPeripherals(withServiceUUIDs uuids: [CBUUID]?){
        
        _jableCentralController.startScanningForPeripherals(withServiceUUIDS: uuids)
    }
    
    
    /**
     Stop scanning for BLE peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     */
    public func stopScanning(){
        
        _jableCentralController.stopScanning()
    }
    

    /**
     Connect to specified peripheral using the timeout value provided
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
        - peripheral: the peripheral to connect to
        - timeout: the timeout value in seconds
     
     After timeout expires, the connection will be terminated if it is still pending
     */
    public func connect(toPeripheral peripheral: CBPeripheral, withTimeout timeout: Int){
        
        print("JABLE: ATTEMPT CONNECTION")
        _jableCentralController.attemptConnection(toPeriperal: peripheral, timeout: timeout)
    }
    

    /**
     Disconnect from the currently connected peripheral
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     If there is not a valid connection, nothing
     
     */
    public func diconnect(){
        guard _connectedPeripheral != nil else { return }
        _jableCentralController.disconnect()
    }
    

    /**
     Discover services on the connected BLE peripheral
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     nothing
     
     - parameters:
     - uuids:
     
     Additional details
     
     */
    public func discoverServices(with uuids: [CBUUID]?){
        
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
     
     - parameters:
     
     Additional details
     
     */
    public func discoverCharacteristics(forService service: CBService, withUUIDS uuids: [CBUUID]?){
        
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
     
     - parameters:
     
     Additional details
     
     */
    public func write(value: Data, toCharacteristic characteristic: CBCharacteristic){
        
        print("JABLE: Attempt write to \(characteristic)")
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
     
     - parameters:
     
     Additional details
     
     */
    func write(value: Data, toDescriptor descriptor: CBDescriptor){
        
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
     
     - parameters:
     
     Additional details
     
     */
    public func read(valueFor characteristic: CBCharacteristic){
        
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
     
     - parameters:
     
     Additional details
     
     */
    public func getCharacteristicProperties(forCharacteristic characteristic: CBCharacteristic) -> JABLECharacteristicProperties{
        
        var properties = JABLECharacteristicProperties()
        
        properties.broadcast = characteristic.properties.contains(.broadcast)
        properties.extendedProperties = characteristic.properties.contains(.extendedProperties)
        properties.indicate = characteristic.properties.contains(.indicate)
        properties.notify = characteristic.properties.contains(.notify)
        properties.notifyEncryptionRequired = characteristic.properties.contains(.notifyEncryptionRequired)
        properties.indicateEncryptionRequired = characteristic.properties.contains(.indicateEncryptionRequired)
        properties.read = characteristic.properties.contains(.read)
        properties.write = characteristic.properties.contains(.write)
        properties.writeWithoutResponse = characteristic.properties.contains(.writeWithoutResponse)
        properties.authenticatedSignedWrites = characteristic.properties.contains(.authenticatedSignedWrites)
        
        return properties
    }
    
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
    public func enableNotifications(forCharacteristic characteristic: CBCharacteristic){
        
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
     
     - parameters:
        - characteristic: The characteristic to disable notifications for
     
     Additional details
     
     */
    public func disableNotifications(forCharacteristic characteristic: CBCharacteristic){
        
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
     
     Additional details
     
     */
    public func updateRSSI(){
        
        guard _connectedPeripheral != nil else { return /*ERROR*/ }
        _jableCentralController.checkRssi()
    }
}

//MARK: GAP EVENT DELEGATE METHODS
extension JABLE: GapEventDelegate
{
    
    internal func centralController(foundPeripheral peripheral: CBPeripheral, with advertisementData: [String : Any], rssi RSSI: Int){
        
        //print("JABLE: FOUND PERIPHERAL")
        var friendlyAdvertisementData = FriendlyAdvdertismentData()
        if true{
            
            //print("ADVERTISEMENT DATA = \(advertisementData)")
            //Advertisment Data Keys
            let connectable           = advertisementData["kCBAdvDataIsConnectable"] as? NSNumber
            //print("CONNECTABLE = \(String(describing: connectable))")
            friendlyAdvertisementData.connectable = connectable == 1 ? true : false
            
            let manufacturerData      = advertisementData["kCBAdvDataManufacturerData"] as? NSData
            //print("MANUFACTURER DATA = \(String(describing: manufacturerData))")
            friendlyAdvertisementData.manufacturerData = manufacturerData
            
            let overflowServiceUUIDs  = advertisementData["kCBAdvDataOverflowServiceUUIDs"] as? [CBUUID]
            //print("OVERFLOW SERVICE UUIDS = \(String(describing: overflowServiceUUIDs))")
            friendlyAdvertisementData.overflowServiceUUIDs = overflowServiceUUIDs
            
            let serviceData           = advertisementData["kCBAdvDataServiceData"] as? [CBUUID : NSData]
            //print("SERVICE DATA = \(String(describing: serviceData))")
            friendlyAdvertisementData.serviceData = serviceData
            
            let services              = advertisementData["kCBAdvDataServiceUUIDs"] as? [UUID]
            //print("SERVICES = \(String(describing: services))")
            friendlyAdvertisementData.services = services
            
            let solicitedServiceUUIDs = advertisementData["kCBAdvDataSolicitedServiceUUIDs"] as? [CBUUID]
            //print("SOLICITED SERVICE UUIDS = \(String(describing: solicitedServiceUUIDs))")
            friendlyAdvertisementData.solicitedServiceUUIDs = solicitedServiceUUIDs
            
            let txPowerLevel          = advertisementData["kCBAdvDataTxPowerLevel"] as? NSNumber
            //print("TX POWER LEVEL = \(String(describing: txPowerLevel))")
            friendlyAdvertisementData.transmitPowerLevel = txPowerLevel
            
            let localName             = advertisementData["kCBAdvDataLocalName"] as? String
//            print("LOCAL NAME = \(String(describing: localName))")
            
            friendlyAdvertisementData.localName = localName
            friendlyAdvertisementData.rssi = RSSI
            friendlyAdvertisementData.timeStamp = Date()
        }
        
        if let filterName = _scanFilter?.name{ // Check if filter is present
            
            guard let locaName = friendlyAdvertisementData.localName else { return } // Check for valid name or quit
            guard filterName == locaName else { return }
        }
        
        if let connectable = _scanFilter?.connectableDeviceOnly{
            
            guard let isConnectable = friendlyAdvertisementData.connectable else {return}
            guard connectable == isConnectable else { return }
        }
        
        if let rssi = _scanFilter?.rssiGreaterThan{
            
            print("JABLE RSSI = \(rssi)")
            if let returnedRSSI = friendlyAdvertisementData.rssi{
                
                guard rssi <= returnedRSSI else { return }
            }
        }
        
        if let hasName = _scanFilter?.devicesHasName{
            
            if !hasName{
                
                if friendlyAdvertisementData.localName == nil{
                    return
                }
            }
        }
        
        _jableDelegate.jable(foundPeripheral: peripheral, advertisementData: friendlyAdvertisementData)
    }
    
    internal func centralController(connectedTo peripheral: CBPeripheral){
        
        _connectedPeripheral = peripheral
        _jableDelegate.jable(connected: ())
        if _autoDiscovery{
            
            print("JABLE: START AUTO GATT DISCOVERY")
            _jableCentralController.discoverServices(with: nil)//.startScanningForPeripherals(withServiceUUIDS: nil)
        }
    }
    
    internal func centralController(failedToConnectTo peripheral: CBPeripheral, with error: Error?){
        
        print("Peripheral Disconnected")
        _jableDelegate.jable(disconnectedWithReason: error)
        _connectedPeripheral = nil
    }
    
    internal func centralController(disconnectedFrom peripheral: CBPeripheral, with error: Error?){
        
        print("Peripheral Disconnected")
        _jableDelegate.jable(disconnectedWithReason: error)
        _connectedPeripheral = nil
        
    }
    
    internal func centralController(updatedBluetoothStatusTo status: BluetoothState){
        
        print("Updated Bluetooth Status to \(status)")
        
        switch status{
        case .off: print("radio off")
        case .on: _jableDelegate.jable(isReady: ())//ready()
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
    internal func gattClient(recievedNewValueFor characteristic: CBCharacteristic, value: Data?, error: Error?){
        
        if let data = value{
            
            _jableDelegate.jable(updatedCharacteristicValueFor: characteristic, value: data)
        }
    }
    
    internal func gattClient(wroteValueFor characteristic: CBCharacteristic, error: Error?){
        
    }
    
    internal func gattClient(updatedNotificationStatusFor characteristic: CBCharacteristic, error: Error?){
        
    }
    
    internal func gattClient(recievedNewValueForD descriptor: CBDescriptor, value: Any?, error: Error?){
        
    }
    
    internal func gattClient(wroteValueForD descriptor: CBDescriptor, error: Error?){
        
    }
    
    internal func gattClient(updatedRssiFor peripheral: CBPeripheral, rssi: Int, error: Error?){
        
        _jableDelegate.jable(updatedRssi: rssi)//rssiUpdated(to: rssi)
    }
}

//MARK: GATT DISCOVERY DELEGATE METHODS
extension JABLE: GATTDiscoveryDelegate
{
    //  Called by JABLE_GattClient
    public func gattDiscoveryCompleted() {
        
        print("Gatt discovery completed")
        _jableDelegate.jable(completedGattDiscovery: ())//gattDiscoveryFinished()
    }
    
    //  Called by JABLE_GattClient
    internal func gattClient(foundServices services: [CBService]?, forPeripheral peripheral: CBPeripheral, error: Error?){
        
        guard _autoDiscovery == false else {
            
            guard let _services = services else { return }
            
            //  Provide sercices to GATT profile for assignment
            _jableGattProfile?.central(didFind: _services)
            //_jableCentralController.discoverCharacteristics(forService: _services[0], with: nil)
            _unprocessedServices = _services
            processGattServices()
            return
        }
        
        if let discoveredServices = services{
            _jableDelegate.jable(foundServices: discoveredServices)//foundServices(services: discoveredServices)
        }
        
    }
    
    
    //  Called by JABLE_GattClient
    internal func gattClient(foundCharacteristics characteristics: [CBCharacteristic]?, forService service: CBService, error: Error?){
        
        guard _autoDiscovery == false else {
            
            guard let _characteristics = characteristics else { return }
            
            //  Provide characteristics to GATT profile for assignment
            _jableGattProfile?.central(didFind: _characteristics, forService: service)
            
            processGattServices()
            return
        }
        
        if let discoveredCharacteristics = characteristics{
            
            _jableDelegate.jable(foundCharacteristicsFor: service, characteristics: discoveredCharacteristics)
        }
    }
    
    
    internal func processGattServices(){
        
        guard let unprocessedServices = _unprocessedServices else { return }
        
        guard unprocessedServices.count > 0 else {
            
            _jableDelegate.jable(completedGattDiscovery: ())
            print("JABLE: Auto GATT Discovery completed")
            //print("JABLE: \(_jableGattProfile?._gattProfile)")
            return
        }
        _jableCentralController.discoverCharacteristics(forService: unprocessedServices.first!, with: nil)
        _unprocessedServices?.removeFirst()
    }
    
    //  Called by JABLE_GattClient
    internal func gattClient(foundDescriptors discriptors: [CBDescriptor]?, forCharacteristic: CBCharacteristic, error: Error?){
        
    }
    
}



/*===============================================================================================================================*/
//extension Date
//{
//    var formatted: String
//    {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm:ss.SS' "//use HH for 24 hour scale and hh for 12 hour scale
//        formatter.timeZone = TimeZone.autoupdatingCurrent//(forSecondsFromGMT: 4)
//        formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter.string(from: self)
//    }
//}


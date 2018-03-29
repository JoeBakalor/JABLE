//
//  JABLE_CentralController.swift
//  JABLE
//
//  Created by Joe Bakalor on 2/21/18.
//


//
//  BLECentralController.swift
//  BLU
//
//  Created by Joe Bakalor on 4/6/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BluetoothState{
    case off
    case on
    case unauthorized
    case unknown
    case resetting
    case unsupported
}

//MARK:  GAP EVENT DELEGATE PROTOCOL DEFINITION
protocol GapEventDelegate{
    func centralController(foundPeripheral peripheral: CBPeripheral, with advertisementData: [String: Any], rssi RSSI: Int)
    func centralController(connectedTo peripheral: CBPeripheral)
    func centralController(failedToConnectTo peripheral: CBPeripheral, with error: Error?)
    func centralController(disconnectedFrom peripheral: CBPeripheral, with error: Error?)
    func centralController(updatedBluetoothStatusTo status: BluetoothState)
}

//MARK: BASE CLASS
public class JABLE_CentralController: NSObject
{
    //VARIABLE DECLARATIONS
    fileprivate var centralManager        : CBCentralManager?
    var peripheralPendingConnection       : CBPeripheral?
    var connectedPeripheral               : CBPeripheral?
    var gattClient                        : JABLE_GattClient?
    var delegate                          : GapEventDelegate?
    
    //Private variable declarations
    fileprivate var _connectedPeripheral: CBPeripheral?
    fileprivate var _peripheralPendingConnection: CBPeripheral?
    
    fileprivate var _connectionTimeoutTimer: Timer?
    fileprivate var _centralManager: CBCentralManager!
    fileprivate var _gattClientInstance: JABLE_GattClient?
    fileprivate var _gapEventDelegate: GapEventDelegate!
    fileprivate var _gattDiscoveryDelegate: GATTDiscoveryDelegate!
    fileprivate var _gattEventDelegate: GATTEventDelegate!
    
    /**
     JABLE_CentralController initialization
     
     - Author:
     Joe Bakalor
     
     - returns:
     CBManagerState
     
     - throws:
     Nothing
     
     - parameters:
        - gapEventDelegate: The delegate to recieve GAP events
        - gattEventDelegate: The delegate to recieve GATT events
        - gattDiscoveryDelegate: The delegate to recieve GATT discovery process events
     
     Additional details
     
     */
    init(gapEventDelegate: GapEventDelegate, gattEventDelegate: GATTEventDelegate, gattDiscoveryDelegate: GATTDiscoveryDelegate){
        
        super.init()
        
        //Set internal reference to GAP Event Delegate
        _gapEventDelegate = gapEventDelegate
        
        //Set internal reference to GATT Event Delegate
        _gattEventDelegate = gattEventDelegate
        
        //Set internal reference to GATT Discovery Delegate
        _gattDiscoveryDelegate = gattDiscoveryDelegate
        
        //Initialize internal CBCentralManager
        _centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    
}

//MARK: CENTRAL CONTROLER ACTION METHODS
extension JABLE_CentralController
{
    /**
     Get the current state of the central manager
     
     - Author:
     Joe Bakalor
     
     - returns:
     CBManagerState
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    @available(iOS 10.0, *)
    func getCBManagerState() -> CBManagerState{
        
        return _centralManager.state
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func discoverServices(with uuids: [CBUUID]?){
        
        if let gattClient = _gattClientInstance{
            
            gattClient.startServiceDiscovery(services: uuids)
        }
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func discoverCharacteristics(forService service: CBService,with uuids: [CBUUID]?){
        
        if let gattClient = _gattClientInstance{
            
            gattClient.startCharacteristicDiscovery(forService: service, forCharacteristics: nil)
        }
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func readValue(forCharacteristic characteristic: CBCharacteristic){
        
        if _connectedPeripheral != nil{
            
            _connectedPeripheral?.readValue(for: characteristic)
        }
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func writeCharacteristic(value: Data, characteristic: CBCharacteristic){
        
        if _connectedPeripheral != nil{
            
            _connectedPeripheral?.writeValue(value, for: characteristic, type: .withResponse)
        }
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func writeDescriptor(value: Data, descriptor: CBDescriptor){
        
        if _connectedPeripheral != nil{
            
            _connectedPeripheral?.writeValue(value, for: descriptor)
        }
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func enableNotifications(forCharacteristic characteristic: CBCharacteristic){
        
        if _connectedPeripheral != nil{
            
            _connectedPeripheral?.setNotifyValue(true, for: characteristic)
        }
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func disableNotifications(forCharacteristic characteristic: CBCharacteristic){
        
        if _connectedPeripheral != nil{
            
            _connectedPeripheral?.setNotifyValue(false, for: characteristic)
        }
    }
    
    /**
     Get the current state of the central manager
     
     - Author:
     Joe Bakalor
     
     - returns:
     CBManagerState
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func checkRssi(){
        
        if let peripheral = _connectedPeripheral{
            
            peripheral.readRSSI()
        }
    }
    /**
     Start scanning for peripherals with included service uuids.
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     - UUIDS:  List of Service UUIDs that returned peripherals should include.
     
     Additional details
     
     */
    func startScanningForPeripherals(withServiceUUIDS UUIDS: [CBUUID]?){
        
        //Check if service UUIDs have been specified
        guard let uuids = UUIDS else {
            
            print("JABLE_CentralController: START SCANNING")
            //Otherwise scan for all peripherals
            _centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true, CBCentralManagerScanOptionAllowDuplicatesKey: true])
            return
        }
        
        //Scan for peripherals with included services
        _centralManager.scanForPeripherals(withServices: uuids, options: [CBCentralManagerOptionShowPowerAlertKey: true, CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    /**
     Stop scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     Nothing
     
     Additional details
     
     */
    func stopScanning(){
        
        _centralManager.stopScan()
    }
    
    /**
     Try to connect to peripheral for duration of timeout period specified--After timeout expires, cancel connection
     attempt
     
     - Author:
     Joe Bakalor
     
     - returns:
     CBManagerState
     
     - throws:
     nothing
     
     - parameters:
     - peripheral: The peripheral to connect to.
     
     Additional details
     
     */
    func attemptConnection(toPeriperal peripheral: CBPeripheral, timeout: Int){
        
        //Save reference to peripheral we are trying to connect
        _peripheralPendingConnection = peripheral
        
        //Initiate connection to specificied peripheral
        _centralManager.connect(peripheral, options: [CBConnectPeripheralOptionStartDelayKey: true,
                                                      CBConnectPeripheralOptionNotifyOnConnectionKey: false,
                                                      CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
                                                      CBConnectPeripheralOptionNotifyOnNotificationKey: false])
        //Set connection timeout timer
        _connectionTimeoutTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeout), target: self, selector: #selector(_cancelConnectionAttempt), userInfo: nil, repeats: false)
    }
    
    /**
     Cancel current connection or current connection attempt
     
     - Author:
     Joe Bakalor
     
     - returns:
     CBManagerState
     
     - throws:
     nothing
     
     - parameters:
     - peripheral: The peripheral to connect to disconnect from or cancel connection attempt to.
     
     Additional details
     
     */
    func disconnect(){
        
        if let peripheral = _connectedPeripheral {
            
            _centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /**
     Cancel current connection or current connection attempt
     
     - Author:
     Joe Bakalor
     
     - returns:
     CBManagerState
     
     - throws:
     nothing
     
     - parameters
     - peripheral: The peripheral to connect to disconnect from or cancel connection attempt to.
     
     Additional details
     
     */
    func getConnectedPeripherals(withServices services: [CBUUID]?){
        
    }
    
    @objc fileprivate func _cancelConnectionAttempt(){
        
        if let pendingPeripheral = _peripheralPendingConnection{
            
            _centralManager.cancelPeripheralConnection(pendingPeripheral)
        }
    }
}

//MARK: CENTRAL MANAGER DELEGATE METHODS
extension JABLE_CentralController: CBCentralManagerDelegate
{
    //CALLED FOR SUCCESSFUL CONNECTION TO PERIPHERAL
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        //Initialize internal GATT Client instance
        _gattClientInstance = JABLE_GattClient(withPeripheral: peripheral, gattEventDelegate: _gattEventDelegate , gattDiscoveryDelegate: _gattDiscoveryDelegate)
        
        //Save reference to connected peripheral and set pending peripheral to nil
        _connectedPeripheral = peripheral
        _peripheralPendingConnection = nil
        
        //Call GAP Event delegate method
        _gapEventDelegate.centralController(connectedTo: peripheral)
    }
    
    //CALLED WHEN PERIPHERAL DISCONNECTION OCCURS
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        
        print("Disconnected with ERROR: \(String(describing: error))")
        
        //Set connected to peripheral to nil
        _connectedPeripheral = nil
        
        //Call GAP Event delegate method
        _gapEventDelegate.centralController(disconnectedFrom: peripheral, with: error)
    }
    
    //CALLED FOR EACH PERIPHERAL DISCOVERED
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        
        //Advertisment Data Keys
        /*
         //  CBAdvertisementDataIsConnectable
         //  CBAdvertisementDataLocalNameKey
         //  CBAdvertisementDataManufacturerDataKey
         //  CBAdvertisementDataOverflowServiceUUIDsKey
         //  CBAdvertisementDataServiceDataKey
         //  CBAdvertisementDataSolicitedServiceUUIDsKey
         //  CBAdvertisementDataTxPowerLevelKey
         */
        
        //Call GAP Event delegate method
        //print("JABLE_CentralController: FOUND PERIPHERAL")
        _gapEventDelegate.centralController(foundPeripheral: peripheral, with: advertisementData, rssi: RSSI.intValue)
    }
    
    //  CALLED WHEN CONNECTION ATTEMPT TO PERIPHERAL FAILS
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        
        //Set pending peripheral connection to nil
        _peripheralPendingConnection = nil
        
        //Call GAP Event delegate method
        _gapEventDelegate.centralController(failedToConnectTo: peripheral, with: error)
        
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager){
        
        if #available(iOS 10.0, *){
            
            switch (central.state)
            {
            case CBManagerState.poweredOff:
                print("CBManager Powered Off")
                _gapEventDelegate.centralController(updatedBluetoothStatusTo: .off)
                break
                
            case CBManagerState.unauthorized:
                _gapEventDelegate.centralController(updatedBluetoothStatusTo: .unauthorized)
                break
                
            case CBManagerState.unknown:
                _gapEventDelegate.centralController(updatedBluetoothStatusTo: .unknown)
                break
                
            case CBManagerState.poweredOn:
                _gapEventDelegate.centralController(updatedBluetoothStatusTo: .on)
                break
                
            case CBManagerState.resetting:
                _gapEventDelegate.centralController(updatedBluetoothStatusTo: .resetting)
                break
                
            case CBManagerState.unsupported:
                _gapEventDelegate.centralController(updatedBluetoothStatusTo: .unsupported)
                break
            }
        }else{
            
        }
    }
}























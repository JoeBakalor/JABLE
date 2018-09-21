//
//  JABLENew.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth



public class JABLECentral: NSObject{
    
    struct PeripheralConnection{
        var peripheral: CBPeripheral
        var connectionOptions: ConnectionOptions
    }
    
    struct ScanRequest{
        var serviceUUIDs: [CBUUID]?
    }
    
    /*  Helper classes */
    //private let scanResultsManager = ScanResultManager()
    
    /*  Pending state variables */
    private var pendingScanRequest: ScanRequest?
    private var peripheralPendingReconnection: PeripheralConnection?
    private var peripheralPendingConnection: PeripheralConnection?
    
    /*  Delegates */
    private var jableDelegate: JABLEDelegateNew?
    
    /*  State variables */
    private var peripheralsToConnectQueue: [PeripheralConnection] = []
    private var connectedPeripherals: [Int: PeripheralConnection] = [:]
    private var centralController: CBCentralManager?
    private var activeGattDiscoveryProcess: GattDiscoveryProcess?
    private var pendingGattDiscoveryProcesses: [GattDiscoveryProcess] = []
    private var jableIsReady = false
    
    /*  Timers */
    private var connectionTimeoutTimer: Timer?
    private var reconnectionTimeoutTimer: Timer?
    
    /*  Manage and assign peripheral IDs */
    private var jableIDManager: JABLEiDManager!
    
    public override init() {
        super.init()
        jableIDManager = JABLEiDManager()
        centralController = CBCentralManager(
            delegate: self,
            queue: nil,
            options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
}

extension JABLECentral: JABLECentralAPI{
    
    /**/
    public func setDelegate(delegate: JABLEDelegateNew?){
        self.jableDelegate = delegate
    }
    
    
    /**/
    public func setup(gattProfile: JABLEGattProfile, forPeripheral peripheral: CBPeripheral) {
        
        guard activeGattDiscoveryProcess == nil else {
            pendingGattDiscoveryProcesses.append(GattDiscoveryProcess(gatt: gattProfile, peripheral: peripheral))
            return
        }
        
        activeGattDiscoveryProcess = GattDiscoveryProcess(gatt: gattProfile, peripheral: peripheral)
        peripheral.discoverServices(nil)
        
    }
    
    /**/
    public func startLookingForPeripherals(withServiceUUIDs uuids: [CBUUID]?) {
        
        guard jableIsReady else { pendingScanRequest =  ScanRequest(serviceUUIDs: uuids); return }
        
        guard let validUUIDs = uuids
            else {
            centralController?.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerOptionShowPowerAlertKey: true,
                          CBCentralManagerScanOptionAllowDuplicatesKey: true]);
            return
            }
        
        centralController?.scanForPeripherals( withServices: validUUIDs,
                                               options: [CBCentralManagerOptionShowPowerAlertKey: true,
                                                         CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    /**/
    public func stopLookingForPeripherals() {
        centralController?.stopScan()
    }
    
    /**/
    public func connect(toPeripheral peripheral: CBPeripheral, withOptions connectionOptions: ConnectionOptions) {
        
        guard peripheralPendingConnection == nil && peripheralPendingReconnection == nil
            else {
                peripheralsToConnectQueue.append(PeripheralConnection(peripheral: peripheral, connectionOptions: connectionOptions))
            return
            }
        
        peripheralPendingConnection = PeripheralConnection(peripheral: peripheral, connectionOptions: connectionOptions)
        centralController?.connect(
            peripheral,
            options: [CBConnectPeripheralOptionStartDelayKey: true,
                      CBConnectPeripheralOptionNotifyOnConnectionKey: true,
                      CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
                      CBConnectPeripheralOptionNotifyOnNotificationKey: false])
        
        if let connectionTimeout = connectionOptions.connectionTimeout{
            connectionTimeoutTimer = Timer.scheduledTimer(
                timeInterval: TimeInterval(connectionTimeout),
                target: self,
                selector: #selector(cancelPeripheralConnection),
                userInfo: nil,
                repeats: false)
        }

    }
    
    /**/
    @objc private func cancelPeripheralConnection(){
        
        if let peripheral = peripheralPendingConnection?.peripheral{
            centralController?.cancelPeripheralConnection(peripheral)
            peripheralPendingConnection = nil
        } else if let peripheral = peripheralPendingReconnection?.peripheral{
            centralController?.cancelPeripheralConnection(peripheral)
            peripheralPendingReconnection = nil
        }
    }
    
    /**/
    public func diconnect(fromPeripheral peripheral: CBPeripheral) {
        centralController?.cancelPeripheralConnection(peripheral)
    }
    
    /**/
    public func disconnectAll() {
        
    }
    
    /**/
    public func discoverServices(withUUIDs uuids: [CBUUID]?, for peripheral: CBPeripheral) {
        peripheral.discoverServices(uuids)
    }

    /**/
    public func discoverCharacteristics(forService service: CBService, withUUIDS uuids: [CBUUID]?, for peripheral: CBPeripheral) {
        peripheral.discoverCharacteristics(uuids, for: service)
    }
    
    /**/
    public func write(value: Data, toCharacteristic characteristic: CBCharacteristic, forPeripheral peripheral: CBPeripheral) {
        peripheral.writeValue(value, for: characteristic, type: .withoutResponse)
    }
    
    /**/
    public func write(value: Data, toDescriptor descriptor: CBDescriptor, forPeripheral peripheral: CBPeripheral) {
        peripheral.writeValue(value, for: descriptor)
    }
    
    /**/
    public func read(valueFor characteristic: CBCharacteristic, onPeripheral peripheral: CBPeripheral) {
        peripheral.readValue(for: characteristic)
    }
    
    /**/
    public func RSSI() {
        //peripheral.readRSSI()
    }
}

extension JABLECentral: CBCentralManagerDelegate{
    
    /**/
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        guard peripheral == peripheralPendingConnection?.peripheral else { print("We did something out of order "); return }
        connectedPeripherals[jableIDManager.newPeripheralID()] = peripheralPendingConnection
    }
    
    /**/
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let advData = FriendlyAdvertisement(advertisementData: advertisementData, rssi: Int(truncating: RSSI), peripheral: peripheral)
        jableDelegate?.jable(foundPeripheral: peripheral, advertisementData: advData)
        print("RAW ADV DATA: \(advertisementData)")
        
        print("Services: \(advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID])")
    }
    
    /**/
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        connectedPeripherals = connectedPeripherals.filter { (id, peripheralConnection) -> Bool in

            if peripheral == peripheralConnection.peripheral {
                
                if peripheralConnection.connectionOptions.shouldAttemptReconnection && peripheralConnection.connectionOptions.retries == 0{
                    
                    connectedPeripherals[id]?.connectionOptions.retries += 1
                    
                    if peripheralPendingConnection != nil {
                        
                        peripheralsToConnectQueue.append(PeripheralConnection(
                            peripheral: peripheral,
                            connectionOptions: (connectedPeripherals[id]?.connectionOptions)!))
                        
                    } else {
                        
                        peripheralPendingReconnection = PeripheralConnection(
                            peripheral: peripheral,
                            connectionOptions: (connectedPeripherals[id]?.connectionOptions)!)
                        
                        self.connect(toPeripheral: (peripheralPendingConnection?.peripheral)!,
                                     withOptions: (peripheralPendingConnection?.connectionOptions)!)
                
                        if let reconnectionTimeout = peripheralConnection.connectionOptions.reconnectionTimeout{
                            reconnectionTimeoutTimer = Timer.scheduledTimer(
                                timeInterval: reconnectionTimeout,
                                target: self,
                                selector: #selector(cancelPeripheralConnection),
                                userInfo: nil ,
                                repeats: false)
                        }
                    }; return false
                }
            }; return true
        }
    }
    
    /**/
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    /**/
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }

    /**/
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *){
            switch (central.state){
            case CBManagerState.poweredOff: break
            case CBManagerState.unauthorized: break
            case CBManagerState.unknown: break
            case CBManagerState.poweredOn:
                //print("Bluetooth Ready!")
                if let scanRequest = pendingScanRequest{
                    pendingScanRequest = nil
                    jableIsReady = true
                    self.startLookingForPeripherals(withServiceUUIDs: scanRequest.serviceUUIDs)
                }
                break
            case CBManagerState.resetting: break
            case CBManagerState.unsupported:break
            }
        }
    }
}


extension JABLECentral: CBPeripheralDelegate{
    
    /**/
    public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        
    }
    
    /**/
    @available(iOS 11.0, *)
    public func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
    }
    
    /*=========================== DISCOVERY EVENTS ===============================*/
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let services = peripheral.services{
            activeGattDiscoveryProcess?.discoveryAgent.central(didFind: services)
            jableDelegate?.jable(foundServices: services, forPeripheral: peripheral)
        }
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characteristics = service.characteristics{
            activeGattDiscoveryProcess?.discoveryAgent.central(didFind: characteristics, forService: service)
        }
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
        if let descriptors = characteristic.descriptors{
            activeGattDiscoveryProcess?.discoveryAgent.central(didFind: descriptors, forCharacteristic: characteristic)
        }
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
    }
    
    /*=========================== WRITE CALLBACKS ===============================*/
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    /*=========================== VALUE UPDATE EVENTS ===============================*/
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    /**/
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
}



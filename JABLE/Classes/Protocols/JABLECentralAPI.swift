//
//  JABLEApi.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

protocol JABLECentralAPI{
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
        - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func startLookingForPeripherals(withServiceUUIDs  uuids: [CBUUID]?)
    
    /**
     Stops scanning for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     */
    func stopLookingForPeripherals()
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func connect(toPeripheral peripheral: CBPeripheral, withOptions connectionOptions: ConnectionOptions)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func diconnect(fromPeripheral peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func disconnectAll()
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func discoverServices(withUUIDs uuids: [CBUUID]?, for peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func discoverCharacteristics(forService service: CBService, withUUIDS uuids: [CBUUID]?, for peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func write(value: Data, toCharacteristic characteristic: CBCharacteristic, forPeripheral peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func write(value: Data, toDescriptor descriptor: CBDescriptor, forPeripheral peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func read(valueFor characteristic: CBCharacteristic, onPeripheral peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func setup(gattProfile: JABLEGattProfile, forPeripheral peripheral: CBPeripheral)
    
    /**
     Intitiate scan for peripherals
     
     - Author:
     Joe Bakalor
     
     - returns:
     Nothing
     
     - throws:
     Nothing
     
     - parameters:
     
     - uuids: The service uuids that peripherals should include
     
     If nil is provided as the service uuid parameter, the scan results will include all peripherls found
     */
    func RSSI()
}













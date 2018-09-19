//
//  JABLEDelegate.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth
//import JABLE

public protocol JABLEDelegateNew{
    
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
    func jable(isReady: Void)
    
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
    func jable(foundPeripheral peripheral: CBPeripheral, advertisementData: FriendlyAdvertisement)
    
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
    func jable(completedGattDiscovery: Void)
    
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
    func jable(updatedRssi rssi: Int, forPeripheral peripheral: CBPeripheral)
    
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
    func jable(foundServices services: [CBService], forPeripheral peripheral: CBPeripheral)
    
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
    func jable(foundCharacteristicsFor service: CBService, characteristics: [CBCharacteristic])
    
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
    func jable(foundDescriptorsFor characteristic: CBCharacteristic, descriptors: [CBDescriptor])
    
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
    func jable(updatedCharacteristicValueFor characteristic: CBCharacteristic, value: Data, onPeripheral peripheral: CBPeripheral)
    
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
    func jable(updatedDescriptorValueFor descriptor: CBDescriptor, value: Data)
    
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
    func jable(connectedTo peripheral: CBPeripheral)
    
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
    func jable(disconnectedWithReason reason: Error?, from peripheral: CBPeripheral)
}





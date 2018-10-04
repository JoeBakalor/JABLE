//
//  JABLE_GATT.swift
//  JABLE
//
//  Created by Joe Bakalor on 2/21/18.
//

import Foundation
import CoreBluetooth

@objc
protocol GattDiscoveryDelegate{
    func central(didFind services: [CBService])
    func central(didFind characteristics: [CBCharacteristic], forService service: CBService)
    @objc optional func central(didFind descriptors: [CBDescriptor], forCharacteristic: CBCharacteristic)
}

@objc
protocol GattUpdateDelegate{
    @objc optional func gattUpdated(characteristicValueFor characteristic: CBCharacteristic)
    @objc optional func gattUpdated(descriptorValueFor descriptor: CBDescriptor)
}

public protocol GattDiscoveryCompletionDelegate{
    func gattDiscoveryCompleted()
}

public func assignTo<T>(_ item: UnsafeMutablePointer<T>) -> (T) -> Void{
    return {item.pointee = $0}
}

public protocol GattProfile{
    var gattProfile: JABLE_GATT.JABLE_GATTProfile! { get set }
}

//MARK: BASE CLASS
public class JABLE_GATT: NSObject{
    
    public typealias Completion<T> = (T) -> Void
    
    public class JABLE_Descriptor{
        
        var uuid: CBUUID
        var completion: Completion<CBDescriptor>?
        
        public init(descriptorUUID: CBUUID, whenFound: Completion<CBDescriptor>?){
            self.uuid = descriptorUUID
            self.completion = whenFound
        }
    }
    
    public class JABLE_Characteristic{
        
        public var uuid: CBUUID
        public var descriptors: [JABLE_Descriptor]?
        public var completion: Completion<CBCharacteristic>?
        
        public init(characteristicUUID: CBUUID, whenFound: Completion<CBCharacteristic>?, descriptors: [JABLE_Descriptor]?){
            self.uuid = characteristicUUID
            self.descriptors = descriptors
            self.completion = whenFound
        }
    }
    
    public class JABLE_Service{
        
        public var uuid: CBUUID
        public var completion: Completion<CBService>?
        public var characteristics: [JABLE_Characteristic]?
        
        public init(serviceUUID: CBUUID, whenFound: Completion<CBService>?, characteristics: [JABLE_Characteristic]?){
            self.uuid = serviceUUID
            self.characteristics = characteristics
            self.completion = whenFound
        }
    }
    
    public class JABLE_GATTProfile{
        
        public var services: [JABLE_Service]
        
        public init(services: [JABLE_Service]){
            self.services = services
        }
    }
    
    fileprivate var _centralController              : JABLE?
    fileprivate var _gattDiscoveryCompletionDelegate: GattDiscoveryCompletionDelegate!
    fileprivate var _gattProfile                    : JABLE_GATTProfile?
    
    
    init(gattProfile: JABLE_GATTProfile, gattDiscoveryCompetionDelegate: GattDiscoveryCompletionDelegate){
        super.init()
        
        _gattProfile = gattProfile
        _gattDiscoveryCompletionDelegate = gattDiscoveryCompetionDelegate
    }
}

//MARK: GattDiscoveryDelegate
extension JABLE_GATT: GattDiscoveryDelegate{
    
    // Called by central controller when services discovered
    public func central(didFind services: [CBService]) {
        
        //Make sure there are services defined for the gatt profile
        guard _gattProfile?.services != nil else { return }//?.services != nil else { return }
        
        //Iterate over each of the found services
        for Service in services{
            
            //Iterate over each of the user services defined for the gatt profile
            for index in (_gattProfile?.services)!.indices{//(_gattProfile?.services)!.indices{
                
                if Service.uuid == (_gattProfile?.services)![index].uuid{//?.services)![index].service?.uuid{
                    
                    //Assign service
                    //Completion should probably not be optional but we will see
                    _gattProfile?.services[index].completion!(Service)//?.services[index].service?.completion?(Service) //= Service
                    print("JABLE_GATT: ASSIGNED SERVICE \(Service.uuid)")
                }
            }
        }
    }
    
    //  Called by central controller when characteristics found for service
    public func central(didFind characteristics: [CBCharacteristic], forService service: CBService) {
        
        //Make sure there are services defined for gatt profile
        guard _gattProfile?.services != nil else { return }
        
        //Find the matching service
        for serviceIndex in (_gattProfile?.services.indices)!{
            
            if _gattProfile?.services[serviceIndex].uuid == service.uuid{
                
                //Iterate over each of the found characteristics
                for Characteristic in characteristics{
                    
                    //Make sure there are characteristics defined for service
                    guard _gattProfile?.services[serviceIndex].characteristics != nil else { return }
                    
                    //Iterate over each of the user characteristics defined for service
                    for characteristicIndex in (_gattProfile?.services[serviceIndex].characteristics?.indices)!{
                        
                        if Characteristic.uuid == (_gattProfile?.services[serviceIndex].characteristics)![characteristicIndex].uuid{
                            
                            //Assign characteristic
                            _gattProfile?.services[serviceIndex].characteristics?[characteristicIndex].completion?(Characteristic)
                            print("JABLE_GATT: ASSIGNED CHARACTERISTIC \(Characteristic.uuid)")
                        }
                    }
                }
            }
        }
    }
    
    public func central(didFind descriptors: [CBDescriptor], forCharacteristic: CBCharacteristic) {
        
    }
    
}

//MARK: GattUpdateDelegate
extension JABLE_GATT: GattUpdateDelegate{
    
    func gattUpdated(characteristicValueFor characteristic: CBCharacteristic) {
    }
    
    func gattUpdated(descriptorValueFor descriptor: CBDescriptor) {
    }
    
}




























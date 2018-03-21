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


//MARK: BASE CLASS
public class JABLE_GATT: NSObject{
    
    //
    public struct descriptor{
        
        var descriptor: CBDescriptor?
        var uuid:  CBUUID
    }
    
    //
    public typealias CharacteristicCompletion = (CBCharacteristic) -> Void
    
    public struct characteristic{
        public var characteristic: CBCharacteristic?// = UnsafeMutablePointer<CBCharacteristic?>.allocate(capacity: 1)
        public var uuid: CBUUID
        public var enableNotifications: Bool = false
        public var characteristicCompletion: CharacteristicCompletion?
        public var descriptors: [descriptor]?
        
        public init(characteristic: inout CBCharacteristic?, uuid: CBUUID, enableNotifications: Bool, descriptors: [descriptor]?, characteristicCompletion: CharacteristicCompletion?){
            
            self.characteristic = characteristic
            self.uuid = uuid
            self.enableNotifications = enableNotifications
            self.descriptors = descriptors
            self.characteristicCompletion = characteristicCompletion
        }
    }
    
    //
    public typealias ServiceCompletion = (CBService) -> Void
    public struct service{
        
        public var service: CBService?//CBService?// = UnsafeMutablePointer<CBService?>.allocate(capacity: 1)
        public var uuid: CBUUID
        var serviceCompletion: ServiceCompletion?
        
        public init(service: inout CBService?, uuid: CBUUID, assigner: @escaping ServiceCompletion){
            
            self.service = service
            self.uuid = uuid
            self.serviceCompletion = assigner
        }
    }
    
    //
    public struct JABLE_Service {
        
        public var service: service?
        public var characteristics: [characteristic]?
        
        public init(service: service?, characteristics: [characteristic]?){
            
            self.service = service
            self.characteristics = characteristics
        }
    }
     
    //
    public struct JABLE_GATTProfile {
        
        public var services: [JABLE_Service]
        public init(services: [JABLE_Service]){
            
            self.services = services
        }
    }
    
    var _gattProfile: JABLE_GATTProfile?
    fileprivate var _centralController: JABLE?
    fileprivate var _gattDiscoveryCompletionDelegate: GattDiscoveryCompletionDelegate!
    
    
    //Initialize class with pointer to gatt profile and central contoller instance
    init(gattProfile: inout JABLE_GATTProfile, gattDiscoveryCompetionDelegate: GattDiscoveryCompletionDelegate){
        
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
        guard _gattProfile?.services != nil else { return }
        
        //Iterate over each of the found services
        for Service in services{
            
            //Iterate over each of the user services defined for the gatt profile
            for index in (_gattProfile?.services)!.indices{
                
                if Service.uuid == (_gattProfile?.services)![index].service?.uuid{
                    
                    //Assign service
                    
                    _gattProfile?.services[index].service?.serviceCompletion?(Service) //= Service
                    //print("JABLE_GATT: ASSIGNED SERVICE \((_gattProfile?.services[index].service?.service)!)")
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
            
            if _gattProfile?.services[serviceIndex].service?.uuid == service.uuid{
                
                //Iterate over each of the found characteristics
                for Characteristic in characteristics{
                    
                    //Make sure there are characteristics defined for service
                    guard _gattProfile?.services[serviceIndex].characteristics != nil else { return }
                    
                    //Iterate over each of the user characteristics defined for service
                    for characteristicIndex in (_gattProfile?.services[serviceIndex].characteristics?.indices)!{
                        
                        if Characteristic.uuid == (_gattProfile?.services[serviceIndex].characteristics)![characteristicIndex].uuid{
                            
                            //Assign characteristic
                            _gattProfile?.services[serviceIndex].characteristics?[characteristicIndex].characteristicCompletion?(Characteristic)//.characteristic = Characteristic
                            print("JABLE_GATT: ASSIGNED CHARACTERISTIC \(Characteristic.uuid)")
                        }
                    }
                }
            }
        }
    }
}

//MARK: GattUpdateDelegate
extension JABLE_GATT: GattUpdateDelegate{
    
    func gattUpdated(characteristicValueFor characteristic: CBCharacteristic) {
    }
    
    func gattUpdated(descriptorValueFor descriptor: CBDescriptor) {
    }
    
}




















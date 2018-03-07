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
    public struct characteristic{
        var characteristic: CBCharacteristic?
        var uuid: CBUUID
        var enableNotifications: Bool = false
        var descriptors: [descriptor]?
    }
    
    //
    public struct service{
        var service: CBService?
        var uuid: CBUUID
        
        public init(service: CBService? = nil, uuid: CBUUID){
            self.service = service
            self.uuid = uuid
        }
    }
    
    //
    public struct JABLE_Service {
        var service: service?
        var characteristics: [characteristic]?
    }
    
    //
    public struct JABLE_GATTProfile {
        var services: [JABLE_Service]
    }
    
    fileprivate var _gattProfile: JABLE_GATTProfile?
    fileprivate var _centralController: JABLE?
    fileprivate var _serviceCount = 0
    fileprivate var _gattDiscoveryCompletionDelegate: GattDiscoveryCompletionDelegate!
    
    
    //Initialize class with pointer to gatt profile and central contoller instance
    init(gattProfile: inout JABLE_GATTProfile, gattDiscoveryCompetionDelegate: GattDiscoveryCompletionDelegate){//}, controller: JABLE){
        super.init()
        _gattProfile = gattProfile
        _gattDiscoveryCompletionDelegate = gattDiscoveryCompetionDelegate
    }
}

//MARK: GattDiscoveryDelegate
extension JABLE_GATT: GattDiscoveryDelegate{
    
    // Called by central controller when services discovered
    func central(didFind services: [CBService]) {
        
        _serviceCount = services.count
        
        //Make sure there are services defined for the gatt profile
        guard _gattProfile?.services != nil else { return }
        
        //Iterate over each of the found services
        for Service in services{
            
            //Iterate over each of the user services defined for the gatt profile
            for index in (_gattProfile?.services)!.indices{
                
                if Service.uuid == (_gattProfile?.services)![index].service?.uuid{
                    
                    //Assign service
                    _gattProfile?.services[index].service?.service = Service
                }
            }
        }
    }
    
    
    //  Called by central controller when characteristics found for service
    func central(didFind characteristics: [CBCharacteristic], forService service: CBService) {
        
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
                            _gattProfile?.services[serviceIndex].characteristics?[characteristicIndex].characteristic = Characteristic
                        }
                    }
                }
            }
        }
        
        _serviceCount -= 1
        
        if _serviceCount == 0{
            print("Gatt discovery completed")
            _gattDiscoveryCompletionDelegate.gattDiscoveryCompleted()
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




















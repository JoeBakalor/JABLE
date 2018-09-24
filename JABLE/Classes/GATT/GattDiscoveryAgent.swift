//
//  JABLEGattDiscoveryAgent.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

public class GattDiscoveryAgent: NSObject{

    var gattDiscoveryCompleted: Bindable<Bool> =  Bindable(false)
    
    weak private var peripheral                 : CBPeripheral?
    weak private var gattProfile                : JABLEGattProfile?
    private var unprocessedServices             : [CBService] = []
    private var unprocessedCharacteristics      : [CBCharacteristic] = []
    
    init(gattProfile: JABLEGattProfile, peripheral: CBPeripheral){
        self.gattProfile = gattProfile
    }
}

//MARK: GattDiscoveryDelegate
extension GattDiscoveryAgent: GattDiscoveryDelegate{
    
    public func central(didFind services: [CBService]) {
        
        guard let gattServices = gattProfile?.services else { return }
        self.unprocessedServices = services
        
        gattServices.forEach { (jableService) in
            services.forEach({ (discoveredService) in
                if discoveredService.uuid == jableService.uuid{
                    jableService.assignToService = discoveredService}})}
        
        processGattServices()
    }
    
    public func central(didFind characteristics: [CBCharacteristic], forService service: CBService) {
        
        guard let services = gattProfile?.services else { return }
        self.unprocessedCharacteristics = characteristics
        
        services.forEach { (jableService) in
            if jableService.uuid == service.uuid{
                jableService.characteristics.forEach({ (jableCharacteristic) in
                    characteristics.forEach({ (discoveredCharacteristic) in
                        if discoveredCharacteristic == jableCharacteristic.uuid{
                            jableCharacteristic.assignToCharacteristic = discoveredCharacteristic}})})}}
        
        processGattCharacteristics()

    }
    
    public func central(didFind descriptors: [CBDescriptor], forCharacteristic: CBCharacteristic) {

        guard let services = gattProfile?.services else { return }
        services.forEach { (jableService) in
            jableService.characteristics.forEach({ (jableCharacteristic) in
                if jableCharacteristic.uuid == forCharacteristic.uuid{
                    jableCharacteristic.descriptors.forEach({ (jableDescriptor) in
                        descriptors.forEach({ (discoveredDescriptor) in
                            if discoveredDescriptor.uuid == jableDescriptor.uuid{
                                jableDescriptor.assignToDescriptor = discoveredDescriptor}})})}})}
        
        processGattCharacteristics()
    }
}

extension GattDiscoveryAgent{
    
    internal func processGattServices(){
        
        guard unprocessedServices.count > 0 else { gattDiscoveryCompleted.value = true; return }
        guard let validPeripheral = self.peripheral else { return }
        guard let nextService = unprocessedServices.first else { return }
        validPeripheral.discoverCharacteristics(nil , for: nextService)
        unprocessedServices.removeFirst()
    }
    
    internal func processGattCharacteristics(){
        
        if unprocessedCharacteristics.count > 0 {
            guard let validPeripheral = self.peripheral else { return }
            guard let nextCharacteristic = unprocessedCharacteristics.first else { return }
            validPeripheral.discoverDescriptors(for: nextCharacteristic)
            unprocessedCharacteristics.removeFirst()
        } else {
            processGattServices()
        }
    }
}





















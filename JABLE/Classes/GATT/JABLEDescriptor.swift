//
//  JABLEDescriptor.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

public class JABLEDescriptor{
    
    public var uuid: CBUUID
    weak public var assignToDescriptor: CBDescriptor?
    
    public init(descriptorUUID: CBUUID, assignTo descriptor: CBDescriptor){
        self.uuid = descriptorUUID
        self.assignToDescriptor = descriptor
    }
}

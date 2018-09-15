//
//  JABLEGattProfile.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation


open class JABLEGattProfile{
    
    public var services: [JABLEService]
    public init(services: [JABLEService]){
        self.services = services
    }
}

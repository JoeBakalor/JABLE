//
//  GATTTableViewCellModel.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CoreBluetooth

class GATTTableViewCellModel{
    var service: CBService
    init(service: CBService) {
        self.service = service
    }
}

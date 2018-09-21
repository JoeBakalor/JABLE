//
//  JableCollectionViewCellModel.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import JABLE

class JableCollectionViewCellModel{
    
    var data: TrackedScanResult
    var collectionIndex: Int?
    var optionsViewShown: Bool
    
    init(data: TrackedScanResult, collectionIndex: Int?, optionsViewShown: Bool) {
        self.data = data
        self.collectionIndex = collectionIndex
        self.optionsViewShown = optionsViewShown
    }
}

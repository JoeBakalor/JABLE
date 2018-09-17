//
//  ScanConfiguration.swift
//  CorePlot
//
//  Created by Joe Bakalor on 9/15/18.
//

import Foundation


struct ScanConfiguration{
    var maxNumberResults: Int
    var removeAfter: TimeInterval //if not seen for interval, remove
    var scanFilters: [ScanFilter]
}

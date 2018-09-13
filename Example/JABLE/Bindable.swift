//
//  File.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation


import Foundation
import CoreBluetooth


class Bindable<T>{
    
    var isAvailable: Bool = true
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T{
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T){
        self.value = value
    }
    
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
        
        if listener != nil {
            isAvailable = false
        } else {
            isAvailable = true
        }
    }
}

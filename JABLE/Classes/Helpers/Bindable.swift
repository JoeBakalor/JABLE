//
//  Bindable.swift
//  CorePlot
//
//  Created by Joe Bakalor on 9/18/18.
//

import Foundation

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

class MultiBindable<T>{
    
    typealias Listener = (T) -> Void
    typealias BindingID = Int
    
    var listeners: [Int: Listener?] = [:]
    var currentBindingID: Int = 0
    
    var value: T{
        didSet{
            listeners.forEach { (binding) in
                binding.value?(value)
            }
        }
    }
    
    init(_ value: T){
        self.value = value
    }
    
    func bind(listener: Listener?) -> BindingID{
        
        defer { currentBindingID += 1 }
        
        listeners[currentBindingID] = listener
        listener?(value)
        return currentBindingID
    }
    
    func deleteBinding(withID id: BindingID){
        listeners.removeValue(forKey: id)
    }
    
    func removeAllBindings(){
        listeners = [:]
    }
}

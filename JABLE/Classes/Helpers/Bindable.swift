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

class Connection<T>{
    
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
    
    func onChange(listener: Listener?){
        self.listener = listener
        listener?(value)
    }
}

class Observable<T>{
    
    typealias Observer = (T) -> Void
    typealias BindingID = Int
    
    var observers: [Int: Observer?] = [:]
    var currentBindingID: Int = 0
    
    var value: T{
        didSet{
            observers.forEach { (binding) in
                binding.value?(value)
            }
        }
    }
    
    init(_ value: T){
        self.value = value
    }
    
    func bind(observer: Observer?) -> BindingID{
        defer { currentBindingID += 1 }
        observers[currentBindingID] = observer
        observer?(value)
        return currentBindingID
    }
    
    func deleteBinding(withID id: BindingID){
        observers.removeValue(forKey: id)
    }
    
    func removeAllBindings(){
        observers = [:]
    }
}

class ObservableT<T>{
    
    typealias _observer = (T) -> Void
    var observer: _observer?
}

class SequenceType<T>{
//
//    typealias observer = (T) -> Void
////
////    let sequenceObservers: [String: ObservableT?] = [
////        "EVENT_X" : nil,
////        "EVENT_Y" : nil,
////        "EVENT_Z" : nil
////    ]
//
//
//    var value: T?{
//        didSet{
//
//        }
//    }
//    init(_ value: T) {
//        self.value = value
//    }
//
//    func onEvent(handler: observer) -> SequenceType<T>{
//        sequenceObservers["EVENT_X"] = handler
//        return self
//    }
//
//    func onNotEvent() -> SequenceType<T>{
//        return self
//    }
}

class test{
    init() {
        //let test = SequenceType("TEST").onEvent().onNotEvent()
    }
}

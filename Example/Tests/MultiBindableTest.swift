//
//  MultiBindableTest.swift
//  JABLE_Tests
//
//  Created by Joe Bakalor on 9/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import JABLE

class MultiBindableTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMultiBindingModel(){
        
        let multiBindableValue: Observable<Int> = Observable(0)
        
        let bindIDOne = multiBindableValue.bind { (newValue) in
            print("\nBinding One Updated to \(newValue)")
        }
        
        let bindIDTwo = multiBindableValue.bind { (newValue) in
            print("\nBinding Two Updated to \(newValue)")
        }
        
        let bindIDThree = multiBindableValue.bind { (newValue) in
            print("\nBinding Three Updated to \(newValue)")
        }
        
        let bindIDFour = multiBindableValue.bind { (newValue) in
            print("\nBinding four Updated to \(newValue)")
        }
        
        multiBindableValue.value = 0
        
        multiBindableValue.deleteBinding(withID: bindIDOne)
        
        multiBindableValue.value = 1
        
        multiBindableValue.deleteBinding(withID: bindIDTwo)
        
        multiBindableValue.value = 2
        
        multiBindableValue.deleteBinding(withID: bindIDThree)
        
        multiBindableValue.value = 3
        
        multiBindableValue.deleteBinding(withID: bindIDFour)
        
        multiBindableValue.value = 4
        
    }


}

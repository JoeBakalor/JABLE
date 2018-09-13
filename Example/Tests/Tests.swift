import XCTest
import JABLE

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        let onePoundBags = getOnePoundBags(totalWieght: 4, fiveBoundBags: 1, onePoundBags: 9)
        print("Number of one pound bags: \(onePoundBags)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
}


func createPackage(small: Int, big: Int, goal: Int) -> Int {
    guard (Double(small) - Double(goal).truncatingRemainder(dividingBy: 5)) > 0 else { return -1}
    return Int(Double(goal).truncatingRemainder(dividingBy: 5))
    
}



func getOnePoundBags(totalWieght: Double, fiveBoundBags: Double, onePoundBags: Double) -> Double {
    guard onePoundBags - totalWieght.truncatingRemainder(dividingBy: 5) > 0 else { return -1}
    return totalWieght.truncatingRemainder(dividingBy: 5)
}

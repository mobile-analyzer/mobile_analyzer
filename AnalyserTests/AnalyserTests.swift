import XCTest
@testable import Analyser
import Firebase




class AnalyserTests: XCTestCase {
    
    func testDate2() {
        let value = 3
        let squaredValue = value.square()
        XCTAssertEqual(squaredValue, 27)
        
    }
    
    
    func testAlertMessagew() {
        var helloWorld: String?
        XCTAssertNil(helloWorld)
        helloWorld = "helloWorld"
        XCTAssertEqual(helloWorld, "helloWorld")
    }

}

import Foundation

class CategoryItem {
    
    let name: String
    let realValue: Double
    let expectedValue: Double
    
    init(name: String, realValue: Double, expectedValue: Double) {
        self.name = name
        self.realValue = realValue
        self.expectedValue = expectedValue
    }
    
}

import Foundation

class CategoryItem: Equatable {
    static func == (lhs: CategoryItem, rhs: CategoryItem) -> Bool {
        lhs.name == rhs.name
        && lhs.expectedValue == rhs.expectedValue
    }
    
    let name: String
    let realValue: Double
    let expectedValue: Double
    
    init(name: String, realValue: Double, expectedValue: Double) {
        self.name = name
        self.realValue = realValue
        self.expectedValue = expectedValue
    }
    
}

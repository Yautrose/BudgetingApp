import Foundation

class Categories {
    
    static var arrayOfCategoryItem: [CategoryItem] = []
    
    static func addNewCategory(_ name: String,_ expextedValue: Double) {
        arrayOfCategoryItem.append(CategoryItem(name: name, realValue: 0, expectedValue: expextedValue))
    }
    
}


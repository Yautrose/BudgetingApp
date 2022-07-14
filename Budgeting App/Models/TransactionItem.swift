import Foundation

class TransactionItem {
    
    let name: String
    let category: CategoryItem
    let cost: Double
    let date: Date
    
    init(name: String, category: CategoryItem, cost: Double, date: Date) {
        self.name = name
        self.category = category
        self.cost = cost
        self.date = date
    }
 
    func addNewTransaction (name: String, category: CategoryItem, cost: Double, date: Date) {
        
    }
}

import Foundation

class Transactions {
    
    static var arrayOfTransactionItem: [TransactionItem] = []
    
    static func addNewTransaction (name: String, category: CategoryItem, cost: Double, date: Date) {
        arrayOfTransactionItem.append(TransactionItem(name: name, cost: cost, date: date))
    }
    
}

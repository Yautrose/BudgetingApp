import Foundation
import RealmSwift

class Transactions {
    
    static func addNewTransaction (name: String, category: CategoryItem, cost: Double, date: Date) {
        let realm = try! Realm()
        try! realm.write {
            let transaction = TransactionItem(name: name, cost: cost, date: date)
            category.transactions.append(transaction)
        }
    }
    
    static func deleteTransaction(_ transaction: TransactionItem) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(transaction)
        }
    }
}

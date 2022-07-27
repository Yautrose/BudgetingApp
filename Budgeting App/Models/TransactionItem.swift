import Foundation
import RealmSwift

class TransactionItem: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var cost: Double
    @Persisted var date: Date
    @Persisted(originProperty: "transactions")
    var category: LinkingObjects<CategoryItem>
    
    convenience init(id: String = UUID().uuidString, name: String,  cost: Double, date: Date) {
        self.init()
        self.id = id
        self.name = name
        self.cost = cost
        self.date = date
    }
    
}

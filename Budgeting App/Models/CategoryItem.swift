import Foundation
import RealmSwift

class CategoryItem: Object {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var realValue: Double
    @Persisted var transactions: List<TransactionItem>
    
    convenience init(id: String = UUID().uuidString, name: String, realValue: Double) {
        self.init()
        self.id = id
        self.name = name
        self.realValue = realValue
    }
    
}

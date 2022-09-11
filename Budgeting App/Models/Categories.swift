import Foundation
import RealmSwift


class Categories {
    
    static func addNewCategory(_ name: String) {
        let realm = try! Realm()
        try! realm.write {
            let category = CategoryItem(name: name, realValue: 0)
            realm.add(category)
        }
    }
    
    static func deleteCategory(_ category: CategoryItem) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(category)
        }
    }
    
}


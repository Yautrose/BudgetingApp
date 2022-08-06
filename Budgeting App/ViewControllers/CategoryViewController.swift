import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: Results<CategoryItem>?
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        categories = realm.objects(CategoryItem.self)
        token = categories!.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.performBatchUpdates({
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                }, completion: { finished in
                    // ...
                })
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    @IBAction private func addCategorieItem() {
        
    }
    
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        let item = categories![indexPath.row]
        cell.categoryNameLabel.text = item.name
        cell.expectedValueLabel.text = String(item.expectedValue)
        
        let realValue = item
            .transactions
            .map { $0.cost }
            .reduce(0, +)
        
        cell.realValueLabel.text = String(realValue)
        return cell

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = categories![indexPath.row]
        let contextItem = UIContextualAction(style: .normal, title: "Delete") { (_, _, _) in
            Categories.deleteCategory(category)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

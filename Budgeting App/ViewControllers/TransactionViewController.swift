import UIKit
import RealmSwift

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //private var transactions = [TransactionItem]()
    private var transactions: Results<TransactionItem>?
    private var dateFormatter = DateFormatter.standard
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        
        transactions = realm.objects(TransactionItem.self)
        token = transactions!.observe { [weak self] (changes: RealmCollectionChange) in
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

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let realm = try! Realm()
//        //transactions = Array(realm.objects(TransactionItem.self))
//        transactions = realm.objects(TransactionItem.self)
//        tableView.reloadData()
//    }
//
    @IBAction private func addTransactionItem() {
        
    }
    
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return transactions.count
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        //let item = transactions[indexPath.row]
        let item = transactions![indexPath.row]
        cell.nameLabel.text = item.name
        cell.categoryLable.text = item.category.first?.name
        cell.costLabel.text = String(item.cost)
        cell.dateLabel.text = String(dateFormatter.string(from: item.date))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let transactions = transactions![indexPath.row]
        let contextItem = UIContextualAction(style: .normal, title: "Delete") { (_, _, _) in
            Transactions.deleteTransaction(transactions)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

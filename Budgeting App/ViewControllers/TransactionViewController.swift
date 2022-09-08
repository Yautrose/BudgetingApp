import UIKit
import RealmSwift

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    private var transactions: Results<TransactionItem>?
    private var dateFormatter = DateFormatter.standard
    private var token: NotificationToken?
    private var currentMonth: Int = Calendar.current.component(.month, from: Date()) {
        didSet {
            updateCurrentMonth()
        }
    }
    private var currentMonthName: String {
        DateFormatter().shortMonthSymbols[currentMonth - 1]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        updateCurrentMonth()
    }

    private func updateCurrentMonth() {
        let realm = try! Realm()
        
        transactions = realm.objects(TransactionItem.self).filter("month == %i", currentMonth)
        token?.invalidate()
        token = transactions!.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                }, completion: { finished in
                    // ...
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction private func addTransactionItem() {
        
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        currentMonth -= 1
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        currentMonth += 1
    }
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        let item = transactions![indexPath.row]
        cell.nameLabel.text = item.name
        cell.categoryLable.text = item.category.first?.name
        cell.costLabel.text = String(item.cost)
        cell.dateLabel.text = String(dateFormatter.string(from: item.date))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let transactions = transactions![indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            Transactions.deleteTransaction(transactions)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTransaction" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let transaction = transactions![indexPath.row]
            let newAddTransactionVC = segue.destination as! AddNewTransactionViewController
            newAddTransactionVC.currentTransaction = transaction

        }
    }
    
}

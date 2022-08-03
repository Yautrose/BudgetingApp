import UIKit
import RealmSwift

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var transactions = [TransactionItem]()
    private var dateFormatter = DateFormatter.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        transactions = Array(realm.objects(TransactionItem.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        transactions = Array(realm.objects(TransactionItem.self))
        tableView.reloadData()
    }
    
    @IBAction private func addTransactionItem() {
        
    }
    
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        let item = transactions[indexPath.row]
        cell.nameLabel.text = item.name
        cell.categoryLable.text = item.category.first?.name
        cell.costLabel.text = String(item.cost)
        cell.dateLabel.text = String(dateFormatter.string(from: item.date))
        
        return cell
    }
    
}

import UIKit

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return Transactions.arrayOfTransactionItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        let item = Transactions.arrayOfTransactionItem[indexPath.row]
        cell.nameLabel.text = item.name
        cell.categoryLable.text = item.category.name
        cell.costLabel.text = String(item.cost)
        //cell.dateLabel.text = 
        return cell
    }
    
}

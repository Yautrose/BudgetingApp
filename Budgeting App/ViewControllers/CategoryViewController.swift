import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction private func addCategorieItem() {
        
    }
    
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.arrayOfCategoryItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        let item = Categories.arrayOfCategoryItem[indexPath.row]
        cell.categoryNameLabel.text = item.name
        cell.expectedValueLabel.text = String(item.expectedValue)
        
        let realValue = Transactions.arrayOfTransactionItem
            .filter { $0.category == item }
            .map { $0.cost }
            .reduce(0, +)
        
        cell.realValueLabel.text = String(realValue)
        return cell

    }
    
}

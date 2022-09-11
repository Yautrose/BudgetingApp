import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    var categories: Results<CategoryItem>?
    private var token: NotificationToken?
    
    private var currentMonth = Calendar.current.component(.month, from: Date()) {
        didSet {
            updateCurrentMonth()
        }
    }
    private var currentYear = Calendar.current.component(.year, from: Date()) {
        didSet {
            updateCurrentMonth()
        }
    }
    
    private var currentMonthName: String {
        switch currentMonth {
        case 1: return "Январь"
        case 2: return "Февраль"
        case 3: return "Март"
        case 4: return "Апрель"
        case 5: return "Май"
        case 6: return "Июнь"
        case 7: return "Июль"
        case 8: return "Август"
        case 9: return "Сентябрь"
        case 10: return "Октябрь"
        case 11: return "Ноябрь"
        default: return "Декабрь"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        updateCurrentMonth()
    }
    
    private func updateCurrentMonth() {
        monthLabel.text = currentMonthName + " " + String(currentYear)
        
        let realm = try! Realm()
        categories = realm.objects(CategoryItem.self).filter("SUBQUERY(transactions, $transaction, $transaction.month == %i) .@count > 0", currentMonth)
        categories = realm.objects(CategoryItem.self).filter("SUBQUERY(transactions, $transaction, $transaction.year == %i) .@count > 0", currentYear)
        token?.invalidate()
        token = categories!.observe { [weak self] (changes: RealmCollectionChange) in
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
    
    @IBAction private func addCategorieItem() {
        
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        if currentMonth != 1 {
            currentMonth -= 1
        } else {
            currentMonth = 12
            currentYear -= 1
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if currentMonth != 12 {
            currentMonth += 1
        } else {
            currentMonth = 1
            currentYear += 1
        }
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
            .filter("month == %i", currentMonth)
            //.filter("year == %i", currentYear)
            .map { $0.cost }
            .reduce(0, +)
        
        cell.realValueLabel.text = String(realValue)
        return cell

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = categories![indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            Categories.deleteCategory(category)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCategory" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let category = categories![indexPath.row]
            let newAddCategoryVC = segue.destination as! AddNewCategoyViewController
            newAddCategoryVC.currentCategory = category
        }
    }
}

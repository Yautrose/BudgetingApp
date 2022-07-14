import UIKit

class AddNewTransactionViewController: UITableViewController {
    
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var transactionCostTextField: UITextField!
    @IBOutlet weak var transactionDataTextField: UITextField!
    @IBOutlet weak var transactionCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
       // addNewTransaction (name: transactionNameTextField.text, category: CategoryItem, cost: Double, date: Date)
    }
    
}

import UIKit

class AddNewCategoyViewController: UITableViewController {
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var expectedValueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = categoryNameTextField.text,
              let expectedValue = Double(expectedValueTextField.text ?? ""),
              !name.isEmpty,
              expectedValue != 0
        else {
            return
        }
        
        Categories.addNewCategory(name, expectedValue)
        navigationController?.popViewController(animated: true)
    }
    
}

import UIKit
import RealmSwift

class AddNewCategoyViewController: UITableViewController {
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var expectedValueTextField: UITextField!
    
    var currentCategory: CategoryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
    }
    
    private func setupEditScreen() {
        if currentCategory != nil {
            categoryNameTextField.text = currentCategory?.name
            expectedValueTextField.text = String(currentCategory?.expectedValue ?? 0.0)
            title = currentCategory?.name
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = categoryNameTextField.text,
              let expectedValue = Double(expectedValueTextField.text ?? ""),
              !name.isEmpty,
              expectedValue != 0
        else { return }
        
        if currentCategory != nil {
            let realm = try! Realm()
            try! realm.write {
                currentCategory?.name = name
                currentCategory?.expectedValue = expectedValue
            }
        } else {
            Categories.addNewCategory(name, expectedValue)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

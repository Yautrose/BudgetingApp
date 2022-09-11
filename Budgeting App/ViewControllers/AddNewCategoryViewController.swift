import UIKit
import RealmSwift

class AddNewCategoyViewController: UITableViewController {
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    
    var currentCategory: CategoryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
    }
    
    private func setupEditScreen() {
        if currentCategory != nil {
            categoryNameTextField.text = currentCategory?.name
            title = currentCategory?.name
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = categoryNameTextField.text,
              !name.isEmpty
        else { return }
        
        if currentCategory != nil {
            let realm = try! Realm()
            try! realm.write {
                currentCategory?.name = name
            }
        } else {
            Categories.addNewCategory(name)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

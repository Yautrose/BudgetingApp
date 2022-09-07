import UIKit
import RealmSwift

class AddNewTransactionViewController: UITableViewController {
    
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var transactionCostTextField: UITextField!
    @IBOutlet weak var transactionDateTextField: UITextField!
    @IBOutlet weak var transactionCategoryTextField: UITextField!
    
    var categories = [CategoryItem]()
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    var selectedDate: Date?
    var selectedCategory: CategoryItem?
    var currentTransaction: TransactionItem?
    private let dateFormatter = DateFormatter.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        categories = Array(realm.objects(CategoryItem.self))
        createPicker()
        createCategoryPicker()
        setupEditScreen()
    }
    
    private func setupEditScreen() {
        if let currentTransaction = currentTransaction {
            transactionNameTextField.text = currentTransaction.name
            transactionCostTextField.text = String(currentTransaction.cost)
            transactionDateTextField.text = String(dateFormatter.string(from: currentTransaction.date))
            transactionCategoryTextField.text = currentTransaction.category.first?.name
            transactionCategoryTextField.isEnabled = false
            selectedDate = currentTransaction.date
            selectedCategory = currentTransaction.category.first
            title = currentTransaction.name
        }
    }
    
    func createPicker() {
        
        transactionDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = .now
        datePicker.date = currentTransaction?.date ?? Date()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        transactionDateTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneAction() {
        selectedDate = datePicker.date
        getDateFromPicker()
        view.endEditing(true)
    }
    
    func getDateFromPicker() {
        transactionDateTextField.text = String(dateFormatter.string(from: datePicker.date))
    }
    
    func createCategoryPicker() {
        
        transactionCategoryTextField.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneCategoryAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        
        transactionCategoryTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneCategoryAction() {
        let selectedCategoryIndex = categoryPicker.selectedRow(inComponent: 0)
        let selectedCategory = categories[selectedCategoryIndex]
        self.selectedCategory = selectedCategory
        transactionCategoryTextField.text = selectedCategory.name
        view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = transactionNameTextField.text,
              let category = selectedCategory,
              let cost = Double(transactionCostTextField.text ?? ""),
              let date = selectedDate,
              !name.isEmpty,
              cost != 0
        else { return }
        
        if currentTransaction != nil {
            let realm = try! Realm()
            try! realm.write {
                currentTransaction!.name = name
                currentTransaction!.cost = cost
                currentTransaction!.date = date
                currentTransaction!.month = Calendar.current.component(.month, from: date)
            }
        } else {
                Transactions.addNewTransaction (name: name, category: category, cost: cost, date: date)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
extension AddNewTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
}

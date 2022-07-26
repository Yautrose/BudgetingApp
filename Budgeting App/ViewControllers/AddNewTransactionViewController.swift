import UIKit

class AddNewTransactionViewController: UITableViewController {
    
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var transactionCostTextField: UITextField!
    @IBOutlet weak var transactionDateTextField: UITextField!
    @IBOutlet weak var transactionCategoryTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    var selectedDate: Date?
    var selectedCategory: CategoryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPicker()
        createCategoryPicker()

    }
    
    func createPicker() {
        
        transactionDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = .now
        
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
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        transactionDateTextField.text = String(formatter.string(from: datePicker.date))
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
        let selectedCategory = Categories.arrayOfCategoryItem[selectedCategoryIndex]
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
        else {
            return
        }
        
        Transactions.addNewTransaction (name: name, category: category, cost: cost, date: date)
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension AddNewTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Categories.arrayOfCategoryItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Categories.arrayOfCategoryItem[row].name
    }
    
}

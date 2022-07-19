import UIKit

class AddNewTransactionViewController: UITableViewController {
    
    @IBOutlet weak var transactionNameTextField: UITextField!
    @IBOutlet weak var transactionCostTextField: UITextField!
    @IBOutlet weak var transactionDateTextField: UITextField!
    @IBOutlet weak var transactionCategoryTextField: UITextField!
    
    let datePicker = UIDatePicker()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPicker()

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
        getDateFromPicker()
        view.endEditing(true)
    }
    
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        transactionDateTextField.text = String(formatter.string(from: datePicker.date)) //
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let name = transactionNameTextField.text,
              let category = transactionCategoryTextField.text,
              let cost = Double(transactionCostTextField.text ?? ""),
              let date = transactionDateTextField.text,
              !name.isEmpty,
              category.isEmpty,
              cost != 0,
              date.isEmpty
        else {
            return
        }
        
        Transactions.addNewTransaction (name: name, category: category, cost: cost, date: date)
        navigationController?.popViewController(animated: true)
        
    }
    
}

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var realValueLabel: UILabel!
    @IBOutlet weak var expectedValueLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
}

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func addCategorieItem() {
        
    }
    
}


extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        return cell

    }
    
    
}

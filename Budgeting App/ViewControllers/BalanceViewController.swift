//
//  BalanceViewController.swift
//  Budgeting App
//
//  Created by Alexey Artyushenko on 29.06.2022.
//

import UIKit

class BalanceViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction private func addItem() {
        
    }
    
}

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceCell", for: indexPath)
        return cell
    }
    
}

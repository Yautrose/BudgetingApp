//
//  CategoryTableViewCell.swift
//  Budgeting App
//
//  Created by Alexey Artyushenko on 16.07.2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var realValueLabel: UILabel!
    @IBOutlet weak var expectedValueLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

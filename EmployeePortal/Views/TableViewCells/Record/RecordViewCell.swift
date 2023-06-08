//
//  RecordViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/24/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class RecordViewCell: Cell<String>, CellType {

    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

final class RecordViewRow: Row<RecordViewCell>, RowType {
    
    var name: String? {
        didSet {
            cell.nameLabel.text = name
            cell.recordImageView.isHidden = false
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<RecordViewCell>(nibName: RecordViewCell.identifier, bundle: nil)
    }
    
}

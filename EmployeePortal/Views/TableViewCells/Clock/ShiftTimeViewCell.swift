//
//  ShiftTimeViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ShiftTimeViewCell: Cell<String>, CellType {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

final class ShiftTimeViewRow: Row<ShiftTimeViewCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<ShiftTimeViewCell>(nibName: ShiftTimeViewCell.identifier, bundle: nil)
    }
    
}

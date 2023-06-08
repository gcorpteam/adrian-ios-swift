//
//  EmptyCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/15/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class EmptyCell: Cell<String>, CellType {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func setup() {
        super.setup()
        
        height = {
            return 15
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

final class EmptyRow: Row<EmptyCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<EmptyCell>(nibName: "EmptyCell", bundle: nil)
    }
    
}

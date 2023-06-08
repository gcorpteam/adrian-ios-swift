//
//  LoginHeaderCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/12/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class LoginHeaderCell: Cell<UIImage>, CellType {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

final class LoginHeaderRow: Row<LoginHeaderCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<LoginHeaderCell>(nibName: "LoginHeaderCell", bundle: nil)
    }
    
}

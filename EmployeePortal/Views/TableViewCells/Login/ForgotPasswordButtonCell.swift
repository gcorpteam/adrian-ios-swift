//
//  ForgotPasswordButtonCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/15/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ForgotPasswordButtonCell: ButtonCell {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func forgotButtonAction(_ sender: UIButton) {
        (row as? ForgotPasswordButtonRow)?.actionHandler!()
    }
    
}

final class ForgotPasswordButtonRow: Row<ForgotPasswordButtonCell>, RowType {
    
    var actionHandler: VoidClosure? = nil

    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<ForgotPasswordButtonCell>(nibName: "ForgotPasswordButtonCell", bundle: nil)
    }
}

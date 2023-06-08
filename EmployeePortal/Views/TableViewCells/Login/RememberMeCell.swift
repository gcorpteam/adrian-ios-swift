//
//  RememberMeCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/15/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class RememberMeCell: Cell<Bool>, CellType {

    @IBOutlet weak var iconImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func rememberButtonAction(_ sender: UIButton) {
        row.value = !(row.value ?? false)
//        let imageName = (row.value == true) ? "checkbox_selected" : "checkbox"
//        iconImageView?.image = UIImage(named: imageName)
        (row as? RememberMeRow)?.rememberButtonAction?()
    }
    
}

final class RememberMeRow: Row<RememberMeCell>, RowType {
    var rememberButtonAction: VoidClosure?
    
    override var value: Bool? {
        didSet {
            let imageName = (value == true) ? "checkbox_selected" : "checkbox"
            cell.iconImageView?.image = UIImage(named: imageName)
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<RememberMeCell>(nibName: "RememberMeCell", bundle: nil)
    }
}

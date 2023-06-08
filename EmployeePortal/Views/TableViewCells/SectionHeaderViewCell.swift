//
//  SectionHeaderViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class SectionHeaderViewCell: Cell<String>, CellType {

    @IBOutlet weak var headerLabel: UILabel?
    
}

final class SectionHeaderViewRow: Row<SectionHeaderViewCell>, RowType {
    
    var text: String? {
        didSet {
            cell.headerLabel?.text = text
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<SectionHeaderViewCell>(nibName: SectionHeaderViewCell.identifier, bundle: nil)
    }
}

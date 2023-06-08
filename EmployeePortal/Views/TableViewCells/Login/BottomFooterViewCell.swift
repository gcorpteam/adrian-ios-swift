//
//  BottomFooterViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/7/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class BottomFooterViewCell: Cell<UIImage>, CellType {

    @IBOutlet weak var iconImageView: UIImageView?
    
    @IBAction func tapAction(_ sender: UIButton) {
        (row as? BottomFooterViewRow)?.actionHandler?()
    }
}

final class BottomFooterViewRow: Row<BottomFooterViewCell>, RowType {
    
    var actionHandler: VoidClosure?
    
    var imageName: String? {
        didSet {
            cell.iconImageView?.image = UIImage(named: imageName ?? "")
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<BottomFooterViewCell>(nibName: "BottomFooterViewCell", bundle: nil)
    }
    
}

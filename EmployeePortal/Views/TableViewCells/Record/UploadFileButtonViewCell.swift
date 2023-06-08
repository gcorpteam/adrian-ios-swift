//
//  UploadFileButtonViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/24/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class UploadFileButtonViewCell: Cell<String>, CellType {

    @IBOutlet weak var uploadButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uploadButton?.layer.cornerRadius = 10.0
    }

    @IBAction func submitButtonAction(_ sender: UIButton) {
        (row as? UploadFileButtonViewRow)?.actionHandler?()
    }
}

final class UploadFileButtonViewRow: Row<UploadFileButtonViewCell>, RowType {
    var actionHandler: VoidClosure? = nil

    var name: String? {
        didSet {
            cell.uploadButton?.setTitle(name, for: .normal)
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<UploadFileButtonViewCell>(nibName: UploadFileButtonViewCell.identifier, bundle: nil)
    }
    
}

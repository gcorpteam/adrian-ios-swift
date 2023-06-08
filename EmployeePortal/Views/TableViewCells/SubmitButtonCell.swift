//
//  SubmitButtonCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/15/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

typealias VoidClosure = () -> ()

class SubmitButtonCell: ButtonCell {
    
    @IBOutlet weak var button: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        button?.layer.cornerRadius = 10.0
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        (row as? SubmitButtonRow)?.actionHandler?()
    }
}

final class SubmitButtonRow: Row<SubmitButtonCell>, RowType {
    
    var actionHandler: VoidClosure? = nil
    
    var name: String? {
        didSet {
            configureView()
        }
    }
    
    var color: UIColor? {
        didSet {
            cell.button?.backgroundColor = color
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<SubmitButtonCell>(nibName: "SubmitButtonCell", bundle: nil)
    }
    
    private func configureView() {
        cell.button?.setTitle(name ?? "", for: .normal)
    }
}

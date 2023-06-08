//
//  OptionsViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/9/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class OptionsViewCell: Cell<String>, CellType, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var optionsTextField: UITextField?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        showOptions()
    }
    
    @IBAction func textFieldTapAction(_ sender: UITextField) {
        endEditing(true)
        
        showOptions()
    }
    
    @IBAction func textfieldBeginEditionAction(_ sender: UITextField) {
        
        endEditing(true)
        
        showOptions()
    }
    
    private func showOptions() {
        guard let alertOptions = (row as? OptionsViewRow)?.options else { return }
        let alert = UIAlertController(title: "Options", message: "Choose any option", preferredStyle: .actionSheet)
        for option in alertOptions {
            let action = UIAlertAction(title: option, style: .default) { [weak self] (action) in
                (self?.row as? OptionsViewRow)?.value = option
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            UIViewController.topMostViewController().present(alert, animated: true, completion: nil)
        }
    }
    
}

final class OptionsViewRow: Row<OptionsViewCell>, RowType {
    
    var options: [String]?
    
    override var value: String? {
        didSet {
            cell.optionsTextField?.text = value
        }
    }
    
    var keyboardType: UIKeyboardType? {
        didSet {
            cell.optionsTextField?.keyboardType = keyboardType ?? .default
        }
    }
    
    var header: String? {
        didSet {
            cell.titleLabel?.text = header
        }
    }
    
    var placeholder: String? {
        didSet {
            cell.optionsTextField?.placeholder = placeholder
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<OptionsViewCell>(nibName: "OptionsViewCell", bundle: nil)
    }

}

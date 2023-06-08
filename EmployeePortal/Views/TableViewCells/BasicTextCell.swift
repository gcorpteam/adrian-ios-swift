//
//  BasicTextCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/12/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class BasicTextCell: Cell<String>, CellType, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var basicTextField: UITextField?
    @IBOutlet weak var mandatoryIconImageView: UIImageView?
    @IBOutlet weak var lockImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        addToolBar()
    }
    
    func configureView() {
        titleLabel?.text = (row as? BasicTextRow)?.placeholder
    }
    
    func addToolBar() {
        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(BasicTextCell.doneDatePickerPressed))

        // if you remove the space element, the "done" button will be left aligned
        // you can add more items if you want
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        basicTextField?.inputAccessoryView = toolBar
    }
    
    @objc func doneDatePickerPressed(){
        endEditing(true)
    }
    
    // Textfield delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        (row as? BasicTextRow)?.value = (textField.text ?? "") + string
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
           (row as? BasicTextRow)?.value = updatedText
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (row as? BasicTextRow)?.value = textField.text
        basicTextField?.resignFirstResponder()
        (row as? BasicTextRow)?.actionHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        basicTextField?.resignFirstResponder()
        return true
    }
}


final class BasicTextRow: Row<BasicTextCell>, RowType {
    
    var actionHandler: VoidClosure?
    
    var rowValue: String? {
        didSet {
            cell.basicTextField?.text = rowValue
            value = rowValue
        }
    }
    
    var keyboardType: UIKeyboardType? {
        didSet {
            cell.basicTextField?.keyboardType = keyboardType ?? .default
        }
    }
    
    var placeholder: String? {
        didSet {
            configureView()
        }
    }
    
    var isSecureText: Bool? {
        didSet {
            if isSecureText == true {
                cell.basicTextField?.isSecureTextEntry = true
            }
        }
    }
    
    var isMandatory: Bool = false {
        didSet {
            cell.mandatoryIconImageView?.isHidden = !isMandatory
        }
    }
    
    var isNonEditable: Bool = false {
        didSet {
            cell.lockImageView?.isHidden = !isNonEditable
            cell.isUserInteractionEnabled = !isNonEditable
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<BasicTextCell>(nibName: "BasicTextCell", bundle: nil)
    }
    
    private func configureView() {
        cell.configureView()
    }
}

//
//  ClockNoteViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/8/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ClockNoteViewCell: Cell<String>, CellType, UITextFieldDelegate {

    @IBOutlet weak var noteTextField: UITextField?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addToolBar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addToolBar() {
        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(TimeViewCell.doneDatePickerPressed))

        // if you remove the space element, the "done" button will be left aligned
        // you can add more items if you want
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        noteTextField?.inputAccessoryView = toolBar
    }
    
    @objc func doneDatePickerPressed(){
        endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (row as? ClockNoteViewRow)?.value = ((row as? ClockNoteViewRow)?.value ?? "") + string
        return true
    }
    
}

final class ClockNoteViewRow: Row<ClockNoteViewCell>, RowType {
    
    var keyboardType: UIKeyboardType? {
        didSet {
            cell.noteTextField?.keyboardType = keyboardType ?? .default
        }
    }
    
    var placeholder: String? {
        didSet {
            cell.noteTextField?.placeholder = placeholder
        }
    }

    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<ClockNoteViewCell>(nibName: ClockNoteViewCell.identifier, bundle: nil)
    }
}

//
//  DatePickerViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/28/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class DatePickerViewCell: Cell<String>, CellType, UITextFieldDelegate {
    
    @IBOutlet weak var timeTextField: UITextField?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var mandatoryIconImageView: UIImageView?
    @IBOutlet weak var lockImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addToolBar()
    }
    
    func configureView() {
        titleLabel?.text = (row as? DatePickerRow)?.placeholder
    }
    
    @IBAction func textBeginEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        timeTextField?.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TimePickerViewCell.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
    }
    
    func addToolBar() {
        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(TimePickerViewCell.doneDatePickerPressed))

        // if you remove the space element, the "done" button will be left aligned
        // you can add more items if you want
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        timeTextField?.inputAccessoryView = toolBar
    }
    
    @objc func doneDatePickerPressed(){
        if (row as? DatePickerRow)?.value?.isEmpty ?? true {
            setFormattedDate(date: Date())
        }
        endEditing(true)
    }
    
    func setFormattedDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        timeTextField?.text = dateFormatter.string(from: date)
        (row as? DatePickerRow)?.value = date.toString("yyyy-MM-dd HH:mm:ss")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        setFormattedDate(date: sender.date)
    }
    
}

final class DatePickerRow: Row<DatePickerViewCell>, RowType {
    
    override var value: String? {
        didSet {
            cell.timeTextField?.text = value?.convertDateFormater(with: "yyyy-MM-dd HH:mm:ss", toMask: "dd/MM/yyyy")
        }
    }
    
    var keyboardType: UIKeyboardType? {
        didSet {
            cell.timeTextField?.keyboardType = keyboardType ?? .default
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
                cell.timeTextField?.isSecureTextEntry = true
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
        
        cellProvider = CellProvider<DatePickerViewCell>(nibName: DatePickerViewCell.identifier, bundle: nil)
    }
    
    private func configureView() {
        cell.configureView()
    }
}



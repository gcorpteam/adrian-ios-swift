//
//  TimeViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 2/7/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class TimeViewCell: Cell<String>, CellType, UITextFieldDelegate {
    
    @IBOutlet weak var timeTextField: UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addToolBar()
    }
    
    override func setup() {
        super.setup()
        
        height = {
            return 80
        }
    }
    
    @IBAction func textBeginEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        timeTextField?.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TimeViewCell.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
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

        timeTextField?.inputAccessoryView = toolBar
    }
    
    func setFormattedDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        timeTextField?.text = dateFormatter.string(from: date)
        (row as? TimeViewRow)?.value = date.toString("yyyy-MM-dd HH:mm:ss")
    }
    
    @objc func doneDatePickerPressed(){
        if (row as? TimeViewRow)?.value?.isEmpty ?? true {
            setFormattedDate(date: Date())
        }
        endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        setFormattedDate(date: sender.date)
    }
    
}

final class TimeViewRow: Row<TimeViewCell>, RowType {

    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<TimeViewCell>(nibName: TimeViewCell.identifier, bundle: nil)
    }
}

//
//  DateHeaderJTAppleCollectionReusableView.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 12/27/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateHeaderJTAppleCollectionReusableView: JTAppleCollectionReusableView  {
    @IBOutlet weak var monthTitleLabel: UILabel?
    @IBOutlet weak var monthTitleView: UIView?

    var moveByIndex: ((Int) -> Void)?

    override  func awakeFromNib() {
        super.awakeFromNib()
        monthTitleView?.backgroundColor = ThemeManager.Color.gray
    }

    @IBAction func nextButtonAction() {
        moveByIndex?(1)
    }
    
    @IBAction func previousButtonAction() {
        moveByIndex?(-1)
    }
}

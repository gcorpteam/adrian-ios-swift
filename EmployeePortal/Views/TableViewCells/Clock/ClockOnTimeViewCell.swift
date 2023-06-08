//
//  ClockOnTimeViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ClockOnTimeViewCell: Cell<String>, CellType {

    @IBOutlet weak var breakTimeLabel: UILabel?
    @IBOutlet weak var offTimeLabel: UILabel?
    @IBOutlet weak var onTimeLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

final class ClockOnTimeViewRow: Row<ClockOnTimeViewCell>, RowType {
    
    var startTime: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            let date = dateFormatter.string(from: startTime!)
            cell.onTimeLabel?.text = "5:00 pm"
        }
    }
    
    var stopTime: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            let date = dateFormatter.string(from: stopTime!)
            cell.offTimeLabel?.text = "8:00 pm"//date
        }
    }
    
    var breakTime: Int? {
        didSet {
            cell.breakTimeLabel?.text = String(breakTime ?? 0) + "minutes"
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<ClockOnTimeViewCell>(nibName: ClockOnTimeViewCell.identifier, bundle: nil)
    }
    
}

//
//  RoasterDetailsTableViewCell.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 4/6/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit

class RoasterDetailsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var rosterTitleLabel: UILabel?
    @IBOutlet weak var rosterTitleView: UIView?
    @IBOutlet weak var detailsStackView: UIStackView?

    var roaster: Roster? {
        didSet {
            configure(for : roaster)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for roster: Roster?) {
        guard let roster = roster else { return }

        rosterTitleView?.backgroundColor = roster.type.color
        rosterTitleLabel?.text = roster.type.message.uppercased()
        
        let values = getDetails(of: roster)
        detailsStackView?.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        values.forEach { (title, value) in
            let label = UILabel()
            label.backgroundColor = .white
            label.text = "\(title) : \(value)"
            detailsStackView?.addArrangedSubview(label)
        }
    }
    
    func getDetails(of roster:Roster?) -> KeyValuePairs<String, String> {
        guard let roster = roster else { return [:]}
        switch roster.type {
            
        case .shift:
            return  [
                "Start Time" : roster.startTime,
                "End Time" : roster.endTime,
                "Break (Min)" : roster.breakTime,
                "Time Worked" : roster.totalHour,
                "Type Of Hours" : roster.typeOfHour,
                "Notes" : roster.notes,
                "Status" : roster.status
            ]
            
        case .leave:
            return  [
                "Leave Type" : roster.typeOfHour,
                "Date from" : roster.startTime,
                "Date to" : roster.endTime,
                "Hours taken" : roster.totalHour,
                "Notes" : roster.notes,
                "Status" : roster.status
            ]
        }
    }
}

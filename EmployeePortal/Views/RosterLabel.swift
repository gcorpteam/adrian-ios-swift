//
//  RosterLabel.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/27/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit

class RosterLabel : UILabel {
    
    var roster: Roster? {
        didSet {
            configureView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView() {
        guard let roster = roster else { return }
        backgroundColor = roster.type.color
        text = roster.message
        textColor = roster.type.textColor
        textAlignment = .left
        numberOfLines = 0
        minimumScaleFactor = 0.5
        font = .preferredFont(forTextStyle: .caption2)
        isUserInteractionEnabled = false
    }
}

//
//  RosterDayCollectionViewCell.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 12/24/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//
import UIKit
import JTAppleCalendar

class RosterDayCollectionViewCell : JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var rosterStackView: UIStackView?
    @IBOutlet weak var mainView: UIView?

    var rosters: [Roster]? {
        didSet {
            configureView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView() {
        backgroundColor = ThemeManager.Color.white
        rosterStackView?.subviews.forEach{$0.removeFromSuperview()}
        
        guard let rosters = rosters, !rosters.isEmpty else { return }

        // display one timesheet/leave and a more label,if there is more than one elements are present,
        rosterStackView?.insertArrangedSubview(getRosterLabel(rosters[0]), at: 0)

        if rosters.count > 1 {
            rosterStackView?.insertArrangedSubview(getMoreLabel(type: rosters[0].type), at: 1)
        }
    }
    
    func getRosterLabel(_ roster : Roster) -> RosterLabel {
        let rosterLabel = RosterLabel()
        rosterLabel.roster = roster
        return rosterLabel
    }
    
    func getMoreLabel(type: Roster.RosterType) -> UILabel {
        let moreLabel = UILabel()
        let heightConstraint = NSLayoutConstraint(item: moreLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20)
        moreLabel.addConstraint(heightConstraint)
        moreLabel.backgroundColor = type.color
        moreLabel.textColor = type.textColor
        moreLabel.font = UIFont(name: moreLabel.font.fontName, size: 11)
        moreLabel.text = "More"
        moreLabel.textAlignment = .center

        return moreLabel
    }
}

  

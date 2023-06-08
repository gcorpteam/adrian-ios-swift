//
//  ProfileHeaderView.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation
import UIKit

class ProfileHeaderView: UIView {
    
    var employee: Employee? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var designationLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    
    private func configureView() {
        nameLabel?.text = employee?.fullname
        designationLabel?.text = employee?.designation
//        if let image = employee?.imageUrl?.image() {
//            profileImageView?.image = image
//        }
    }
    
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
        
    }
    
}

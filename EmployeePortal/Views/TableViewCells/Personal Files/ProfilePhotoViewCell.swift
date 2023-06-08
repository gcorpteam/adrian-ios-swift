//
//  ProfilePhotoViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/22/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ProfilePhotoViewCell: Cell<UIImage>, CellType {

    @IBOutlet weak var profileImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView?.layer.cornerRadius = (profileImageView?.frame.size.width ?? 0)/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        (row as? ProfilePhotoViewRow)?.actionHandler?()
    }
    
}

final class ProfilePhotoViewRow: Row<ProfilePhotoViewCell>, RowType {
    
    var actionHandler: VoidClosure?
    var image: UIImage? {
        didSet {
            value = image
            cell.profileImageView?.image = image
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<ProfilePhotoViewCell>(nibName: ProfilePhotoViewCell.identifier, bundle: nil)
    }
}

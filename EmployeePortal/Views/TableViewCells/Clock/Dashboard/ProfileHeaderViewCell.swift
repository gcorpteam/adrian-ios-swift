//
//  ProfileHeaderViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/12/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class ProfileHeaderViewCell: Cell<String>, CellType {

    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var designationLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        guard let profileView = profileImageView else { return }
        profileView.layer.cornerRadius = profileView.frame.size.width/2
    }
    
    func configureView() {
        guard let row = row as? ProfileHeaderViewRow else { return }
        if let cachedImageData = UserDefaults.standard.value(forKey: "CachedImageData") as? Data {
            profileImageView?.image = UIImage(data: cachedImageData)
        }
        else {
            if let url = URL(string: row.employee?.imageUrlString ?? "") {
                url.image { [weak self] (image, data) in
                    UserDefaults.standard.set(data, forKey: "CachedImageData")
                    DispatchQueue.main.async {
                        self?.profileImageView?.image = image
                    }
                }
            }
        }

        nameLabel?.text = row.employee?.fullname
        designationLabel?.text = row.employee?.designation
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
          (row as? ProfileHeaderViewRow)?.profileImageActionHandler?()
    }
    
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
       (row as? ProfileHeaderViewRow)?.actionHandler?()
    }
    
}

final class ProfileHeaderViewRow: Row<ProfileHeaderViewCell>, RowType {
    var actionHandler: VoidClosure? = nil
    var profileImageActionHandler: VoidClosure? = nil

    var employee: Employee? {
        didSet {
            configureView()
        }
    }
    
    var image: UIImage? {
        didSet {
            cell.profileImageView?.image = image
            UserDefaults.standard.set(image?.pngData(), forKey: "CachedImageData")
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<ProfileHeaderViewCell>(nibName: "ProfileHeaderViewCell", bundle: nil)
    }
    
    private func configureView() {
        cell.configureView()
    }
}

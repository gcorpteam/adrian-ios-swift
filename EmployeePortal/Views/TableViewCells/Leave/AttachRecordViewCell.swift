//
//  AttachRecordViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/23/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

struct File {
    var url: URL?
    var name: String?
}

class AttachRecordViewCell: Cell<String>, CellType {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        uploadButton.layer.borderColor = UIColor.lightGray.cgColor
        uploadButton.layer.borderWidth = 1.0
        uploadButton.layer.cornerRadius = 10.0
        
        takePhotoButton.layer.borderColor = UIColor.lightGray.cgColor
        takePhotoButton.layer.borderWidth = 1.0
        takePhotoButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func uploadButtonAction(_ sender: UIButton) {
        (row as? AttachRecordView)?.actionHandler?()
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        (row as? AttachRecordView)?.photoActionHandler?()
    }
}

final class AttachRecordView: Row<AttachRecordViewCell>, RowType {
    
    var actionHandler: VoidClosure?
    var photoActionHandler: VoidClosure?
    
    var file: File? {
        didSet {
            cell.fileNameLabel.text = file?.name
        }
    }
    
    var fileName: String? {
        didSet {
            cell.fileNameLabel.text = fileName
        }
    }
    
    var dataUri: String?
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AttachRecordViewCell>(nibName: AttachRecordViewCell.identifier, bundle: nil)
    }
    
}

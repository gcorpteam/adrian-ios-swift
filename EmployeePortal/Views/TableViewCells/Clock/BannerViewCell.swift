//
//  BannerViewCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 4/17/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class BannerViewCell: Cell<UIImage>, CellType {

    @IBOutlet weak var bannerTitle: UILabel?
    
}

final class BannerViewRow: Row<BannerViewCell>, RowType {
    
    var header: String? {
        didSet {
            cell.bannerTitle?.text = header
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<BannerViewCell>(nibName: "BannerViewCell", bundle: nil)
    }
    
}

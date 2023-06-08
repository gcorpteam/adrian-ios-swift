//
//  FeatureCell.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class FeatureCell: ButtonCell {

    
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    
    func configureView() {
        guard let row = row as? FeatureRow else { return }
        iconImageView?.image = row.feature?.icon
        nameLabel?.text = row.feature?.name
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        (row as? FeatureRow)?.actionHandler?()
    }
}

final class FeatureRow: Row<FeatureCell>, RowType {
    var actionHandler: VoidClosure? = nil
    
    var feature: Feature? {
        didSet {
            configureView()
        }
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<FeatureCell>(nibName: "FeatureCell", bundle: nil)
    }
    
    private func configureView() {
        cell.configureView()
    }
}

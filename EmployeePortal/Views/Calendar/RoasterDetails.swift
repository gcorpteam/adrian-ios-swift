//
//  RoasterDetails.swift
//  EmployeePortal
//
//  Created by sajeev Raj on 4/6/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import UIKit

class RoasterDetails: UIView {
    
    @IBOutlet weak var bluredView: UIVisualEffectView?
    @IBOutlet weak var tableView: UITableView?
    var dismissView: VoidClosure?
    var rosters = [Roster]() {
        didSet {
            tableView?.reloadData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissBlur))
        bluredView?.addGestureRecognizer(tapGestureRecognizer)
        let nib = RoasterDetailsTableViewCell.nib
        tableView?.register(nib, forCellReuseIdentifier: RoasterDetailsTableViewCell.identifier)
            

    }
    
    @objc func dismissBlur() {
        dismissView?()
    }
}

extension RoasterDetails: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoasterDetailsTableViewCell.identifier, for: indexPath) as? RoasterDetailsTableViewCell else  { return UITableViewCell() }
        cell.roaster = rosters[indexPath.row]
        return cell
    }
}


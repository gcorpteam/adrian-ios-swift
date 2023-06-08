//
//  PersonalFilesViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/20/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class PersonalFilesViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    override func createForm() {
        form +++ Section("")
            
            <<< FeatureRow() { row in
                row.feature = PersonalFileFeatures.contact
                
                row.actionHandler = { [weak self] in
                    self?.showContactDetailsView()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = PersonalFileFeatures.emergency
                
                row.actionHandler = { [weak self] in
                    self?.showEmergencyDetailsView()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = PersonalFileFeatures.job
                
                row.actionHandler = { [weak self] in
                    self?.showJobDetailsView()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = PersonalFileFeatures.password
                
                row.actionHandler = { [weak self] in
                    self?.showUpdatePassworView()
                }
        }
    }
    
    private func showEmergencyDetailsView() {
        EmergencyViewController.show()
    }
    
    private func showContactDetailsView() {
        ContactDetailsViewController.show()
    }
    
    private func showJobDetailsView() {
        JobDetailsViewController.show()
    }
    
    private func showUpdatePassworView() {
        if let url = URL(string: Configuration.current.forgotPasswordURL) {
            UIApplication.shared.open(url)
        }
//        UpdatePasswordViewController.show()
    }
}

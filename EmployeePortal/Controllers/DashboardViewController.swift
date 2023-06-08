//
//  DashboardViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/16/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka

class DashboardViewController: BaseFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRightLogoButton()
        
        initiateLookUpServices()
        
        addObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: Notification.Name(rawValue: "UpdateProfile"), object: nil)
    }
    
    @objc func updateProfile() {
        Employee.login(employee: Employee.cached() ) { [weak self] (response) in
            switch response {
            case .success(let data):
                print(data)
                
                // save data to DB
                data.save()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure: break
            case .finally:
                self?.hideLoader()
            }
        }
    }
    
    fileprivate func initiateLookUpServices() {
        // call lookup services
        LookUp.getLookUp(type: .timesheet) { (response) in
            switch response {
            case .success(let result):
                var timeSheetLookUps = [LookUp]()
                timeSheetLookUps = result
                timeSheetLookUps.forEach { $0.type = .timesheet }
                timeSheetLookUps.saveAll()
            case .failure: break
            case .finally: break
            }
        }
        
        LookUp.getLookUp(type: .leave) { (response) in
            switch response {
            case .success(let result):
                var leaveLookUps = [LookUp]()
                leaveLookUps = result
                leaveLookUps.forEach { $0.type = .leave }
                leaveLookUps.saveAll()
            case .failure: break
            case .finally: break
            }
        }
        
        LookUp.getLookUp(type: .record) { (response) in
            switch response {
            case .success(let result):
                var leaveLookUps = [LookUp]()
                leaveLookUps = result
                leaveLookUps.forEach { $0.type = .record }
                leaveLookUps.saveAll()
            case .failure: break
            case .finally: break
            }
        }
    }
    
    override func createForm() {
        form +++ Section("")
            
            <<< ProfileHeaderViewRow() { row in
                row.employee = Employee.cached()
                row.profileImageActionHandler = {
                    ImagePickerManager.shared.pickImage { [weak self] (imageAsset) in
//                        DispatchQueue.global(qos: .background).async {
                            self?.updateProfilePic(imageAsset: imageAsset)
//                        }
                        DispatchQueue.main.async {
                            row.image = imageAsset?.image
                        }
                    }
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.personal
                
                row.actionHandler = { [weak self] in
                    self?.showPersonalDetails()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.roster
                row.actionHandler = { [weak self] in
                    self?.showRosterDetails()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.clock
                
                row.actionHandler = { [weak self] in
                    self?.showClockDetails()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.timesheets
                
                row.actionHandler = { [weak self] in
                    self?.showTimesheetDetails()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.leave
                
                row.actionHandler = { [weak self] in
                    self?.showLeaveDetails()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.records
                
                row.actionHandler = { [weak self] in
                    self?.showRecordsDetails()
                }
            }
            
            <<< FeatureRow() { row in
                row.feature = DashboardFeatures.contact
                
                row.actionHandler = { [weak self] in
                    self?.showContactDetails()
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {15} }
            
            <<< BottomFooterViewRow() { row in
                row.imageName = "logo_powered_by"
                
                row.actionHandler = { [weak self] in
                    self?.goToWebsite()
                }
                row.cell.height = {
                    return 130
                }
        }
    }
    
    private func updateProfilePic(imageAsset: ImageAsset?) {
        showLoader()
        let jpgImageData = imageAsset?.image?.jpegData(compressionQuality: 1.0)
        let datauri = (jpgImageData?.base64EncodedString())
        guard let imageName = imageAsset?.fileName, let uri = datauri else { return }
        Employee.updateProfilePic(imageName: imageName, dataUri: uri) { [weak self] (response) in
            switch response {
            case .success:
                AlertController.show(type: .dataSubmit)
            case .failure(let error):
                AlertController.show(type: .serviceError, error: error)
            case .finally: self?.hideLoader()
            }
        }
    }
    
    private func addRightLogoButton() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(goToWebsite), for: .touchUpInside)
        button.setImage(UIImage(named: "logo_trans"), for: .normal)
        // set bar buttons
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let barButton = UIBarButtonItem(customView: button)

        var barButtons = self.navigationItem.rightBarButtonItems ?? []
        barButtons.append(barButton)
        self.navigationItem.rightBarButtonItems = barButtons
    }
    
    @objc func goToWebsite() {
        if let url = URL(string: Configuration.current.websiteUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showPersonalDetails() {
        PersonalFilesViewController.show()
    }
    
    private func showClockDetails() {
        let newClockView = NewClockViewController()
//        let allDates = Clock.allCaches().map{ $0.shiftDate.convertDateFormater(with: "yyyy-MM-dd HH:mm:ss", toMask: "yyyy-MM-dd") }
//        let isClockLoggedOn = allDates.contains(Date().toString("yyyy-MM-dd"))
        
        let inProgressValue: Bool = (UserDefaults.standard.value(forKey: "ClockInProgress") as? Bool) ?? false
        newClockView.viewMode = inProgressValue ? .off : .on
        newClockView.clock = Clock.cached()
        navigationController?.pushViewController(newClockView, animated: true)
    }
    
    private func showTimesheetDetails() {
        TimesheetViewController.show()
    }
    
    private func showLeaveDetails() {
        LeaveViewController.show()
    }
    
    private func showRecordsDetails() {
        RecordsViewController.show()
    }
    
    private func showContactDetails() {
        ContactHRViewController.show()
    }
    
    private func showRosterDetails() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.identifier) as? CalendarViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

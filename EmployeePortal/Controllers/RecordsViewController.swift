//
//  RecordsViewController.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/24/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import UIKit
import Eureka
import FileBrowser

enum RecordsKeys: String {
    case recordName
    case recordType
}

class RecordsViewController: BaseFormViewController {
    
    override var shouldHideMenuOption: Bool {
        return true
    }
    
    override var shouldShowBackButton: Bool {
        return true
    }
    
    var records = [Record]()

    override func createForm() {
        
        form +++ Section("")
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< BasicTextRow(RecordsViewController.Keys.name) { row in
                row.placeholder = "Record name"
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< OptionsViewRow(RecordsViewController.Keys.options) { row in
                row.header = "Record type"
                row.options = LookUp.recordTypes.values()
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< AttachRecordView(RecordsViewController.Keys.attachRecord) { [weak self] row in
                row.actionHandler = {
                    self?.view.endEditing(true)
                    self?.getFile(completion: { (fileName, dataUri) in
                        DispatchQueue.main.async {
                            row.dataUri = dataUri
                            row.fileName = fileName
                        }
                    })
                }
                row.photoActionHandler = {
                    self?.view.endEditing(true)
                    self?.getPhoto(completion: { (fileName, dataUri) in
                        DispatchQueue.main.async {
                            row.dataUri = dataUri
                            row.fileName = fileName
                        }
                    })
                }
            }
            
            <<< EmptyRow() { $0.cell.height = {22} }
            
            <<< SubmitButtonRow("Row7") { row in
                row.name = "Submit"
                row.actionHandler = { [weak self] in
                    self?.submitRecord()
                }
        }
        
        
        //        let section = Section()
        //        form +++
        //            section
        //            <<< UploadFileButtonViewRow() { [weak self] row in
        //                 row.name = "Upload New Record"
        //
        //                row.actionHandler = {
        //                    self?.uploadRecord()
        //                }
        //        }
        //
        //        for (index, record) in records.enumerated() {
        //            let tag = "RecordName\(index)"
        //            section <<< RecordViewRow(tag) { row in
        //                row.name = record.name
        //            }
        //        }
    }
    
    private func submitRecord() {
        let optionsRow: OptionsViewRow? = row(tag: RecordsViewController.Keys.options)
        let nameRow: BasicTextRow? = row(tag: RecordsViewController.Keys.name)
        let recordRow: AttachRecordView? = row(tag: RecordsViewController.Keys.attachRecord)

        let options = optionsRow?.value ?? ""
        let name = nameRow?.value ?? ""
        let recordUri = recordRow?.dataUri ?? ""
        
        let record = Record(name: name, type: options, fileName: recordRow?.fileName ?? "")
        showLoader()
        Employee.submitRecord(record: record, dataUri: recordUri) { [weak self] (response) in
            switch response {
             case .success(_):
                AlertController.show(type: .dataSubmit, error: nil, successHandler: {
                    self?.goToDashboard()
                }, cancelHandler: nil)
             case .failure(let error):
                 AlertController.show(type: .serviceError, error: error)
             case .finally:
                 self?.hideLoader()
             }
        }
        
    }
    
    func getFile(completion: @escaping (String, String) -> Void) {
        FileBrowserManager.shared.pickFile(viewController: self) { (url) in
            let data = try? Data(contentsOf: url).compress()
            completion(url.lastPathComponent, data?.base64EncodedString() ?? "")
        }
    }
    
    func getPhoto(completion: @escaping (String, String) -> Void) {
        ImagePickerManager.shared.pickImage(type: .camera) { (imageAsset) in
            guard let imageasset = imageAsset else { return }
            let data = imageasset.image?.pngData()?.compress()
            completion(imageasset.fileName ?? "", data?.base64EncodedString() ?? "")
        }
    }
    
//    func uploadRecord() {
//        FileBrowserManager.shared.pickFile(viewController: self) { [weak self] (url) in
//            guard let welf = self else { return }
//            welf.records.append(Record(name: url.lastPathComponent))
//            DispatchQueue.main.async {
//                welf.form.removeAll()
//                welf.createForm()
//            }
//        }
//    }
    
    override func insertAnimation(forRows rows: [BaseRow]) -> UITableView.RowAnimation {
        return .none
    }

    override func deleteAnimation(forRows rows: [BaseRow]) -> UITableView.RowAnimation {
        return .none
    }

    override func reloadAnimation(oldRows: [BaseRow], newRows: [BaseRow]) -> UITableView.RowAnimation {
        return .none
    }

    override func insertAnimation(forSections sections: [Section]) -> UITableView.RowAnimation {
        return .none
    }

    override func deleteAnimation(forSections sections: [Section]) -> UITableView.RowAnimation {
        return .none
    }

    override func reloadAnimation(oldSections: [Section], newSections: [Section]) -> UITableView.RowAnimation {
        return .none
    }
}

extension RecordsViewController {
    struct Keys {
        static let options = "options"
        static let name = "name"
        static let attachRecord = "attachRecord"
    }
}


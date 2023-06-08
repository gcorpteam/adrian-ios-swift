//
//  AlertController.swift
//  AudioTranscriber
//
//  Created by Sajeev on 2/2/20.
//  Copyright © 2020 Transcriber. All rights reserved.
//

import Foundation
import UIKit

class AlertController {
    
    typealias AlertActionWithTextHandler = (String) -> ()
    
    enum Alert {
        case serviceError
        case dataSubmit
        case dataIncomplete
        case inCorrectDate
        case locationSettings
        
        var title: String {
            switch self {
            case .serviceError: return "Service unavailable"
            case .dataSubmit : return "Successful"
            case .locationSettings : return "Access Required"
            case .dataIncomplete, .inCorrectDate : return "Error"
            }
        }
        
        var message: String {
            switch self {
            case .serviceError: return "Something went wrong. Please try again later"
            case .dataSubmit: return "Details submitted successfully"
            case .dataIncomplete: return "Fill all the mandatory fields"
            case .inCorrectDate: return "Provided date is incorrect"
            case .locationSettings : return "Location access required to proceed further."
            }
        }
        
        var needTwoButtons: Bool {
            switch self {
            case .locationSettings : return true
            default: return false
            }
        }
    }
    
    static func show(type: Alert, error: Error? = nil, successHandler: VoidClosure? = nil, cancelHandler: VoidClosure? = nil) {
        var errorMessage: String?
        if let empError = error as? EmpError {
            errorMessage = empError.message
        }
        else {
            errorMessage = error?.localizedDescription ?? type.message
        }
        let alertController = UIAlertController(title: type.title, message: errorMessage, preferredStyle: .alert)
        let buttonTitle = type == .locationSettings ? "Settings" : "Ok"

        let okAction = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            DispatchQueue.main.async {
                successHandler?()
            }
        }
        alertController.addAction(okAction)
        if type.needTwoButtons {
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                alertController.dismiss(animated: true) {
                    cancelHandler?()
                }
            }
            alertController.addAction(cancelAction)
        }
        DispatchQueue.main.async {
            topMostViewController().present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showTextFieldAlert(title: String, textFieldPlaceholder: String, successHandler: AlertActionWithTextHandler? = nil, cancelHandler: VoidClosure? = nil) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = textFieldPlaceholder
        }

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            guard let textField = alertController.textFields?[0] else { return }
            successHandler?(textField.text ?? "")
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            cancelHandler?()
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
             topMostViewController().present(alertController, animated: true, completion: nil)
         }
    }
    
    class func topMostViewController() -> UIViewController {
        var topViewController: UIViewController? = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController
        while ((topViewController?.presentedViewController) != nil) {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController ?? UIViewController()
    }
}

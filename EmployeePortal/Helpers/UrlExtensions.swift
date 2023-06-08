//
//  UrlExtensions.swift
//  EmployeePortal
//
//  Created by Sajeev on 12/9/19.
//  Copyright © 2019 EmployeePortal. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    func image(completion: @escaping (UIImage, Data) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: self)
            if let imageData = data, let image = UIImage(data:imageData) {
                completion(image, imageData)
            }
        }
    }
}

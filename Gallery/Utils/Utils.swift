//
//  Utils.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertMsg(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

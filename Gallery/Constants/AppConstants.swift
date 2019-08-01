//
//  AppConstants.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class AppConstants: NSObject {
    
    static let shared = AppConstants() // Singleton Class
    
    private override init () {}
    
    let flickrAPIKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    let mb = 1024 * 1024
    let flikrImageCache = "ImageCache"
}

struct UIConstant {
    static let cancelButton = NSLocalizedString("Cancel", comment: "Cancel")
    static let searchTag = NSLocalizedString("Search", comment: "Search Tag")
    static let alert = NSLocalizedString("Alert", comment: "Alert")
    static let noPhotoExist = NSLocalizedString("No images exist for the searched tag", comment: "No images exist for the searched tag")
}

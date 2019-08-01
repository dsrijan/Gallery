//
//  Photo.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var imageURL: String?
    var dic : NSDictionary!
    
    init(object : NSDictionary) {
        self.dic = object
        guard let farmID = self.dic["farm"] as? Int, let serverId = self.dic["server"] as? String, let id = self.dic["id"] as? String,let secret = self.dic["secret"] as? String else{
            return
        }
        self.imageURL = "https://farm\(farmID).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
        
     }

}

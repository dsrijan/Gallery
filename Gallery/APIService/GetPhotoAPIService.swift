//
//  GetPhotoAPIService.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class GetPhotoAPIService: NSObject {
    
    class func getPhotos(tag: String, page: Int, responseResult : @escaping(_ responseDic: NSDictionary, _ status : Bool) -> ()) {
    
        let callingURL = "https://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=\(tag)&tag_mode=all&api_key=\(AppConstants.shared.flickrAPIKey)&nojsoncallback=1&page=\(page)&per_page=30"
      
        NetworkRequest.performHTTPRequest(urlString: callingURL, method: "GET") { (response, status) in
            responseResult(response,status)
        }
    
    }
    
}

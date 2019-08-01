//
//  NetworkRequest.swift
//  Gallery
//
//  Created by Srijan on 04/07/18.
//  Copyright © 2018 Srijan. All rights reserved.
//

import UIKit

class NetworkRequest: NSObject {

    class func performHTTPRequest(urlString: String, method: String, responseResult : @escaping(_ responseDictionary: NSDictionary, _ status : Bool) -> ()) {
        
        do {
            
            //create the url with NSURL
            let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            
            //create the session object
            let session = URLSession.shared
            //now create the NSMutableRequest object using the url object
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = method //set http method as POST
            
            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        responseResult(json , true)
                        // handle json...
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    responseResult([:],false)
                }
                
            })
            
            task.resume()
            //            return task
        } catch {
            print(error)
        }
    }
    
}

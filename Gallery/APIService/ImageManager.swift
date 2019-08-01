//
//  ImageManager.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadCompletion = (_ imageURL: String, _ image: UIImage?) -> ()

class ImageManager: NSObject, URLSessionTaskDelegate {
    static let shared = ImageManager()
    let operationQueue: OperationQueue = OperationQueue()
    var urlCache = URLCache(memoryCapacity: 20 * AppConstants.shared.mb, diskCapacity: 100 * AppConstants.shared.mb, diskPath: AppConstants.shared.flikrImageCache)
    var requestQueue: Dictionary<URL, URLSessionDataTask> = [:]
    var session: URLSession!
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = urlCache
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
        
    }
    
}

extension ImageManager {
    
    func downloadImage(imageURL: String, completion: ImageDownloadCompletion?) {
        if let url = URL(string: imageURL) {
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            //Check for image in cache
            if let response = urlCache.cachedResponse(for: urlRequest) {
                let image = UIImage(data: response.data)
                completion?(imageURL, image)
            } else {
                //Check if image request is already present
                if let task = requestQueue[url] {
                    task.priority = URLSessionTask.highPriority
                } else {
                    //Else download
                    self.download(imageURL: imageURL, completion: completion)
                }
            }
            
        } else {
            completion?(imageURL, nil)
        }
        
    }
    
    private func download(imageURL: String, completion: ImageDownloadCompletion?) {
        
        if let url = URL(string: imageURL) {
            //Create request
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            
            let task = self.session.dataTask(with: urlRequest) {[weak self] (data, response, error) in
                
                if let data = data, let image = UIImage(data: data) {
                    completion?(imageURL, image)
                } else {
                    completion?(imageURL, nil)
                }
                self?.removeRequestFromQueue(url: url)
            }
            
            task.priority = URLSessionTask.highPriority
            requestQueue[url] = task
            task.resume()
            
        } else {
            completion?(imageURL, nil)
        }
        
    }
    
    private func removeRequestFromQueue(url: URL) {
        print(requestQueue)
        if let _ = requestQueue[url] {
            requestQueue[url] = nil
        }
        
    }
    
    func setLowPriority(url: URL) {
        if let task = requestQueue[url] {
            task.priority = URLSessionTask.lowPriority
        }
    }
    
}

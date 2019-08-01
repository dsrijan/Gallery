//
//  PhotoViewerViewController.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class PhotoViewerViewController: UIViewController {
    
    let photoImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    var imageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        let cancel = UIBarButtonItem(title: UIConstant.cancelButton, style: .plain, target: self, action: #selector(self.cancel))
        self.navigationItem.rightBarButtonItem = cancel
        
        self.setUpImageView()
     
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.center = self.photoImageView.center
        self.photoImageView.addSubview(activityIndicator)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showImage()
    }
    
    // Set up image view
    private func setUpImageView() {
        self.view.addSubview(self.photoImageView)
        // Adding Imageview using Constraint
        self.photoImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.photoImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.photoImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.photoImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // This will show the image in the image viewer
    private func showImage(){
        self.activityIndicator.startAnimating()
        ImageManager.shared.downloadImage(imageURL: self.imageURL) {[weak self] (url, image) in
            DispatchQueue.main.async() {
                self?.activityIndicator.stopAnimating()
                self?.photoImageView.image = image
            }
        }
    }
    
    // To dismiss View with transition
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

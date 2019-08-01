//
//  CustomCollectionViewCell.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var photo: Photo?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "default")
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(photo: Photo) {
        self.photo = photo
        if let url = self.photo?.imageURL {
            ImageManager.shared.downloadImage(imageURL: url) {[weak self] (url, image) in
                if url == self?.photo?.imageURL {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        if let urlString = self.photo?.imageURL, let url = URL(string: urlString) {
            ImageManager.shared.setLowPriority(url: url)
        }
        imageView.image = UIImage(named: "default")
    }
    
}

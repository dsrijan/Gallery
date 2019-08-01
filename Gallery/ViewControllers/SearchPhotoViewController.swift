//
//  ViewController.swift
//  Gallery
//
//  Created by Srijan on 31/07/19.
//  Copyright © 2019 Srijan. All rights reserved.
//

import UIKit

class SearchPhotoViewController: UIViewController{
    
    var collectionView : UICollectionView!
    var imageArray = [UIImage]()
    var photosData = [Photo]()
    var transitionDelegate = CustomTransitionDelegate()
    let searchController = UISearchController(searchResultsController: nil) // Search Controller
    private let cellIdentifier = "SearchCell"
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    var currentPage = 0
    
    var defaultSearch = "Kitten"
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.setUpCollectionView()
        self.setUpSearchBar()
        
        // Configure Activity Indicator
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.searchController.searchBar.text = defaultSearch
        self.getPhotos(searchTag: defaultSearch)
        
        // Do any additional setup after loading the view.
    }
    
    private func setUpCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let width = self.view.frame.width / 3 - 8
        layout.sectionInset = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
    }
    
    private func setUpSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
        navigationItem.title = UIConstant.searchTag
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func getPhotos(searchTag: String) {
        self.activityIndicator.startAnimating()
        GetPhotoAPIService.getPhotos(tag: "\(searchTag)", page: currentPage) {[weak self] (response, status) in
            if let photos = response["photos"] as? NSDictionary {
                guard let total = photos["total"] as? String else{
                    return
                }
                let photoCount = Int(total) ?? 0
                if photoCount > 0{
                    if let photo = photos["photo"] as? NSArray {
                        var isFreshSetup = false
                        if self?.currentPage == 0 {
                            self?.photosData.removeAll()
                            isFreshSetup = true
                        }
                            for ob in photo {
                                if ob is NSDictionary {
                                    self?.photosData.append(Photo(object: ob as! NSDictionary))
                                }
                            }
                            DispatchQueue.main.async {
                                self?.activityIndicator.stopAnimating()
                                if isFreshSetup {
                                    //Create new cells
                                    DispatchQueue.main.async {
                                        self?.collectionView.reloadData()
                                        self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                                    }
                                } else {
                                    //Append new cells
                                    self?.updateCollectionViewData()
                                }
                                
                                
                            }
                        }
                }else{
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.showAlertMsg(title: UIConstant.alert, message: UIConstant.noPhotoExist)
                    }
                }
            }
            
        }
    }
    
    func updateCollectionViewData() {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionView.performBatchUpdates({
                let currentRows = strongSelf.collectionView.numberOfItems(inSection: 0)
                var itemCount = strongSelf.photosData.count - 1
                var tempArray: Array<IndexPath> = []
                while itemCount >= currentRows {
                    tempArray.append(IndexPath(row: itemCount, section: 0))
                    itemCount -= 1
                }
                strongSelf.collectionView.insertItems(at: tempArray)
            }, completion: { (_) in
            })
        }
    }
    
    private func showGallery(imageURL: String) {
        let pv = PhotoViewerViewController()
        pv.imageURL = imageURL
        let rv = UINavigationController(rootViewController: pv)
        rv.transitioningDelegate = transitionDelegate
        rv.modalPresentationStyle = .custom
        self.navigationController?.present(rv, animated: true, completion: nil)
    }
    
}

// Collection view delegates and data sources
extension SearchPhotoViewController : UICollectionViewDelegate, UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items
        return self.photosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.configure(photo: self.photosData[indexPath.row])
        if indexPath.row == photosData.count - 1 {
            currentPage += 1
            getPhotos(searchTag: defaultSearch)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentDic = self.photosData[indexPath.row]
        if let currentImageURL = currentDic.imageURL{
            self.showGallery(imageURL: currentImageURL)
        }
    }
    
}

// Search Bar Delegates
extension SearchPhotoViewController : UISearchBarDelegate {
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let searchBarText =  searchBar.text!
            if searchBarText != defaultSearch {
                defaultSearch = searchBarText
                currentPage = 0
            }
            self.getPhotos(searchTag: searchBarText)
            self.searchController.dismiss(animated: true, completion: nil)
        }
    
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            self.searchController.dismiss(animated: true, completion: nil)
        }
}




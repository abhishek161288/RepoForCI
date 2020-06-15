//
//  CookGalleryViewController.swift
//  Foodjin
//
//  Created by Navpreet Singh on 22/08/19.
//  Copyright © 2019 Foodjin. All rights reserved.
//

import UIKit

class CookGalleryViewController: UIViewController {

    var locationValue: String?
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var gallery: CookGallery?
    var current:Int = 1
    var numberOfCells: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(gallery)
        
        self.location.text = locationValue ?? ""
        self.numberOfCells = gallery?.responseObj?.count ?? 0
        
        self.collectionView.register(UINib(nibName: GalleryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)

    }
}

//Ib Actions
extension CookGalleryViewController {
    //cross button action
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func prevButtonAction(_ sender: Any) {
       current = current-1
        if current <= 0 {
            current = 0
            self.collectionView.scrollToItem(at: IndexPath(row: current, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(row: current, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        current = current+1
        if current >= self.numberOfCells ?? 0 {
            current = self.numberOfCells ?? 0
            self.collectionView.scrollToItem(at: IndexPath(row: (self.numberOfCells!)-1, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(row: current, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        }
    }
}



extension CookGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCells ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Click On Gallery cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let returnCell = UICollectionViewCell()
        
        guard let reportsCell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell
            else { return returnCell }
        reportsCell.responseObj = self.gallery?.responseObj?[indexPath.row]
        reportsCell.setCell()
        return reportsCell
    }
}

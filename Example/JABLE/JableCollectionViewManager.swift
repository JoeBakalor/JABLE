//
//  JableCollectionViewManager.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import JABLE

class JableCollectionViewManager: NSObject{
    
    private weak var collectionView: UICollectionView?
    
    var data: [FriendlyAdvertisement] = []
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = UIColor.clear//(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(JableCollectionViewCell.self, forCellWithReuseIdentifier: "jableCell")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }
    
    @objc func refresh(){
        collectionView?.reloadData()
    }
    
}

extension JableCollectionViewManager: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jableCell", for: indexPath) as! JableCollectionViewCell
        cell.cellData = data[indexPath.row]
        return cell
    }
}

extension JableCollectionViewManager: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: (collectionView.frame.width) - 10, height: (collectionView.frame.width * 0.75) - 10)
    }
}

extension JableCollectionViewManager: UICollectionViewDelegate{
    
}

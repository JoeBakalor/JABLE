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

let USE_NEW_CELL_MODEL = true

protocol JableCollectionManagerDelegate{
    func userSelected(scanResult: TrackedScanResult)
}

class JableCollectionViewManager: NSObject{
    
    private var collectionView: UICollectionView!
    private var jableCollectionManagerDelegate: JableCollectionManagerDelegate!
    var collectionViewData: [Int : JableCollectionViewCellModel] = [:]
    
    init(collectionView: UICollectionView, delegate: JableCollectionManagerDelegate) {
        super.init()
        self.jableCollectionManagerDelegate = delegate
        self.collectionView = collectionView
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionView?.backgroundColor = UIColor.clear//(red: 215/255, green: 215/255, blue: 215/255, alpha: 1)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(JableCollectionViewCell.self, forCellWithReuseIdentifier: "jableCell")
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refresh), userInfo: nil, repeats: false)
    }
    
    @objc func refresh(){
        collectionView?.reloadData()
    }
    
    func processNewData(newData: TrackedScanResult){

        if collectionViewData[newData.resultID] != nil{
            collectionViewData[newData.resultID]?.data = newData
            if let collectionIndex = collectionViewData[newData.resultID]?.collectionIndex{
                self.collectionView?.reloadItems(at: [IndexPath(item: collectionIndex, section: 0)])
            }
        }
        else {
            let index = collectionViewData.count
            collectionViewData[newData.resultID] = JableCollectionViewCellModel(
                data: newData,
                collectionIndex: index,
                optionsViewShown: false)
                
                self.collectionView?.insertItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
}

extension JableCollectionViewManager: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jableCell", for: indexPath) as! JableCollectionViewCell
        cell.cellModel = collectionViewData[indexPath.row]
        collectionViewData[indexPath.row]?.collectionIndex = indexPath.row
        return cell
    }
}

extension JableCollectionViewManager: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (collectionView.frame.width) - 10, height: (collectionView.frame.width * 0.75) - 10)
    }
}

extension JableCollectionViewManager: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let scanResult = collectionViewData[indexPath.row]?.data else { return }
        print("User Selected \(scanResult)")
        jableCollectionManagerDelegate.userSelected(scanResult: scanResult)
    }
}

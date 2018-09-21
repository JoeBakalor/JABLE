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

class JableCollectionViewManager: NSObject{
    
    private weak var collectionView: UICollectionView?
    
    /*by scan result id*/
    var collectionViewData: [Int : JableCollectionViewCellModel] = [:]
    //var data: [Int : (trackedResult: TrackedScanResult, collectionIndex: Int)] = [:]
    
    /* by index id */
    
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
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refresh), userInfo: nil, repeats: false)
    }
    
    @objc func refresh(){
        collectionView?.reloadData()
    }
    
    func processNewData(newData: TrackedScanResult){
        
        /*if !USE_NEW_CELL_MODEL{
        if data[newData.resultID] != nil{ /*  UPDDATE DATA */
            
            data[newData.resultID]?.trackedResult = newData
            if let collectionIndex = data[newData.resultID]?.collectionIndex{
                self.collectionView?.reloadItems(at: [IndexPath(item: collectionIndex, section: 0)])
            }
        }
        else { /*  ADD NEW DATA */
            let index = data.count
            
            data[newData.resultID] = (trackedResult: newData, collectionIndex: index)
            self.collectionView?.insertItems(at: [IndexPath(item: index, section: 0)])
        }
        }
        else {*/
            
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
        //}
    }
    
}

extension JableCollectionViewManager: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if USE_NEW_CELL_MODEL{
            return collectionViewData.count
        //}
        /*else {
            return data.count
        }*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //if USE_NEW_CELL_MODEL{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jableCell", for: indexPath) as! JableCollectionViewCell
            cell.cellModel = collectionViewData[indexPath.row]
            //cell.cellData = collectionViewData[indexPath.row]?.data//data[indexPath.row]?.trackedResult
            collectionViewData[indexPath.row]?.collectionIndex = indexPath.row//data[indexPath.row]?.collectionIndex = indexPath.row
            return cell
        //}
        /*else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jableCell", for: indexPath) as! JableCollectionViewCell
            cell.cellData = data[indexPath.row]?.trackedResult
            data[indexPath.row]?.collectionIndex = indexPath.row
            return cell
        }*/

    }
}

extension JableCollectionViewManager: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (collectionView.frame.width) - 10, height: (collectionView.frame.width * 0.75) - 10)
    }
}

extension JableCollectionViewManager: UICollectionViewDelegate{
}

//
//  JableTableViewCell.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/12/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import JABLE

class JableCollectionViewCell: UICollectionViewCell {
    
    var cellData: FriendlyAdvdertisment?{
        didSet{
            if let advData = cellData{
                self.nameLabel.text = advData.localName != nil ? "Name: \(advData.localName!)" : "No Name"
                self.connectableLabel.text = advData.connectable != nil ? "Connectable: \(advData.connectable!)": "Unknown"
                self.manufactureData.text = advData.manufacturerData != nil ? "Data: \(getHexString(unFormattedData: advData.manufacturerData!))" : "Not advertised"
                manufactureData.sizeToFit()
                manufactureDataScrollView.contentSize = manufactureData.frame.size
                self.txPowerLabel.text = advData.transmitPowerLevel != nil ? "TX Power: \(advData.transmitPowerLevel!)" : "Not advertised"
                self.advServicesLabel.text = advData.services != nil ? "Services: \(advData.services!)" : "Not advertised"
            }
        }
    }
    
    private let plotView = UIView()
    
    private let nameScrollView = UIScrollView()
    private let connectableScrollView = UIScrollView()
    private let manufactureDataScrollView = UIScrollView()
    private let txPowerScrollView = UIScrollView()
    private let advServicesScrollView = UIScrollView()
    
    private let nameLabel = UILabel()
    private let connectableLabel = UILabel()
    private let manufactureData = UILabel()
    private let txPowerLabel = UILabel()
    private let advServicesLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    convenience init() {
        self.init(frame: CGRect.zero)
        initView()
    }
    
    func initView(){
        
        self.backgroundColor = .lightGray
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 5

        plotView.backgroundColor = .black
        plotView.clipsToBounds = true
        plotView.layer.cornerRadius = 5
        
        [nameLabel, connectableLabel, txPowerLabel, advServicesLabel, manufactureData].forEach { (label) in
            label.backgroundColor = .darkGray
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
        }
        
        manufactureDataScrollView.backgroundColor = .darkGray
        advServicesScrollView.backgroundColor = .darkGray
        
        self.addSubview(plotView)
        self.addSubview(nameLabel)
        self.addSubview(connectableLabel)
        self.addSubview(txPowerLabel)
//        self.addSubview(advServicesLabel)
        
//        self.addSubview(nameScrollView)
//        self.addSubview(connectableScrollView)
        self.addSubview(manufactureDataScrollView)
//        self.addSubview(txPowerScrollView)
        self.addSubview(advServicesScrollView)
//
//        nameScrollView.addSubview(nameLabel)
//        connectableScrollView.addSubview(connectableLabel)
        manufactureDataScrollView.addSubview(manufactureData)
//        txPowerScrollView.addSubview(txPowerLabel)
        advServicesScrollView.addSubview(advServicesLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let plotViewSize = CGSize(width: self.bounds.width - self.bounds.height * 0.05,
                                  height: (self.bounds.height * 0.8)/2)
        
        let plotOrigin = CGPoint(x: (self.bounds.height * 0.05)/2,
                                 y: (self.bounds.height * 0.2)/2 + (self.bounds.height * 0.95)/2)
        
        plotView.frame = CGRect(origin: plotOrigin, size: plotViewSize)
        
        let labelPadding = self.bounds.height * 0.025
        let labelSpaceHeight = (self.bounds.height - plotViewSize.height - (self.bounds.height * 0.05)/2  ) - 6*labelPadding
        let labelSize = CGSize(width: plotViewSize.width, height: labelSpaceHeight/5)
        let xInset = (self.bounds.height * 0.05)/2
        
        let nameLabelOrigin = CGPoint(x: xInset, y: labelPadding)
        let connectableLableOrigin = CGPoint(x: xInset, y: 2*labelPadding + labelSize.height)
        let manufatureDataLabelOrigin = CGPoint(x: xInset, y: 3*labelPadding + 2*labelSize.height)
        let txPowerLabelOrigin = CGPoint(x: xInset, y: 4*labelPadding + 3*labelSize.height)
        let advServicesLabelOrigin = CGPoint(x: xInset, y: 5*labelPadding + 4*labelSize.height)
        
        nameLabel.frame = CGRect(origin: nameLabelOrigin, size: labelSize)
        connectableLabel.frame = CGRect(origin: connectableLableOrigin, size: labelSize)
        
        manufactureDataScrollView.frame = CGRect(origin: manufatureDataLabelOrigin, size: labelSize)
        manufactureData.sizeToFit()
        manufactureDataScrollView.contentSize = CGSize(width: manufactureData.frame.width, height: manufactureData.frame.height)
        
        txPowerLabel.frame = CGRect(origin: txPowerLabelOrigin, size: labelSize)
        
        advServicesScrollView.frame = CGRect(origin: advServicesLabelOrigin, size: labelSize)
        advServicesLabel.sizeToFit() //= CGRect(origin: advServicesLabelOrigin, size: labelSize)
        advServicesScrollView.contentSize = advServicesLabel.frame.size
    }
    
    override func prepareForReuse() {
    }
}

extension JableCollectionViewCell{
    
    //GET CHARACTERISTIC VALUE AND RETURN AS BYTE ARRAY
    func getDataBytes(unFormattedData: NSData) -> [UInt8]{
        
        var data: Data? = unFormattedData as Data?
        //data = characteristic.value as Data!
        
        var dataBytes = [UInt8](repeating: 0, count: data!.count)
        (data! as NSData).getBytes(&dataBytes, length: data!.count)
        
        var hexValue = ""
        for value in data!{
            let hex = String(value, radix: 16)
            hexValue = hexValue + "0x\(hex) "
        }
        //print("Raw Hex = \(hexValue)")
        return dataBytes
    }
    
    //GET CHARACTERISTIC VALUE AND RETURN AS BYTE ARRAY
    func getHexString(unFormattedData: NSData) -> String{
        
        var data: Data? = unFormattedData as Data?
        //data = characteristic.value as Data!
        
        var dataBytes = [UInt8](repeating: 0, count: data!.count)
        (data! as NSData).getBytes(&dataBytes, length: data!.count)
        
        var hexValue = ""
        for value in data!{
            let hex = String(value, radix: 16)
            hexValue = hexValue + "\(hex)"
        }
        //print("Raw Hex = \(hexValue)")
        return hexValue
    }
    
}







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
    
    var cellData: FriendlyAdvertisement?{
        didSet{
            if let advData = cellData{
                self.nameLabel.text = advData.localName != nil ? " Name: \(advData.localName!)" : " Name: no name advertised"
                
                if let connectable = advData.connectable{
                    if connectable { self.connectableLabel.text = " Connectable: yes"
                    } else { self.connectableLabel.text = " Connectable: no" }
                } else { self.connectableLabel.text = " Connectable: unknown" }
                
                self.manufactureData.text = advData.manufacturerData != nil ? " Manufacture data: \(getHexString(unFormattedData: advData.manufacturerData!))" : " Manufacture data: not advertised"
                self.txPowerLabel.text = advData.transmitPowerLevel != nil ? " TX power: \(advData.transmitPowerLevel!)" : " Tx power: not advertised"
                self.advServicesLabel.text = advData.services != nil ? " Services: \(advData.services!)" : " Services: none advertised"
            }
        }
    }
    
    private let plotView = JablePlotView()
    /*  LABEL SCROLL VIEWS*/
    private let nameScrollView = UIScrollView()
    private let connectableScrollView = UIScrollView()
    private let manufactureDataScrollView = UIScrollView()
    private let txPowerScrollView = UIScrollView()
    private let advServicesScrollView = UIScrollView()
    /*  LABELS  */
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
        
        self.backgroundColor = UIColor.JableBlueTwo
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.JableBlueOne.cgColor
        self.layer.cornerRadius = 5

        //plotView.backgroundColor = .black
        plotView.clipsToBounds = true
        plotView.layer.cornerRadius = 5
        
        [nameLabel, connectableLabel, txPowerLabel, advServicesLabel, manufactureData].forEach { (label) in
            label.backgroundColor = .clear
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
            label.textColor = UIColor.white
        }
        
        nameScrollView.backgroundColor = .JableBlueFour
        nameScrollView.layer.cornerRadius = 3
        
        connectableScrollView.backgroundColor = .JableBlueFour
        connectableScrollView.layer.cornerRadius = 3
        
        manufactureDataScrollView.backgroundColor = .JableBlueFour
        manufactureDataScrollView.layer.cornerRadius = 3
        
        txPowerScrollView.backgroundColor = .JableBlueFour
        txPowerScrollView.layer.cornerRadius = 3
        
        advServicesScrollView.backgroundColor = .JableBlueFour
        advServicesScrollView.layer.cornerRadius = 3
        
        self.addSubview(plotView)
        
        /*  ADD SCROLL VIEWS */
        self.addSubview(nameScrollView)
        self.addSubview(connectableScrollView)
        self.addSubview(manufactureDataScrollView)
        self.addSubview(txPowerScrollView)
        self.addSubview(advServicesScrollView)

        /*  ADD LABELS TO SCROLL VIEWS */
        nameScrollView.addSubview(nameLabel)
        connectableScrollView.addSubview(connectableLabel)
        manufactureDataScrollView.addSubview(manufactureData)
        txPowerScrollView.addSubview(txPowerLabel)
        advServicesScrollView.addSubview(advServicesLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let plotViewSize = CGSize(
            width: self.bounds.width - self.bounds.height * 0.05,
            height: (self.bounds.height * 0.8)/2)
        
        let plotOrigin = CGPoint(
            x: (self.bounds.height * 0.05)/2,
            y: (self.bounds.height * 0.2)/2 + (self.bounds.height * 0.95)/2)
        
        plotView.frame = CGRect(origin: plotOrigin, size: plotViewSize)
        
        let labelPadding = self.bounds.height * 0.015
        let labelSpaceHeight = (self.bounds.height - plotViewSize.height - (self.bounds.height * 0.05)/2  ) - 7*labelPadding
        let labelSize = CGSize(width: plotViewSize.width, height: labelSpaceHeight/5)
        let xInset = (self.bounds.height * 0.05)/2
        
        let nameLabelOrigin = CGPoint(x: xInset, y: 2*labelPadding)
        let connectableLableOrigin = CGPoint(x: xInset, y: 3*labelPadding + labelSize.height)
        let manufatureDataLabelOrigin = CGPoint(x: xInset, y: 4*labelPadding + 2*labelSize.height)
        let txPowerLabelOrigin = CGPoint(x: xInset, y: 5*labelPadding + 3*labelSize.height)
        let advServicesLabelOrigin = CGPoint(x: xInset, y: 6*labelPadding + 4*labelSize.height)
        
        nameScrollView.frame = CGRect(origin: nameLabelOrigin, size: labelSize)
        nameLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: labelSize.width*2, height: labelSize.height))
        nameScrollView.contentSize = CGSize(width: nameLabel.frame.width, height: labelSize.height)
        
        connectableScrollView.frame = CGRect(origin: connectableLableOrigin, size: labelSize)
        connectableLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: labelSize.width*2, height: labelSize.height))
        connectableScrollView.contentSize = CGSize(width: connectableLabel.frame.width, height: labelSize.height)
        
        manufactureDataScrollView.frame = CGRect(origin: manufatureDataLabelOrigin, size: labelSize)
        manufactureData.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: labelSize.width*2, height: labelSize.height))
        manufactureDataScrollView.contentSize = CGSize(width: manufactureData.frame.width, height: labelSize.height)
        
        txPowerScrollView.frame = CGRect(origin: txPowerLabelOrigin, size: labelSize)
        txPowerLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: labelSize.width*2, height: labelSize.height))
        txPowerScrollView.contentSize = txPowerLabel.frame.size
        
        advServicesScrollView.frame = CGRect(origin: advServicesLabelOrigin, size: labelSize)
        advServicesLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: labelSize.width*2, height: labelSize.height))
        advServicesScrollView.contentSize = advServicesLabel.frame.size
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameScrollView.scrollsToTop = true
        connectableScrollView.scrollsToTop = true
        manufactureDataScrollView.scrollsToTop = true
        txPowerScrollView.scrollsToTop = true
        advServicesScrollView.scrollsToTop = true
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







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
    
    weak var cellModel: JableCollectionViewCellModel?{
        didSet{
            guard cellModel?.optionsViewShown == false else {
                return
            }
            if let advData = cellModel?.data.currentAdvData{
                if let localName = advData.localName{
                    self.nameLabel.text = " Name: \(localName)"
                }
                else if let friendlyName = advData.friendlyName{
                    self.nameLabel.text = " Name: \(friendlyName)"
                }
                else {
                    self.nameLabel.text = " Name: unknown"
                }
                
                if let connectable = advData.connectable{
                    if connectable {
                        self.connectableLabel.text = " Connectable: yes"
                    }
                    else {
                        self.connectableLabel.text = " Connectable: no"
                    }
                }
                else {
                    self.connectableLabel.text = " Connectable: unknown"
                }
                let newManData = advData.manufacturerData != nil ? " Manufacture data: \(getHexString(unFormattedData: advData.manufacturerData!))" : " Manufacture data: not advertised"
                if newManData != manufactureData.text{
                    manufactureData.text = newManData
                }
                //self.manufactureData.text = advData.manufacturerData != nil ? " Manufacture data: \(getHexString(unFormattedData: advData.manufacturerData!))" : " Manufacture data: not advertised"
                self.txPowerLabel.text = advData.transmitPowerLevel != nil ? " TX power: \(advData.transmitPowerLevel!)" : " Tx power: not advertised"
                
                let newServiceData = advData.services != nil ? " Services: \(advData.services!)" : " Services: none advertised"
                if newServiceData != advServicesLabel.text{
                    self.advServicesLabel.text = newServiceData
                }
                //self.advServicesLabel.text = advData.services != nil ? " Services: \(advData.services!)" : " Services: none advertised"
                
                if let rssi = advData.rssi{
                    self.currentRssiValue.text = "\(rssi)"
                }
            }
            //print("\n \(nameLabel.text) RSSI ARRAY: \(cellData?.rssiArray)")
            if let rssiData = cellModel?.data.rssiArray{
                plotView.setPlotData(dataArray: rssiData)
                self.setNeedsLayout()
            }
        }
    }

    private let tapGestureRecognizers = [UITapGestureRecognizer(),
                                         UITapGestureRecognizer(),
                                         UITapGestureRecognizer(),
                                         UITapGestureRecognizer(),
                                         UITapGestureRecognizer()]
    
    private var plotView = JablePlotView()
    
    /*  LABEL SCROLL VIEWS */
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
    private let currentRssiValue = UILabel()
    
    /*  STATE */
    private var optionsShown = false
    
    /*  OPTIONS VIEW BUTTONS */
    private let connectButton = JableButton()
    private let trackPeripheralButton = JableButton()
    private let cancelButton = JableButton()
    
    /*  BLUR VIEW */
    private let blurEffectView = UIVisualEffectView()

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
        
        self.backgroundColor        = UIColor.JableBlueTwo
        self.clipsToBounds          = true
        self.layer.borderWidth      = 2
        self.layer.borderColor      = UIColor.JableBlueOne.cgColor
        self.layer.cornerRadius     = 5
        
        plotView.clipsToBounds = true
        plotView.layer.cornerRadius = 5
        currentRssiValue.layer.cornerRadius = 5
        currentRssiValue.clipsToBounds = true
        currentRssiValue.backgroundColor = .white
        currentRssiValue.textColor = UIColor.JableBlueOne
        currentRssiValue.textAlignment = .center
        currentRssiValue.layer.borderColor = UIColor.JableBlueThree.cgColor
        currentRssiValue.layer.borderWidth = 2
        
        [nameLabel, connectableLabel, txPowerLabel, advServicesLabel, manufactureData].forEach { (label) in
            label.backgroundColor = .clear
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
            label.textColor = UIColor.white
        }
        
        tapGestureRecognizers.forEach {
            $0.numberOfTapsRequired = 1
            $0.numberOfTouchesRequired = 1
            $0.addTarget(self, action: #selector(passThroughTap))
        }

        var idx = 0
        [nameScrollView, connectableScrollView, manufactureDataScrollView, txPowerScrollView, advServicesScrollView].forEach { (scrollView) in
            scrollView.backgroundColor      = .JableBlueFour
            scrollView.layer.cornerRadius   = 3
            scrollView.addGestureRecognizer(tapGestureRecognizers[idx])
            self.contentView.addSubview(scrollView)
            idx += 1
        }
        
        [connectButton, trackPeripheralButton].forEach {
            $0.borderColor = UIColor.JableBlueOne
        }
        
        /*  ADD LABELS TO SCROLL VIEWS */
        nameScrollView.addSubview(nameLabel)
        connectableScrollView.addSubview(connectableLabel)
        manufactureDataScrollView.addSubview(manufactureData)
        txPowerScrollView.addSubview(txPowerLabel)
        advServicesScrollView.addSubview(advServicesLabel)
        
        self.contentView.addSubview(plotView)
        self.contentView.addSubview(currentRssiValue)
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
        
        let labelPadding                        = self.bounds.height * 0.015
        let labelSpaceHeight                    = (self.bounds.height - plotViewSize.height - (self.bounds.height * 0.05)/2  ) - 7*labelPadding
        let scrollViewSize                      = CGSize(width: plotViewSize.width, height: labelSpaceHeight/5)
        let labelSize                           = CGSize(width: scrollViewSize.width*2, height: scrollViewSize.height)
        let labelFrame                          = CGRect(origin: CGPoint.zero, size: labelSize)
        let xInset                              = (self.bounds.height * 0.05)/2
        
        let nameLabelOrigin                     = CGPoint(x: xInset, y: 2*labelPadding)
        let connectableLableOrigin              = CGPoint(x: xInset, y: 3*labelPadding + labelSize.height)
        let manufatureDataLabelOrigin           = CGPoint(x: xInset, y: 4*labelPadding + 2*labelSize.height)
        let txPowerLabelOrigin                  = CGPoint(x: xInset, y: 5*labelPadding + 3*labelSize.height)
        let advServicesLabelOrigin              = CGPoint(x: xInset, y: 6*labelPadding + 4*labelSize.height)
        
        let rssiInset = plotViewSize.height*0.025
        let rssiLabelSize = CGSize(width: plotView.frame.height/2, height: plotView.frame.height/4)
        let rssiLabelOrigin = CGPoint(x: plotOrigin.x + plotViewSize.width - rssiLabelSize.width - rssiInset, y: plotOrigin.y + rssiInset)
        let currentRssiLabelFrame = CGRect(origin: rssiLabelOrigin, size: rssiLabelSize)
        
        nameScrollView.frame                    = CGRect(origin: nameLabelOrigin, size: scrollViewSize)
        nameLabel.frame                         = labelFrame
        nameScrollView.contentSize              = nameLabel.frame.size
        
        connectableScrollView.frame             = CGRect(origin: connectableLableOrigin, size: scrollViewSize)
        connectableLabel.frame                  = labelFrame
        connectableScrollView.contentSize       = connectableLabel.frame.size
        
        manufactureDataScrollView.frame         = CGRect(origin: manufatureDataLabelOrigin, size: scrollViewSize)
        manufactureData.frame                   = labelFrame
        manufactureDataScrollView.contentSize   = manufactureData.frame.size
        
        txPowerScrollView.frame                 = CGRect(origin: txPowerLabelOrigin, size: scrollViewSize)
        txPowerLabel.frame                      = labelFrame
        txPowerScrollView.contentSize           = txPowerLabel.frame.size
        
        advServicesScrollView.frame             = CGRect(origin: advServicesLabelOrigin, size: scrollViewSize)
        advServicesLabel.frame                  = labelFrame
        advServicesScrollView.contentSize       = advServicesLabel.frame.size
        
        currentRssiValue.frame                  = currentRssiLabelFrame

        layoutButtons()
    }
    
    func layoutButtons(){
        
        let buttonSize = CGSize(width: self.bounds.width/3, height: self.bounds.width/6)
        let horizontalSpacing = self.bounds.width/9
        let connectButtonOrigin = CGPoint(x: self.bounds.width/2 - buttonSize.width - horizontalSpacing/2, y: self.bounds.midY - buttonSize.height/2)
        let trackPeripheralButtonOrigin = CGPoint(x: connectButtonOrigin.x + buttonSize.width + horizontalSpacing, y: self.bounds.midY - buttonSize.height/2)
        
        connectButton.frame = CGRect(origin: connectButtonOrigin, size: buttonSize)
        trackPeripheralButton.frame = CGRect(origin: trackPeripheralButtonOrigin, size: buttonSize)
        connectButton.setTitle("Connect", for: .normal)
        trackPeripheralButton.setTitle("Track", for: .normal)
        
        /* MOVE BUTTONS OFF SCREEN */
        [connectButton, trackPeripheralButton].forEach {
            $0.frame.origin.y += self.bounds.height
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //nameScrollView.scrollsToTop = true
        //connectableScrollView.scrollsToTop = true
        //manufactureDataScrollView.scrollsToTop = true
        //txPowerScrollView.scrollsToTop = true
        //advServicesScrollView.scrollsToTop = true
    }
    
    @objc func passThroughTap(){
        let collectionView = self.superview as! UICollectionView
        guard let indexPath = collectionView.indexPath(for: self) else { return }
        collectionView.delegate?.collectionView!(collectionView, didSelectItemAt: indexPath)
    }
    
    @objc func toggleOptionsView(){
        if optionsShown{
            UIView.beginAnimations(nil, context: nil)
            blurEffectView.alpha = 0.0
            [connectButton, trackPeripheralButton].forEach {
                $0.frame.origin.y += self.bounds.height
            }
            UIView.commitAnimations()
            optionsShown = false
            self.cellModel?.optionsViewShown = false
        } else {
            UIView.beginAnimations(nil, context: nil)
            blurEffectView.alpha = 0.95
            [connectButton, trackPeripheralButton].forEach {
                $0.frame.origin.y -= self.bounds.height
            }
            UIView.commitAnimations()
            optionsShown = true
            self.cellModel?.optionsViewShown = true
        }
    }
}

extension JableCollectionViewCell{
    
    //GET  VALUE AND RETURN AS BYTE ARRAY
    func getDataBytes(unFormattedData: NSData) -> [UInt8]{
        
        var data: Data? = unFormattedData as Data?
        
        var dataBytes = [UInt8](repeating: 0, count: data!.count)
        (data! as NSData).getBytes(&dataBytes, length: data!.count)
        
        var hexValue = ""
        for value in data!{
            let hex = String(value, radix: 16)
            hexValue = hexValue + "0x\(hex) "
        }

        return dataBytes
    }
    
    //GET VALUE AND RETURN AS BYTE ARRAY
    func getHexString(unFormattedData: NSData) -> String{
        
        var data: Data? = unFormattedData as Data?
        
        var dataBytes = [UInt8](repeating: 0, count: data!.count)
        (data! as NSData).getBytes(&dataBytes, length: data!.count)
        
        var hexValue = ""
        for value in data!{
            let hex = String(value, radix: 16)
            hexValue = hexValue + "\(hex)"
        }

        return hexValue
    }
    
}







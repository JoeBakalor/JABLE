//
//  FriendlyAdvertismentData.swift
//  JABLE
//
//  Created by Joe Bakalor on 9/11/18.
//

import Foundation
import CoreBluetooth

public struct FriendlyAdvertisement: CustomStringConvertible{
    
    public var connectable              : Bool?
    public var manufacturerData         : NSData?
    public var overflowServiceUUIDs     : [CBUUID]?
    public var serviceData              : [CBUUID: NSData]?
    public var services                 : [CBUUID]?
    public var solicitedServiceUUIDs    : [CBUUID]?
    public var transmitPowerLevel       : NSNumber?
    public var localName                : String?
    public var friendlyName             : String?
    public var rssi                     : Int?
    public var timeStamp                : Date?
    public var seen                     : Int = 0
    public var advIntervalEstimate      : Double?
    
    init(advertisementData: [String : Any], rssi RSSI: Int, peripheral: CBPeripheral){
        self.connectable            = advertisementData["kCBAdvDataIsConnectable"] as? NSNumber == 1 ? true : false
        self.manufacturerData       = advertisementData["kCBAdvDataManufacturerData"] as? NSData
        self.overflowServiceUUIDs   = advertisementData["kCBAdvDataOverflowServiceUUIDs"] as? [CBUUID]
        self.serviceData            = advertisementData["kCBAdvDataServiceData"] as? [CBUUID : NSData]
        self.services               = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID]
        self.solicitedServiceUUIDs  = advertisementData["kCBAdvDataSolicitedServiceUUIDs"] as? [CBUUID]
        self.transmitPowerLevel     = advertisementData["kCBAdvDataTxPowerLevel"] as? NSNumber
        self.localName              = advertisementData["kCBAdvDataLocalName"] as? String
        self.friendlyName           = peripheral.name
        self.rssi                   = RSSI
        self.timeStamp              = Date()
    }
    
    public var description: String{
        let noValue = "NO VALUE"
        let connectablePrintValue           = self.connectable != nil ? "\(self.connectable!)" : noValue
        let manufacturerDataPrintValue      = self.manufacturerData != nil ? "\(self.manufacturerData!)" : noValue
        let overflowServiceUUIDsPrintValue  = self.overflowServiceUUIDs != nil ? "\(self.overflowServiceUUIDs!)" : noValue
        let serviceDataPrintValue           = self.serviceData != nil ? "\(self.serviceData!)" : noValue
        let servicesPrintValue              = self.services != nil ? "\(self.services!)" : noValue
        let solicitedServiceUUIDsPrintValue = self.solicitedServiceUUIDs != nil ? "\(self.solicitedServiceUUIDs!)" : noValue
        let transmitPowerLevelPrintValue    = self.transmitPowerLevel != nil ? "\(self.transmitPowerLevel!)" : noValue
        let localNamePrintValue             = self.localName != nil ? "\(self.localName!)" : noValue
        let rssiPrintValue                  = self.rssi != nil ? "\(self.rssi!)" : noValue
        let timeStampPrintValue             = self.timeStamp != nil ? "\(self.timeStamp!)" : noValue
        let advIntervalEstimatePrintValue   = self.advIntervalEstimate != nil ? "\(self.advIntervalEstimate!)" : noValue
        
        return ("""
            Conectable: \(connectablePrintValue)
            Manufacturer Data: \(manufacturerDataPrintValue)
            Overflow Service UUIDs: \(overflowServiceUUIDsPrintValue)
            ServiceData: \(serviceDataPrintValue)
            Services: \(servicesPrintValue)
            Solicited Service UUIDs: \(solicitedServiceUUIDsPrintValue)
            Transmit Power Level: \(transmitPowerLevelPrintValue)
            Local Name: \(localNamePrintValue)
            RSSI: \(rssiPrintValue)
            Adv Estimate: \(advIntervalEstimatePrintValue)
            TimeStamp: \(timeStampPrintValue)
            """)
    }
}

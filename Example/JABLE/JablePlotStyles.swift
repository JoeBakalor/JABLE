//
//  JablePlotStyles.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CorePlot


struct JablePlotStyles{
    
    let titleStyle = CPTMutableTextStyle()
    let xAxisLabelStyle = CPTMutableTextStyle()
    let yAxisLabelStyle = CPTMutableTextStyle()
    let axisLineStyle = CPTMutableLineStyle()
    let plotLineStyle = CPTMutableLineStyle()
    
    init(){
        
        titleStyle.color = CPTColor.white()
        //textStyle.fontName = "HelveticaNeue-Bold"
        titleStyle.fontSize = 12.0
        titleStyle.textAlignment = .center
        
        xAxisLabelStyle.color = CPTColor.clear()
        //textStyle.fontName = "HelveticaNeue-Bold"
        xAxisLabelStyle.fontSize = 10.0
        
        yAxisLabelStyle.color = CPTColor.white()//(cgColor: UIColor.JableBlueThree.cgColor)
        //textStyle.fontName = "HelveticaNeue-Bold"
        yAxisLabelStyle.fontSize = 10.0
        
        axisLineStyle.lineColor = CPTColor.white()
        
        plotLineStyle.lineJoin = .round
        plotLineStyle.lineCap = .round
        plotLineStyle.lineWidth = 1.0
        plotLineStyle.lineColor = CPTColor.white()
        
    }
}

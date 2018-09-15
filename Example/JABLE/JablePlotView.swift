//
//  JablePlotView.swift
//  JABLE_Example
//
//  Created by Joe Bakalor on 9/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import CorePlot

class JablePlotView: CPTGraphHostingView{
    
    let graph                           = CPTXYGraph()
    let plotSpace                       = CPTXYPlotSpace()
    let scatterPlot                     = CPTScatterPlot()
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    internal func initView(){
        
        //set properties and add subviews
        hostedGraph = graph
        graph.backgroundColor = CPTColor(cgColor: UIColor.JableBlueFour.cgColor).cgColor
        graph.zPosition = 1_000
        graph.paddingLeft = 0.0
        graph.paddingRight = 0.0
        graph.paddingTop = 0.0
        graph.paddingBottom = 0.0
        graph.plotAreaFrame?.masksToBorder = false;
        graph.plotAreaFrame?.borderLineStyle = nil
        graph.plotAreaFrame?.cornerRadius = 0.0
        graph.title = "RSSI"
        graph.titleTextStyle = JablePlotStyles().titleStyle
        graph.titlePlotAreaFrameAnchor = .bottom
        
        let axisSet = graph.axisSet as! CPTXYAxisSet
        
        if let y = axisSet.yAxis {
            y.minorGridLineStyle = JablePlotStyles().axisLineStyle
            y.majorGridLineStyle = JablePlotStyles().axisLineStyle
            //y.minorTickLineStyle = style
            y.axisLineStyle = JablePlotStyles().axisLineStyle
            y.labelTextStyle = JablePlotStyles().yAxisLabelStyle//axisLabelStyle
            y.minorTickLength = 0
            y.majorTickLength = 0
            //y.tickDirection = .positive
            y.majorIntervalLength   = 0.5
            y.orthogonalPosition    = 0.0
            y.minorTicksPerInterval = 2
            y.labelExclusionRanges  = [
                CPTPlotRange(location: 0.99, length: 0.02),
                CPTPlotRange(location: 1.99, length: 0.02),
                CPTPlotRange(location: 2.99, length: 0.02)
            ]
        }

        if let x = axisSet.xAxis {
            //x.majorTickLineStyle = style
            x.minorGridLineStyle = JablePlotStyles().axisLineStyle
            x.majorGridLineStyle = JablePlotStyles().axisLineStyle
            //x.minorTickLineStyle = style
            x.axisLineStyle = JablePlotStyles().axisLineStyle
            x.labelTextStyle = JablePlotStyles().xAxisLabelStyle//axisLabelStyle
            x.minorTickLength = 0
            x.majorTickLength = 0
            //x.tickDirection = .positive
            x.majorIntervalLength   = 0.5
            x.minorTicksPerInterval = 5
            x.orthogonalPosition    = 0//2.0
            x.labelExclusionRanges  = [
                CPTPlotRange(location: 0.99, length: 0.02),
                CPTPlotRange(location: 1.99, length: 0.02),
                CPTPlotRange(location: 3.99, length: 0.02)
            ]
            x.delegate = self
        }
        
        plotSpace.allowsUserInteraction = false
        plotSpace.allowsMomentumX = true
        plotSpace.yRange = CPTPlotRange(location:1.0, length:2.0)
        plotSpace.xRange = CPTPlotRange(location:1.0, length:3.0)
        graph.add(plotSpace)
        
        scatterPlot.delegate = self
        scatterPlot.dataSource = self
        scatterPlot.dataLineStyle = JablePlotStyles().plotLineStyle
        scatterPlot.areaBaseValue = 0.0
        scatterPlot.areaFill = CPTFill(color: CPTColor.white().withAlphaComponent(0.25))
        scatterPlot.identifier    = NSString.init(string: "Blue Plot")
        graph.add(scatterPlot, to: plotSpace)
        
        // Add some initial data
        var contentArray = [plotDataType]()
        for i in 0 ..< 60 {
            let x = 1.0 + Double(i) * 0.05
            let y = 1.2 * Double(arc4random()) / Double(UInt32.max) + 1.2
            let dataPoint: plotDataType = [.X: x, .Y: y]
            contentArray.append(dataPoint)
        }
        self.dataForPlot = contentArray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graph.frame = self.bounds
        graph.plotAreaFrame?.paddingTop = 10.0
        graph.plotAreaFrame?.paddingLeft = 28.0
        graph.plotAreaFrame?.paddingBottom = 25.0
        graph.plotAreaFrame?.paddingRight = 5.0
    }
}

extension JablePlotView: CPTScatterPlotDataSource{

    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        return UInt(self.dataForPlot.count)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        let plotField = CPTScatterPlotField(rawValue: Int(field))
        
        if let num = self.dataForPlot[Int(record)][plotField!] {
            let plotID = plot.identifier as! String
            if (plotField! == .Y) && (plotID == "Green Plot") {
                return (num + 1.0) as NSNumber
            }
            else {
                return num as NSNumber
            }
        }
        else {
            return nil
        }
    }

}

extension JablePlotView: CPTScatterPlotDelegate{
    private func axis(_ axis: CPTAxis, shouldUpdateAxisLabelsAtLocations locations: NSSet!) -> Bool
    {
        if let formatter = axis.labelFormatter {
            let labelOffset = axis.labelOffset
            
            var newLabels = Set<CPTAxisLabel>()
            
            if let labelTextStyle = axis.labelTextStyle?.mutableCopy() as? CPTMutableTextStyle {
                for location in locations {
                    if let tickLocation = location as? NSNumber {
                        if tickLocation.doubleValue >= 0.0 {
                            labelTextStyle.color = .green()
                        }
                        else {
                            labelTextStyle.color = .red()
                        }
                        
                        let labelString   = formatter.string(for:tickLocation)
                        let newLabelLayer = CPTTextLayer(text: labelString, style: labelTextStyle)
                        
                        let newLabel = CPTAxisLabel(contentLayer: newLabelLayer)
                        newLabel.tickLocation = tickLocation
                        newLabel.offset       = labelOffset
                        
                        newLabels.insert(newLabel)
                    }
                }
                
                axis.axisLabels = newLabels
            }
        }
        
        return false
    }

}
















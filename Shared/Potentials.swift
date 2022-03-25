//
//  Potentials.swift
//  Homework 5
//
//  Created by Alaina Thompson on 3/25/22.
//

import Foundation
import SwiftUI



class Potential: ObservableObject{
    var plotDataModel: PlotDataClass? = nil
    @Published var x:[Double] = []
    @Published var V:[Double] = []
    var hbarsquareoverm = 7.62
    
    var plotPotentialData :[plotDataType] =  []
    
    // How to make slected potential change with the selection from user?
    @Published var selectedPotential = ""
    
    func startPotential(xMin: Double, xMax: Double, xStep: Double) {
        var count = 0
        var dataPoint: plotDataType = [.X: 0.0, .Y: 0.0]
        x.append(xMin)
        V.append(50000000.0)
        count = x.count
        dataPoint = [.X: x[count-1], .Y: V[count-1]]
        plotPotentialData.append(dataPoint)
        
    }
    
    func finishedPotential(xMin: Double, xMax: Double, xStep: Double) {
        var count = 0
        var dataPoint: plotDataType = [.X: 0.0, .Y: 0.0]
        x.append(xMax)
        V.append(50000000.0)
        count = x.count
        dataPoint = [.X: x[count-1], .Y: V[count-1]]
        plotPotentialData.append(dataPoint)
    }
    
    func getPotential(xMin: Double, xMax: Double, xStep: Double, selectedPotential: String) {
        var count = x.count
        var dataPoint: plotDataType = [.X: 0.0, .Y: 0.0]
        
        plotPotentialData.append(dataPoint)
        plotPotentialData.removeAll()
        
        
        switch selectedPotential {
            
            case "Square Well":
                    
            startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            
        for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {
            
            x.append(i)
            V.append(0.0)
            
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
        }
            
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            
            makeDataForPlot()
            
            case "Linear Well":
                         
            startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                         
        for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {
                            
            x.append(i)
            V.append((i-xMin)*4.0*1.3)
            //potential.oneDPotentialYArray.append((i-xMin)*0.25)
                             
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
                             
        }
                         
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            
            
            
            makeDataForPlot()
            
            case "Parabolic Well":
                            
            startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                            
        for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {
                                
            x.append(i)
            V.append((pow((i-(xMax+xMin)/2.0), 2.0)/1.0))
                                
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)

        }
                            
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)

            makeDataForPlot()
            
            case "Square + Linear Well":
                           
            startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                           
        for i in stride(from: xMin+xStep, to: (xMax+xMin)/2.0, by: xStep) {
                               
            x.append(i)
            V.append(0.0)
                               
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
                               
        }
                           
        for i in stride(from: (xMin+xMax)/2.0, through: xMax-xStep, by: xStep) {
                               
            x.append(i)
            V.append(((i-(xMin+xMax)/2.0)*4.0*0.1))
                               
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
                               
        }
                           
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            
            makeDataForPlot()
            
            case "Square Barrier":
                            
            startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                            
        for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.4, by: xStep) {
                                
            x.append(i)
            V.append(0.0)
                                
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
                                
            }
                            
        for i in stride(from: xMin + (xMax-xMin)*0.4, to: xMin + (xMax-xMin)*0.6, by: xStep) {
                                
            x.append(i)
            V.append(15.000000001)
                                
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
                                
            }
                            
        for i in stride(from: xMin + (xMax-xMin)*0.6, to: xMax, by: xStep) {
                                
            x.append(i)
            V.append(0.0)
                                
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
            }
                            
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                    
            makeDataForPlot()
            
            case "Triangle Barrier":
                           
            var dataPoint: plotDataType = [:]
            var count = 0
                           
            startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                        
        for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.4, by: xStep) {
                               
            x.append(i)
            V.append(0.0)
                               
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
            }
                           
        for i in stride(from: xMin + (xMax-xMin)*0.4, to: xMin + (xMax-xMin)*0.5, by: xStep) {
                               
            x.append(i)
            V.append((abs(i-(xMin + (xMax-xMin)*0.4))*3.0))
                               
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
                               
            }
                           
        for i in stride(from: xMin + (xMax-xMin)*0.5, to: xMin + (xMax-xMin)*0.6, by: xStep) {
                               
            x.append(i)
            V.append((abs(i-(xMax - (xMax-xMin)*0.4))*3.0))
                               
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)

            }
                           
        for i in stride(from: xMin + (xMax-xMin)*0.6, to: xMax, by: xStep) {
                               
            x.append(i)
            V.append(0.0)
                               
            count = x.count
            dataPoint = [.X: x[count-1], .Y: V[count-1]]
            plotPotentialData.append(dataPoint)
            }
                           
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                    
            makeDataForPlot()
            
        case "Coupled Parabolic Well":
                          
                          var dataPoint: plotDataType = [:]
                          var count = 0
                          
                          startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                          
                          for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.5, by: xStep) {
                              
                              x.append(i)
                              V.append((pow((i-(xMin+(xMax-xMin)/4.0)), 2.0)))
                              
                              count = x.count
                              dataPoint = [.X: x[count-1], .Y: V[count-1]]
                              plotPotentialData.append(dataPoint)
                              
                          }
                          
                          for i in stride(from: xMin + (xMax-xMin)*0.5, through: xMax-xStep, by: xStep) {
                              
                             x.append(i)
                              V.append((pow((i-(xMax-(xMax-xMin)/4.0)), 2.0)))
                              
                              count = x.count
                              dataPoint = [.X: x[count-1], .Y: V[count-1]]
                             plotPotentialData.append(dataPoint)
                              
                          }
            finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            makeDataForPlot()
            
        case "Coupled Square Well + Field":
                           
                           var dataPoint: plotDataType = [:]
                           
                           startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                           
                           for i in stride(from: xMin+xStep, to: xMin + (xMax-xMin)*0.4, by: xStep) {
                               
                               x.append(i)
                               V.append(0.0)
                               
                           }
                           
                           for i in stride(from: xMin + (xMax-xMin)*0.4, to: xMin + (xMax-xMin)*0.6, by: xStep) {
                               
                               x.append(i)
                               V.append(4.0)
                               
                           }
                           
                           for i in stride(from: xMin + (xMax-xMin)*0.6, to: xMax, by: xStep) {
                               
                               x.append(i)
                               V.append(0.0)
                   
                           }
                           
                           for i in 1 ..< (x.count) {
                               
                               V[i] += ((x[i]-xMin)*4.0*0.1)
                               dataPoint = [.X: x[i], .Y: V[i]]
                               plotPotentialData.append(dataPoint)
                           }
                           
                           
                           finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            
            makeDataForPlot()
            
        case "Harmonic Oscillator":
                            
                            var dataPoint: plotDataType = [:]
                            var count = 0
                            
                            let xMinHO = -20.0
                            let xMaxHO = 20.0
                            let xStepHO = 0.001
                            
                            startPotential(xMin: xMinHO+xMaxHO, xMax: xMaxHO+xMaxHO, xStep: xStepHO)
                            
                            for i in stride(from: xMinHO+xStepHO, through: xMaxHO-xStepHO, by: xStepHO) {
                                
                                x.append(i+xMaxHO)
                                V.append((pow((i-(xMaxHO+xMinHO)/2.0), 2.0)/15.0))
                                
                                count = x.count
                                dataPoint = [.X: x[count-1], .Y: V[count-1]]
                                plotPotentialData.append(dataPoint)
                            }
                            
                            finishedPotential(xMin: xMinHO+xMaxHO, xMax: xMaxHO+xMaxHO, xStep: xStepHO)
            
            makeDataForPlot()
            
       
      
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        default:
                           
                    startPotential(xMin: xMin, xMax: xMax, xStep: xStep)
                    
                for i in stride(from: xMin+xStep, through: xMax-xStep, by: xStep) {
                    
                    x.append(i)
                    V.append(0.0)
                    
                    count = x.count
                    dataPoint = [.X: x[count-1], .Y: V[count-1]]
                    plotPotentialData.append(dataPoint)
                }
                    
                    finishedPotential(xMin: xMin, xMax: xMax, xStep: xStep)
            
            
            
            
            }
            

            
            
            
    }
    
    func makeDataForPlot() {
        plotDataModel!.zeroData()

        plotDataModel!.calculatedText = "The Potential is: \n"
                plotDataModel!.calculatedText += "x and V \n"
                
              


                
                    //set the Plot Parameters
                    plotDataModel!.changingPlotParameters.yMax = 18.0
                    plotDataModel!.changingPlotParameters.yMin = -18.1
                    plotDataModel!.changingPlotParameters.xMax = 15.0
                    plotDataModel!.changingPlotParameters.xMin = -1.0
                    plotDataModel!.changingPlotParameters.xLabel = "x"
                    plotDataModel!.changingPlotParameters.yLabel = "V"
                    plotDataModel!.changingPlotParameters.lineColor = .red()
                    plotDataModel!.changingPlotParameters.title = "V vs x"
                        
        for i in 0..<x.count {
        plotDataModel!.calculatedText += "\(x[i]), \t\(V[i])\n"
        
                    let dataPoint: plotDataType = [.X: x[i], .Y: V[i]]
                    plotDataModel!.appendData(dataPoint: [dataPoint])
                    
                
        }
    }
    
    
}

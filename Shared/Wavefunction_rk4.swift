//
//  Wavefunction_rk4.swift
//  Homework 5
//
//  Created by Alaina Thompson on 3/31/22.
//
import Foundation
import SwiftUI
import Darwin
import CorePlot



class RK4: NSObject,ObservableObject {

var plotDataModel: PlotDataClass? = nil
var PotentialData: Potential? = nil
var e = Darwin.M_E
// hbar and m are in eV
var hbar = Double(pow(200.0, 6))
var m = 0.510998950

let hbarsquareoverm = 7.62 /* units of eV A^2*/

// h = step size
var h = 0.1

var E = 0.0

var x_i = 0.0
var x_0 = 0.0
var psi_i = 0.0
var psi_prime = 0.05


var iterations = 0.0
var f2 = 0.0
var f1 = 0.0
var fn = 0.0

var xPoint = 0.0
var psiPoint = 0.0
var psi_num = 0.0

@Published var x_array:[Double] = []
//   var x_array = [Double]()
@Published var psi_array:[Double] = []
//    var psi_array = [Double]()
@Published var psi_prime_array:[Double] = []
//   var psi_prime_array = [Double]()
@Published var psi_String = ""

var lastPsi :[Double] = []

@Published var selectedPotential = ""
@Published var enableButton = true


    
func calculateRK4(E: Double, xMax: Double, xMin: Double, xStep: Double) -> Double {
    
    
    

    let schrodingerConstant = hbarsquareoverm/2.0
    
    let V = PotentialData!.V

    var n = xMin
    let L = xMax
    let h = xStep
    var f_num = (V[0]-E)/schrodingerConstant
    
    var psi_double_prime = f_num*psi_i
    
    var normalization = 0.0
            
    
    
    
  
    
    
    x_array.append(n)
    psi_array.append(psi_i)
    psi_prime_array.append(psi_prime)
    
    var i = 0

    
    
    while (abs( L - n ) > 1e-8) {
        
        
        
        psi_i = psi_i + h*psi_prime
        psi_prime = psi_prime + h * psi_double_prime
        
        f_num = (V[i]-E)/schrodingerConstant
        psi_double_prime = f_num*psi_i
        i+=1
        n += h
        x_array.append(n)
        psi_array.append(psi_i)
        psi_prime_array.append(psi_prime)
        
    }
    
}
    
}

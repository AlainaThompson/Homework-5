//
//  ContentView.swift
//  Shared
//
//  Created by Alaina Thompson on 3/11/22.
//

import SwiftUI
import Accelerate

struct ContentView: View {
    
    @State var resultsString = ""
    @EnvironmentObject var plotDataModel :PlotDataClass
    @ObservedObject var myPotential = Potential()
    @ObservedObject var myMatrix = MatrixEqs()
    @State var xMax: String = "10.0"
    @State var isChecked:Bool = false
    @State var number = 20 // Number of states
    
    
    @State var potentialTypes = ["Square Well", "Linear Well", "Parabolic Well", "Square+Linear", "Square Barrier", "Triangle Barrier", "Coupled Parabolic Well", "Coupled Square Well + Field", "Harmonic Oscillator", "Kronig - Penny", "Variable Kronig Penny", "KP2-a"]
    @State var selectedPotential = "Square Well"
    
    @State var energyLevels: [String] = []
    @State var slectedEnergy = ""

    var body: some View {
        VStack{
      
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            
            
            Picker("Potential:", selection: $selectedPotential) {
                ForEach(potentialTypes, id: \.self) {
                    Text($0)
                    
                }
            
            }
            Picker("Psi:", selection: $selectedEnergy) {
                ForEach(energyLevels, id: \.self) {
                    Text($0)
                    
                }
            }
           
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("Box Length")
                        .font(.callout)
                        .bold()
                    TextField("length value", text: $xMax)
                        .padding(.bottom, 5.0)
                }.padding()
                
                
            }
            
          
            
            
            HStack{
                Button("Calculate potential", action: {
                    
                    self.calculatePotential()} )
                .padding()
                
            }
            
            HStack{
                Button("Calculate wavefunction", action: {self.calculateWaveFunction()} )
                .padding()
                
            }
            HStack{
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    
            }
            
            
        }
        
    }
    
    
   
    
    
    func calculatePotential(){
        
      
        
        myPotential.plotDataModel = self.plotDataModel
        
        myPotential.getPotential(xMin: 0.0, xMax: 10.0, xStep: 0.01, selectedPotential: selectedPotential)
        
        
        
        
        
        
    }
    
    func calculateWaveFunction(){
        self.calculatePotential()
       
        myMatrix.PotentialData = myPotential
        
        myMatrix.plotDataModel = self.plotDataModel
        
        myMatrix.calculateHamiltonian(E: 0.376, xMax: 10.0, xMin: 0.0, xStep: 0.01)
       
        
       
        
        
    }

    func clear(){
            
        myPotential.plotPotentialData.removeAll()
        myMatrix.x_array = []
        myMatrix.psi_array = []
        myMatrix.psi_prime_array = []
            
            
        }

}

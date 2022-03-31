//
//  Matrix_Form_Schrodinger .swift
//  Homework 5
//
//  Created by Alaina Thompson on 3/25/22.
//
import SwiftUI
import Foundation
import Accelerate 

class MatrixEqs: NSObject,ObservableObject {
    var plotDataModel: PlotDataClass? = nil
    var PotentialData: Potential? = nil
    // hbar and m are in eV
    var hbar = Double(pow(200.0, 6))
    var m = 0.510998950
    let hbarsquareoverm = 7.62 /* units of eV A^2*/
    var h = 0.1 //stepsize
    
    
    @Published var selectedPotential = ""
    @Published var enableButton = true
//Energy Values Square Well:
//E1 = 0.369
//E = pow(n, 2)*E1
    @Published var E:[Double] = []
    @Published var psi:[Double] = []
    
    func infiniteWellEnergy(number: Int) -> Double{

            let E1 = 0.369
            
            return E1*pow(Double(number),2)
        }
        
    
        func wavefunctions(number: Int, x_i: Double) -> Double{
            let L = xMax
            let root = sqrt(2/L)
            let numerator = Double(number)*Double.pi*x_i
            let psi_i = root*sin(numerator/L)
            
            return psi_i
        }
        
        func rk4Wavefunction(){
            //Get wavefunction from the solution to particle in a box case from rk4 method
            //Use as basis for psi and energy values in hamiltonian 
            
        }
    
    
    
    
    
    
    
    
func calculateHamiltonian(E: Double, xMax: Double, xMin: Double, xStep: Double) -> Double {
    
//Set up H and diagnolize to get wavefunction(eigenvectors)
//Eigenvalues of H are the energies
    let schrodingerConstant = hbarsquareoverm/2.0
    
    let V = PotentialData!.V
    let squareWellWavefunction = RK4() //get values from 1D particle in a box solution to plug into matrix.
    var n = xMin
    let L = xMax
    let h = xStep
    var f_num = (V[0]-E)/schrodingerConstant
    var matrixSize = 20 //20x20 matrix 
    
    let H = -1.0*hbarsquareoverm/(2*pow(h,2))
    
    var hamiltonianArray: [[Double]] = []
            
            for i in  0...Int(matrixSize)-1{
                var array = Array(repeating: 0.0, count: Int(matrixSize))
               
                if (i == 0){
                    array[i] = -2.0*H
                    array[i+1] = 1.0*H
                }
                
                else if (i == Int(matrixSize)-1){
                    array[i] = -2.0*H
                    array[i-1] = 1.0*H
                }
                
                else {
                    array[i-1] =  1.0*H
                    array[i]   = -2.0*H
                    array[i+1] =  1.0*H
                }
                
                hamiltonianArray.append(array)
                
            }
            
            
            let N = Int32(hamiltonianArray.count)
            
            let flatArray :[Double] = pack2dArray(arr: hamiltonianArray, rows: Int(N), cols: Int(N))
    
    // Add in Potential to Hamiltonian
            calculateEigenvalues(arrayForDiagonalization: flatArray)
            
        }

        
        /// calculateEigenvalues
        ///
        /// - Parameter arrayForDiagonalization: linear Column Major FORTRAN Array for Diagonalization
        /// - Returns: String consisting of the Eigenvalues and Eigenvectors
        func calculateEigenvalues(arrayForDiagonalization: [Double]) {
            /* Integers sent to the FORTRAN routines must be type Int32 instead of Int */
            //var N = Int32(sqrt(Double(startingArray.count)))
            
            
            var N  = Int32(sqrt(Double(arrayForDiagonalization.count)))
            var N2 = Int32(sqrt(Double(arrayForDiagonalization.count)))
            var N3 = Int32(sqrt(Double(arrayForDiagonalization.count)))
            var N4 = Int32(sqrt(Double(arrayForDiagonalization.count)))

            var flatArray = arrayForDiagonalization
            
            var error : Int32 = 0
            var lwork = Int32(-1)
            // Real parts of eigenvalues
            var wr = [Double](repeating: 0.0, count: Int(N))
            // Imaginary parts of eigenvalues
            var wi = [Double](repeating: 0.0, count: Int(N))
            // Left eigenvectors
            var vl = [Double](repeating: 0.0, count: Int(N*N))
            // Right eigenvectors
            var vr = [Double](repeating: 0.0, count: Int(N*N))
            
            
            /* Eigenvalue Calculation Uses dgeev */
            /*   int dgeev_(char *jobvl, char *jobvr, Int32 *n, Double * a, Int32 *lda, Double *wr, Double *wi, Double *vl,
             Int32 *ldvl, Double *vr, Int32 *ldvr, Double *work, Int32 *lwork, Int32 *info);*/
            
            /* dgeev_(&calculateLeftEigenvectors, &calculateRightEigenvectors, &c1, AT, &c1, WR, WI, VL, &dummySize, VR, &c2, LWork, &lworkSize, &ok)    */
            /* parameters in the order as they appear in the function call: */
            /* order of matrix A, number of right hand sides (b), matrix A, */
            /* leading dimension of A, array records pivoting, */
            /* result vector b on entry, x on exit, leading dimension of b */
            /* return value =0 for success*/
            
            
            /* Calculate size of workspace needed for the calculation */
            
            var workspaceQuery: Double = 0.0
            dgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &wr, &wi, &vl, &N3, &vr, &N4, &workspaceQuery, &lwork, &error)
            
            print("Workspace Query \(workspaceQuery)")
            
            /* size workspace per the results of the query */
            
            var workspace = [Double](repeating: 0.0, count: Int(workspaceQuery))
            lwork = Int32(workspaceQuery)
            
            /* Calculate the size of the workspace */
            
            dgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &wr, &wi, &vl, &N3, &vr, &N4, &workspace, &lwork, &error)
            
            
            energies = wr
            psi = unpack2dArray(arr: vr, rows: Int(N), cols: Int(N))
        
        }
        
        
        /// pack2DArray
        /// Converts a 2D array into a linear array in FORTRAN Column Major Format
        ///
        /// - Parameters:
        ///   - arr: 2D array
        ///   - rows: Number of Rows
        ///   - cols: Number of Columns
        /// - Returns: Column Major Linear Array
        func pack2dArray(arr: [[Double]], rows: Int, cols: Int) -> [Double] {
            var resultArray = Array(repeating: 0.0, count: rows*cols)
            for Iy in 0...cols-1 {
                for Ix in 0...rows-1 {
                    let index = Iy * rows + Ix
                    resultArray[index] = arr[Ix][Iy]
                }
            }
            return resultArray
        }
        
        /// unpack2DArray
        /// Converts a linear array in FORTRAN Column Major Format to a 2D array in Row Major Format
        ///
        /// - Parameters:
        ///   - arr: Column Major Linear Array
        ///   - rows: Number of Rows
        ///   - cols: Number of Columns
        /// - Returns: 2D array
        func unpack2dArray(arr: [Double], rows: Int, cols: Int) -> [[Double]] {
            var resultArray = [[Double]](repeating:[Double](repeating:0.0 ,count:rows), count:cols)
            for Iy in 0...cols-1 {
                for Ix in 0...rows-1 {
                    let index = Iy * rows + Ix
                    resultArray[Iy][Ix] = arr[index]
                }
            }
            return resultArray
     
        func makeWaveFunctionPlot() {
            plotDataModel!.zeroData()

            plotDataModel!.calculatedText = "The WaveFunction is: \n"
            plotDataModel!.calculatedText += "x and Psi \n"
                        
                      


                        
            //set the Plot Parameters
            plotDataModel!.changingPlotParameters.yMax = 18.0
            plotDataModel!.changingPlotParameters.yMin = -18.1
            plotDataModel!.changingPlotParameters.xMax = 15.0
            plotDataModel!.changingPlotParameters.xMin = -1.0
            plotDataModel!.changingPlotParameters.xLabel = "x"
            plotDataModel!.changingPlotParameters.yLabel = "Psi"
            plotDataModel!.changingPlotParameters.lineColor = .red()
            plotDataModel!.changingPlotParameters.title = "Psi vs x"
                                
            for i in 0..<x_array.count {
                plotDataModel!.calculatedText += "\(x_array[i]), \t\(psi_array[i])\n"
                
                let dataPoint: plotDataType = [.X: x_array[i], .Y: psi_array[i]]
                plotDataModel!.appendData(dataPoint: [dataPoint])
                            
                        
                }
            }
            
            
            
            
}
    @MainActor func setButtonEnable(state: Bool) {
           if state {
               Task.init {
                   await MainActor.run {
                       self.enableButton = true
                   }
               }
           }
           else{
               Task.init {
                   await MainActor.run {
                       self.enableButton = false
                   }
               }
           }
       }
    

}

//
//  Card.swift
//  BoomerangCard
//
//  Created by Cristian Cretu on 09.09.2022.
//

import SwiftUI

let delay: Double = 0.17
let startingOffset = 550.0
let size: Int = 4

struct Card: View {
    // Props
    let color: Color
    let index: Int
    @Binding var topCard: Int
    
    //  Card State
    @State var rotation: Double = 0.0
    @State var zIndex: Double = 0.0
    @State var dragTranslation: CGSize = CGSize(width: 0, height: startingOffset)
    
    // linear scale
    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
    }
    
    // Rotation based on velocity
    func rotationalScale(value: CGFloat) -> CGFloat {
        return round(scale(inputMin: 0, inputMax: 1, outputMin: 0, outputMax: 3, value: value))
    }
    
    // Translation based on velocity
    func locationScale(value: CGFloat) -> CGFloat {
        return scale(inputMin: 0, inputMax: 1, outputMin: -500, outputMax: 300, value: value)
    }
    
    // Resting offset based on velocity
    func offsetScale(topCard: Int, index: Int) -> CGFloat {
        let position = findPosition(topCard: topCard, index: index)
        return scale(inputMin: 1, inputMax: 4, outputMin: 60, outputMax: 0, value: CGFloat(position))
    }
    
    // For a given card and a topCard, determine where it is in the stack
    func findPosition(topCard: Int, index: Int) -> Int {
        let order = findOrder(topCard: topCard)
        let position = order.firstIndex(of: index)
        return position!
    }
    
    // For a given topCard, return the correct order
    func findOrder(topCard: Int) -> [Int] {
        var arr: [Int] = []
        
        arr.insert(topCard, at: 0)
        for i in 1...size {
            if (arr[i - 1] == size) {
                arr[i] = 1
            } else {
                arr[i] = arr[i - 1] + 1
            }
        }
        
        return arr
    }
    
    var body: some View {
        Text("he;")
    }
}

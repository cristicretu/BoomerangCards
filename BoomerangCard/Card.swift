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
    
    // Change scale based on the topCard value
    func sizeScale(topCard: Int, index: Int) -> CGFloat {
        let position = findPosition(topCard: topCard, index: index)
        return scale(inputMin: 0.0, inputMax: 4.0, outputMin: 0.7, outputMax: 1, value: CGFloat(4 - position))
    }
    
    // For a given card and a topCard, determine where it is in the stack
    func findPosition(topCard: Int, index: Int) -> Int {
        let order = findOrder(topCard: topCard)
        let position = order.firstIndex(of: index)
        return position!
    }
    
    // For a given topCard, return the correct order
    func findOrder(topCard: Int) -> [Int] {
//        switch topCard {
//            case
//        }
        var arr = Array(repeating: 0, count: size)

        arr[0] = topCard
        for i in 1...(size - 1){
            if (arr[i - 1] == size) {
                arr[i] = 1
            } else {
                arr[i] = arr[i - 1] + 1
            }
        }

        print(arr)
        return arr
    }
    
    var drag: some Gesture {
        return DragGesture()
            .onChanged { gesture in
                dragTranslation.height = gesture.translation.height + startingOffset
            }
            .onEnded { gesture in
                let predictedEndTranslation: Double = gesture.predictedEndTranslation.height
                let velocity = abs(predictedEndTranslation - gesture.translation.height) / 1500
                
                var shouldRotate: Bool
                if  velocity > 0.1 {
                    shouldRotate = true
                } else {
                    shouldRotate = false
                }
                
                if predictedEndTranslation <= -250 {
                    if topCard < 4 {
                        topCard += 1
                    } else {
                        topCard = 1
                    }
                    
                    // Animate up to the peak
                    if shouldRotate {
                        withAnimation(.easeOut(duration: delay)) {
                            dragTranslation.height = locationScale(value: 1 - velocity)
                            rotation -= rotationalScale(value: velocity) * 180
                        }
                    }
                    
                    // At the peak, update the z index
                    DispatchQueue.main.asyncAfter(deadline: shouldRotate ? .now() + delay : .now()) {
                        zIndex -= 1
                    }
                    
                    // Animate down to the resting state
                    withAnimation(.spring().delay(shouldRotate ? delay : 0)) {
                        dragTranslation.height = startingOffset
                        rotation -= shouldRotate ? rotationalScale(value: velocity) * 180 : 0
                    }
                } else {
                    withAnimation(.spring()) {
                        dragTranslation.height = startingOffset
                    }
                }
            }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color)
                            .frame(width: 100, height: 16)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color)
                            .frame(width: 60, height: 16)
                    }
                    Spacer()
                    
                }.padding(30)
                .brightness(-0.3)
            }
            
        }
        .frame(width: 320, height: 220, alignment: .center)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .rotationEffect(.degrees(rotation))
        .scaleEffect(sizeScale(topCard: topCard, index: index))
        .position(x: UIScreen.main.bounds.width / 2,y: dragTranslation.height)
        .zIndex(zIndex)
        .offset(y: offsetScale(topCard: topCard, index: index))
        .animation(.spring(), value: topCard)
        .gesture(drag)
        .allowsHitTesting(topCard == index)
    }
}

//
//  ContentView.swift
//  BoomerangCard
//
//  Created by Cristian Cretu on 09.09.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var topCard = 1

    var body: some View {
        ZStack {
            Card(color: .yellow, index: 4, topCard: $topCard)
            Card(color: .red, index: 3, topCard: $topCard)
            Card(color: .white, index: 2, topCard: $topCard)
            Card(color: .blue, index: 1, topCard: $topCard)
        }
        .preferredColorScheme(.dark)
        .statusBar(hidden: true)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

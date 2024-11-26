//
//  ContentView.swift
//  IOS
//
//  Created by Curt Spark on 25/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var test: [String]
    @State var elements: [any View]

    init() {
        test = ["hi", "there"]
        elements = []

        elements = test.map({
            Text($0)
        })
    }

    var body: some View {
        VStack {
            Button("New Item", action: {
                test.append("Wooo")
            })
                .frame(width: 50, height: 50)
            List(test, id: \.self) { item in
                Text(item)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

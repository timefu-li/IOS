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

    init() {
        test = ["hi", "there"]
    }

    var body: some View {
        VStack {
            List(test, id: \.self, rowContent: { item in
                Text(item)
            })
            HStack {
                Button("New Item", action: {
                    test.append("Wooo")
                })
                    .frame(width: 50, height: 50)
                Button("New Item 2", action: {
                    test.append("Wooo")
                })
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  HomeView.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var test: [String]

    init() {
        test = ["hi", "there", "edited"]
    }

    var body: some View {
        VStack {
            List(test, id: \.self, rowContent: { (item: String) in
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
    HomeView()
}

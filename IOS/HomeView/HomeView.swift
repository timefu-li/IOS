//
//  HomeView.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var tasks: [Task]

    init() {
        tasks = []
    }

    var body: some View {
        VStack {
            List(tasks, id: \.self, rowContent: { (taskelement: Task) in
                Text(taskelement.name ?? "No name found!")
            }).task({ () async -> Void in
                do {
                    tasks = try await APIHandler.fetchTasks()
                    print(tasks)
                } catch {
                    tasks = []
                    print("Encountered the following error fetching tasks! :\(error)")
                }
            })
            //HStack {
            //    Button("New Item", action: {
            //        test.append("Wooo")
            //    })
            //        .frame(width: 50, height: 50)
            //    Button("New Item 2", action: {
            //        test.append("Wooo")
            //    })
            //        .frame(width: 50, height: 50)
            //}
        }
    }
}

#Preview {
    HomeView()
}

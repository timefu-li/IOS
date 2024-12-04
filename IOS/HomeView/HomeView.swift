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
    @State var errorstate: any Error

    init() {
        tasks = []
        errorstate = APIHandler.APIHandlerError.OK
    }

    var body: some View {
        VStack {
            List(tasks, id: \.self, rowContent: { (taskelement: Task) in
                Text(taskelement.name ?? "No name found!")
            }).task({ () async -> Void in
                do {
                    tasks = try await APIHandler.getTasks()
                    print("Fetched following tasks...")
                    print(tasks)
                } catch {
                    tasks = []
                    errorstate = error.self
                    print("Encountered the following error fetching tasks!")
                    print("\(error.self) : \(error.localizedDescription)")
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

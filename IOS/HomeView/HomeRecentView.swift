//
//  HomeTasksView.swift
//  IOS
//
//  Created by Curt Spark on 05/12/2024.
//

import SwiftUI
import SwiftData

struct HomeTasksView: View {
    @State var tasks: [Task]
    @State var errorstate: any Error

    init() {
        tasks = []
        errorstate = APIHandler.APIHandlerError.OK
    }

    var body: some View {
        VStack {

            // Tasks list
            Group(content: {
                    switch errorstate {
                        case APIHandler.APIHandlerError.OK:
                            List(content: {
                                Section (content: {
                                    ForEach(tasks, id: \.self, content: { (taskelement: Task) in
                                        Button("\(taskelement.category?.emoji ?? "")  \(taskelement.name ?? "No name found!")", action: {
                                            print(taskelement.name ?? "No name found!")
                                        })
                                    })
                                }, header: { Label("Recently used tasks", systemImage: "1.circle") })
                            })
                        case APIHandler.APIHandlerError.decodeModelError(reason: "NOTFOUND:No tasks found"):
                            Text("No tasks found!")
                        default:
                            Text("Received following error!")
                            Text("\(errorstate.self) : \(errorstate.localizedDescription)")
                    }
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
    HomeTasksView()
}

//
//  HomeTasksView.swift
//  IOS
//
//  Created by Curt Spark on 05/12/2024.
//

import SwiftUI
import SwiftData

struct HomeTasksView: View {
    @State var tasks: [TaskModel]
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
                                             ForEach(tasks, id: \.self, content: { (taskelement: TaskModel) in
                                                                            TaskButton(taskelement: taskelement)
                                                                        })
                                }, header: { Label("Recently used tasks", systemImage: "1.circle") })
                            })
                        case APIHandler.APIHandlerError.decodeModelError(reason: "NOTFOUND:No tasks found"):
                            Text("No tasks found!")
                        default:
                            Text("Received following error!")
                            Text("\(errorstate.self) : \(errorstate.localizedDescription)")
                    }
            })
    }.task({ () async -> Void in
                do {
                    tasks = try await APIHandler.getTasks()
                } catch {
                    tasks = []
                    errorstate = error.self
                    print("Encountered the following error fetching tasks!")
                    print("\(error.self) : \(error.localizedDescription)")
                }
            })
        }
}

#Preview {
    HomeTasksView()
}

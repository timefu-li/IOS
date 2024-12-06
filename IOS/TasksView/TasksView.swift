//
//  TasksView.swift
//  IOS
//
//  Created by Curt Spark on 05/12/2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @State var categories: [CategoryModel]
    @State var errorstate: any Error

    init() {
        categories = []
        errorstate = APIHandler.APIHandlerError.OK
    }

    var body: some View {
        VStack {

            NavigationStack {
                // Tasks list
                switch errorstate {
                    case APIHandler.APIHandlerError.OK:
                        List(content: {
                            ForEach(categories, id: \.self, content: { (categoryelement: CategoryModel) in
                                let tasks: [TaskModel] = categoryelement.tasks ?? []
                                if (tasks.count > 0) {
                                    Section (content: {
                                        ForEach(tasks, id: \.self, content: { (taskelement: TaskModel) in
                                            Button("\(taskelement.category?.emoji ?? "")  \(taskelement.name ?? "No name found!")", action: {
                                                print(taskelement.name ?? "No name found!")
                                            })
                                        })
                                            .listRowBackground(categoryelement.colour?.toSwiftColor())
                                            .foregroundColor(categoryelement.colour?.toSwiftColor().adaptedTextColor())
                                    }, header: { Text("\(categoryelement.emoji ?? "") \(categoryelement.name ?? "Category name not found!")") })
                                }
                            })
                        })
                    case APIHandler.APIHandlerError.decodeModelError(reason: "NOTFOUND:No categories found"):
                        Text("No tasks found!")
                    default:
                        Text("Received following error!")
                        Text("\(errorstate.self) : \(errorstate.localizedDescription)")
                }
                NavigationLink(destination: TasksAddView(), label: {
                    Text("New Task")
                })
            }

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
        }.task({ () async -> Void in
                do {
                    categories = try await APIHandler.getCategories()
                } catch {
                    categories = []
                    errorstate = error.self
                    print("Encountered the following error fetching tasks!")
                    print("\(error.self) : \(error.localizedDescription)")
                }
            })
    }
}

#Preview {
    TasksView()
}

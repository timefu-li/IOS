//
//  TasksView.swift
//  IOS
//
//  Created by Curt Spark on 05/12/2024.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
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
                        List(categories, id: \.self, rowContent: { (categoryelement: CategoryModel) in
                            Button("\(categoryelement.emoji ?? "")  \(categoryelement.name ?? "No name found!")", action: {
                                print(categoryelement.name ?? "No name found!")
                            })
                                .listRowBackground(categoryelement.colour?.toSwiftColor())
                                .foregroundColor(categoryelement.colour?.toSwiftColor().adaptedTextColor())
                        })
                    case APIHandler.APIHandlerError.decodeModelError(reason: "NOTFOUND:No categories found"):
                        Text("No categories found!")
                    default:
                        Text("Received following error!")
                        Text("\(errorstate.self) : \(errorstate.localizedDescription)")
                }
                NavigationLink(destination: CategoriesAddView(), label: {
                    Text("New Category")
                })
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
    CategoriesView()
}

//
//  TasksAddView.swift
//  IOS
//
//  Created by Curt Spark on 06/12/2024.
//

import SwiftUI
import SwiftData
import EmojiPicker

struct CategoriesAddView: View {
    @State var categories: [CategoryModel]
    @State var errorstate: any Error

    @State var selectemoji: Bool = false

    @State var taskname: String
    @State var taskemoji: Emoji?
    @State var categorycolour: Color

    init() {
        categories = []
        errorstate = APIHandler.APIHandlerError.OK

        taskname = ""
        categorycolour = Color(red: 128.0, green: 128.0, blue: 128.0)
    }

    var body: some View {
        VStack {

                    Form {
                        Section(header: Text("Category name")) {
                            TextField(text: $taskname, prompt: Text("My category")) {
                                Text("Category")
                            }
                        }
                        Section(header: Text("Attributes")) {
                            //TextField(text: $taskemoji, prompt: Text("Emoji")) {
                            //    Text("Emoji")
                            //}
                            Button {
                                selectemoji = true
                            } label: {
                                
                            }
                            ColorPicker("Category Colour", selection: $categorycolour)
                                    .listRowBackground(categorycolour)
                                    .foregroundColor(categorycolour.adaptedTextColor())
                        }
                        Button("New Category", action: {
                            Task {
                                let newcategorymodel = CategoryModel(name: taskname, emoji: taskemoji?.value, colour: BackendColor.toBackendColor(swiftcolor: categorycolour))

                                let result = try await APIHandler.newCategory(category: newcategorymodel)
                            }
                        })
                    }.sheet(isPresented: $selectemoji, content: {
                        NavigationView {
                            EmojiPickerView(selectedEmoji: $taskemoji, selectedColor: .orange)
                        }
                    })
        }
    }
}

#Preview {
    CategoriesAddView()
}

//
//  TasksAddView.swift
//  IOS
//
//  Created by Curt Spark on 06/12/2024.
//

import SwiftUI
import SwiftData

struct CategoriesAddView: View {
    @State var categories: [CategoryModel]
    @State var errorstate: any Error

    @State var taskname: String
    @State var taskemoji: String
    @State var categorycolour: Color

    init() {
        categories = []
        errorstate = APIHandler.APIHandlerError.OK

        taskname = ""
        taskemoji = ""
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
                    TextField(text: $taskemoji, prompt: Text("Emoji")) {
                        Text("Emoji")
                    }
                    ColorPicker("Category Colour", selection: $categorycolour)
                            .listRowBackground(categorycolour)
                            .foregroundColor(categorycolour.adaptedTextColor())
                }
                //Section(header: Text("Notifications")) {
                //    Picker("Notify Me About", selection: $notifyMeAbout) {
                //        Text("Direct Messages").tag(1)
                //        Text("Mentions").tag(2)
                //        Text("Anything").tag(3)
                //    }
                //    Toggle("Play notification sounds", isOn: $playNotificationSounds)
                //    Toggle("Send read receipts", isOn: $sendReadReceipts)
                //}
                //Section(header: Text("User Profiles")) {
                //    Picker("Profile Image Size", selection: $profileImageSize) {
                //        Text("Large").tag(1)
                //        Text("Medium").tag(2)
                //        Text("Small").tag(3)
                //    }
                //}
                Button("New Category", action: {
                    Task {
                        let newcategorymodel = CategoryModel(name: taskname, emoji: taskemoji, colour: BackendColor.toBackendColor(swiftcolor: categorycolour))

                        let result = try await APIHandler.newCategory(category: newcategorymodel)
                    }
                })
            }

        }
    }
}

#Preview {
    CategoriesAddView()
}

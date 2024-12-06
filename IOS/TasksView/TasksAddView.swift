//
//  TasksAddView.swift
//  IOS
//
//  Created by Curt Spark on 06/12/2024.
//

import SwiftUI
import SwiftData

struct TasksAddView: View {
    @State var categories: [CategoryModel]
    @State var errorstate: any Error

    @State var taskname: String
    @State var categoryselection: CategoryModel?
    @State var playNotificationSounds: Bool

    init() {
        categories = []
        errorstate = APIHandler.APIHandlerError.OK

        taskname = ""
        playNotificationSounds = false
    }

    var body: some View {
        VStack {

            Form {
                Section(header: Text("Task name")) {
                    TextField(text: $taskname, prompt: Text("My task")) {
                        Text("Username")
                    }
                }
                Section(header: Text("Attributes")) {
                    Picker("Category", selection: $categoryselection) {
                        ForEach(Array(categories.enumerated()), id: \.offset, content: { (index: Int, categoryelement: CategoryModel) in
                            Text("\(categoryelement.emoji ?? "")  \(categoryelement.name ?? "Category name not found!")").tag(categoryelement)
                        })
                    }
                            .listRowBackground(categoryselection?.colour?.toSwiftColor())
                            .foregroundColor(categoryselection?.colour?.toSwiftColor().adaptedTextColor())
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
                Button("New Task", action: {
                    Task {
                        print("hi")
                    }
                })
            }

        }.task({ () async -> Void in
                do {
                    categories = try await APIHandler.getCategories()
                    categoryselection = categories[0]
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
    TasksAddView()
}

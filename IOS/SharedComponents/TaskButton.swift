//
//  TaskButton.swift
//  IOS
//
//  Created by Curt Spark on 17/12/2024.
//

import SwiftUI
import SwiftData

struct TaskButton: View {

    @Binding var currenttask: CompletedTaskModel
    @Binding var taskelapsedseconds: TimeInterval

    var taskelement: TaskModel

    init(taskelement: TaskModel, currenttask: Binding<CompletedTaskModel>, taskelapsedseconds: Binding<TimeInterval>) {
        self.taskelement = taskelement
        self._currenttask = currenttask
        self._taskelapsedseconds = taskelapsedseconds
    }

    var body: some View {
        Button("\(taskelement.category?.emoji ?? "")  \(taskelement.name ?? "No name found!")", action: {
                                                                                                    Task {
                                                                                                        try await APIHandler.newCurrentTask(task: taskelement)

                                                                                                        // TODO: This works for some reason, but the return of newCurrentTask does not
                                                                                                        // This is so ugly, we need to look into MVVM.
                                                                                                        currenttask = try await APIHandler.getCompletedTasks()[0]

                                                                                                        taskelapsedseconds = Date.now.timeIntervalSinceReferenceDate - currenttask.started!.timeIntervalSinceReferenceDate
                                                                                                    }
        })
            .listRowBackground(taskelement.category?.colour?.toSwiftColor())
            .foregroundColor(taskelement.category?.colour?.toSwiftColor().adaptedTextColor())
    }

}

// #Preview {
//     HomeView()
// }
    

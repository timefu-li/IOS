//
//  HomeView.swift
//  IOS
//
//  Created by Curt Spark on 04/12/2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var tasks: [TaskModel]
    @State var errorstate: any Error
    @State var tabselection = 2
    @State var test: Int = 0

    @State var currenttask: CompletedTaskModel
    @State var taskelapsedseconds: TimeInterval

    let dateformatter: DateComponentsFormatter = DateComponentsFormatter()

    init() {
        tasks = []
        errorstate = APIHandler.APIHandlerError.OK

        currenttask = CompletedTaskModel(started: Date.now)
        taskelapsedseconds = 0
    }

    var body: some View {
        VStack {
            VStack {
                Text("\(currenttask.task?.category?.emoji ?? "")  \(currenttask.task?.name ?? "Unknown")")

                Button(dateformatter.string(from: taskelapsedseconds) ?? "0", action: {
                    print(dateformatter.string(from: taskelapsedseconds) ?? "0")
                })
                    .font(.system(size: 72))
            }
                .task({ () async -> Void in
                    do {
                        // TODO: This could be more efficient, would need to make an endpoint just for current task
                        // The current task that is ongoing is always assumed to be the last appended task on the DB
                        currenttask = try await APIHandler.getCompletedTasks()[0]
                        taskelapsedseconds = Date.now.timeIntervalSinceReferenceDate - currenttask.started!.timeIntervalSinceReferenceDate

                        // Timer calculates task elapsed time based on saved current task start timestamp
                        // TODO: This is flawed, it does not account for timezone savings adjustments
                       let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
                                                                                                taskelapsedseconds = Date.now.timeIntervalSinceReferenceDate - currenttask.started!.timeIntervalSinceReferenceDate
                                                                                            }
                       )
                    } catch {
                        errorstate = error.self
                        print("Encountered the following error fetching current task!")
                        print("\(error.self) : \(error.localizedDescription)")
                    }
                })

            TabView (selection: $tabselection, content: {
                TasksView()
                    .tabItem({
                        Label("Tasks", systemImage: "2.circle")
                    })
                    .tag(1)
                HomeTasksView(currenttask: self.$currenttask, taskelapsedseconds: self.$taskelapsedseconds)
                    .tabItem({
                        Label("Home", systemImage: "1.circle")
                    })
                    .tag(2)
                CategoriesView()
                    .tabItem({
                        Label("Categories", systemImage: "3.circle")
                    })
                    .tag(3)
            })

        }

    }
}

#Preview {
    HomeView()
}

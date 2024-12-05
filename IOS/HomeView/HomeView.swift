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
    @State var taskelapsed: Date

    init() {
        tasks = []
        errorstate = APIHandler.APIHandlerError.OK
        taskelapsed = Date.now
    }

    var body: some View {
        VStack {

            Button(taskelapsed.formatted(date: .omitted, time: .shortened), action: {
                print(taskelapsed.formatted(date: .omitted, time: .shortened))
            })
                .font(.system(size: 72))

            TabView {
                TasksView()
                    .tabItem({
                        Label("Tasks", systemImage: "2.circle")
                    })
                HomeRecentView()
                    .tabItem({
                        Label("Home", systemImage: "1.circle")
                    })
                CategoriesView()
                    .tabItem({
                        Label("Categories", systemImage: "3.circle")
                    })
            }

        }
    }
}

#Preview {
    HomeView()
}

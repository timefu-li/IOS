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
    @State var tabselection = 2

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

            TabView (selection: $tabselection, content: {
                TasksView()
                    .tabItem({
                        Label("Tasks", systemImage: "2.circle")
                    })
                    .tag(1)
                HomeRecentView()
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

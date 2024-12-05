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

    init() {
        tasks = []
        errorstate = APIHandler.APIHandlerError.OK
    }

    var body: some View {
        VStack {

            Button(Date.now.formatted(date: .omitted, time: .shortened), action: {
                print(Date.now.formatted(date: .omitted, time: .shortened))
            })
                .font(.system(size: 72))

            TabView {
                TasksView()
                    .tabItem({
                        Label("Tasks", systemImage: "1.circle")
                    })
                CategoriesView()
                    .tabItem({
                        Label("Categories", systemImage: "2.circle")
                    })
            }

        }
    }
}

#Preview {
    HomeView()
}

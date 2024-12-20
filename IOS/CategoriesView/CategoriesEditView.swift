//
//  CategoriesEditView.swift
//  IOS
//
//  Created by Curt Spark on 19/12/2024.
//

import SwiftUI
import SwiftData
import EmojiPicker

struct CategoriesEditView: View {
    @State var categories: [CategoryModel]
    @State var errorstate: any Error

    @State var selectemoji: Bool = false

    @State var categoryname: String
    @State var categoryemoji: Emoji?
    @State var categorycolour: Color

    var categoryelement: CategoryModel

    init(categoryelement: CategoryModel) {
        categories = []
        errorstate = APIHandler.APIHandlerError.OK

        self.categoryelement = categoryelement
        categoryname = categoryelement.name ?? "Unknown name"
        categoryemoji = Emoji(value: categoryelement.emoji ?? "", name: categoryelement.name ?? "")
        categorycolour = BackendColor.toSwiftColor(categoryelement.colour ?? BackendColor(red: 0, green: 0, blue: 0))()
    }

    var body: some View {
        VStack {

                    Form {
                        Section(header: Text("Category name")) {
                            TextField(text: $categoryname, prompt: Text("My category")) {
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
                        Button("Update Category", action: {
                            Task {
                                    //let newcategorymodel = CategoryModel(name: categoryname, emoji: categoryemoji?.value, colour: BackendColor.toBackendColor(swiftcolor: categorycolour), id: categoryelement.id)
                                    let newcategorymodel = CategoryModel(name: categoryname, id: categoryelement.id ?? UUID())

                                let result = try await APIHandler.updateCategory(category: newcategorymodel)
                            }
                        })
                        Button("Delete Category", action: {
                            Task {
                                    let result = try await APIHandler.deleteCategory(CategoryID: categoryelement.id ?? UUID())
                            }
                        })
                    }.sheet(isPresented: $selectemoji, content: {
                        NavigationView {
                            EmojiPickerView(selectedEmoji: $categoryemoji, selectedColor: .orange)
                        }
                    })
        }
    }
}

//#Preview {
//    CategoriesEditView()
//}

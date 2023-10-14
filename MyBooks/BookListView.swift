//
//  ContentView.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 11/10/2023.
//

import SwiftUI
import SwiftData

enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, author
    var id: Self {
        self
    }
}

struct BookListView: View {

    @State  private var createNewBook = false
    @State private var sortOrder = SortOrder.status
    @State private var filter = ""

    var body: some View {
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)")
                }
            }
            .buttonStyle(.bordered)
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: "Filtruj po tytule lub autorze")
            .navigationTitle("Moje książki")
            .toolbar{
                Button {
                    createNewBook = true
                } label : {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }
            .sheet(isPresented: $createNewBook) {
                NewBookView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return BookListView()
        .modelContainer(preview.container)
}

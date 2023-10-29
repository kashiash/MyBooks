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
    @Environment(\.modelContext) private var context
    @State  private var createNewBook = false
    @State private var sortOrder = SortOrder.status
    @State private var filter = ""

    @Query  var books: [Book]
    @Query  var genres: [Genre]

    var body: some View {
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)")
                }
            }
            .buttonStyle(.bordered)
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: "Filter by title or author")
                .navigationTitle("My books")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button(role: .destructive) {
                            addSampleData()
                        } label : {
                            Image(systemName: "wand.and.stars")
                                .imageScale(.large)
                        }
                        .foregroundColor(.red)

                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            createNewBook = true
                        } label : {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $createNewBook) {
                    NewBookView()
                        .presentationDetents([.medium])
                }
        }
    }
    func addSampleData(){


        Book.sampleBooks.forEach { book in
            context.insert(Book(title: book.title, author: book.author,synopsis: book.synopsis))
        }
        Genre.sampleGenres.forEach { genre in
            context.insert(genre)
        }

    }
}

#Preview("English") {
    let preview = Preview(Book.self)

    let books = Book.sampleBooks
    let genres = Genre.sampleGenres

    preview.addExamples(books)
    preview.addExamples(genres)
    return BookListView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "GB"))
}
#Preview("Polish") {
    let preview = Preview(Book.self)

    let books = Book.sampleBooks
    let genres = Genre.sampleGenres

    preview.addExamples(books)
    preview.addExamples(genres)
    return BookListView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "PL"))
}
#Preview("German") {
    let preview = Preview(Book.self)

    let books = Book.sampleBooks
    let genres = Genre.sampleGenres

    preview.addExamples(books)
    preview.addExamples(genres)
    return BookListView()
        .modelContainer(preview.container)
        .environment(\.locale, Locale(identifier: "DE"))
}

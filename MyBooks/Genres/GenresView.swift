//
//  GenresView.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 27/10/2023.
//

import SwiftUI
import SwiftData

struct GenresView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var book: Book
    @Query(sort:\Genre.name) var genres: [Genre]
   @State private var newGenre = false
    var body: some View {
        NavigationStack {
            if genres.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark.fill")
                        .font(.largeTitle)
                } description: {
                    Text("You need to create some genres first.")
                } actions: {
                    Button("Create Genre") {
                        newGenre.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    ForEach(genres) { genre in
                        HStack {
                            if let bookGenres = book.genres {
                                if bookGenres.isEmpty {
                                    Button {
                                        addRemove(genre)
                                    } label: {
                                        Image(systemName: "circle")
                                    }
                                    .foregroundColor(genre.hexColor)
                                } else {
                                    Button {
                                        addRemove(genre)
                                    } label: {
                                        Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                                    }
                                    .foregroundStyle(genre.hexColor)
                                }
                            }
                            Text(genre.name)
                        }
                    }
                    LabeledContent {
                        Button {
                            newGenre.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                        .buttonStyle(.borderedProminent)
                    } label: {
                        Text("Create new Genre")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
                .listStyle(.plain)
            }

        }
        .navigationTitle(book.title)
        .sheet(isPresented: $newGenre) {
            NewGenreView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }

    }

    func addRemove(_ genre: Genre) {
        if let bookGenres = book.genres {
            if bookGenres.isEmpty {
                book.genres?.append(genre)
            } else {
                if bookGenres.contains(genre),
                   let index = bookGenres.firstIndex(where: {$0.id == genre.id}) {
                    book.genres?.remove(at: index)
                } else {
                    book.genres?.append(genre)
                }
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    let genres = Genre.sampleGenres

    preview.addExamples(genres)
    preview.addExamples(books)
    books[2].genres?.append(genres[1])
    return    NavigationStack {
        GenresView(book: books[2])
            .modelContainer(preview.container)
    }
}

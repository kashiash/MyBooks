//
//  Book.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 11/10/2023.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    @Attribute(originalName: "summary")
    var synopsis: String
    var rating: Int?
    var status: Status.RawValue
    var recomendedBy: String = ""
    @Relationship(deleteRule: .cascade)
    var quotes: [Quote]?
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?

    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,

        synopsis: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recomendedBy: String = ""
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.synopsis = synopsis
        self.rating = rating
        self.status = status.rawValue
        self.recomendedBy = recomendedBy
    }

    var icon: Image {
        switch Status(rawValue: status)! {

        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
}
enum Status: Int, Codable, Identifiable, CaseIterable {
  case onShelf,inProgress, completed
    var id: Self {
        self
    }
    var description: String {
        switch self {

        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
}

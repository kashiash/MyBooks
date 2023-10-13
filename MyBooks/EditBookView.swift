//
//  EditBookView.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 12/10/2023.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    var book: Book
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast

    @State private var firstView = true;

    var body: some View {
        HStack{
            Text("Status")
            Picker("Status",selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.description).tag(status)

                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("",selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Data dodania")
                }

                if status == .inProgress || status == .completed {
                    DatePicker("Data rozpoczęcia",selection: $dateStarted,in: dateAdded..., displayedComponents: .date)
                }
                if status == .completed {
                    DatePicker("Data przeczytania",selection: $dateCompleted,in: dateStarted..., displayedComponents: .date)
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if firstView {

                 if newValue == .onShelf {
                    dateStarted = Date.distantPast
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue  == .completed {
                    dateCompleted = Date.distantPast
                } else if newValue == .inProgress && oldValue  == .onShelf {
                    dateStarted = Date.now
                } else if newValue == .completed  && oldValue  == .onShelf {
                    dateCompleted = Date.now
                    dateStarted = dateAdded
                } else  {
                    dateCompleted = Date.now
                }
                    firstView = false
            }
        }
        Divider()
        LabeledContent{
            RatingsView(maxRating: 5, currentRating: $rating, width: 30)
        }label: {
            Text("Ocena")
        }
        LabeledContent {
            TextField("", text:$title)
        } label: {
            Text("Tytuł")
        }
        LabeledContent {
            TextField("", text: $author)
        } label: {
            Text("Autor")
        }
        Divider()
        Text("Opis").foregroundStyle(.secondary)
        TextEditor(text: $summary)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
    }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Zapisz") {
                    book.status     = status
                    book.rating     = rating
                    book.title      = title
                    book.author     = author
                    book.summary    = summary
                    book.dateAdded  = dateAdded
                    book.dateCompleted = dateCompleted
                    book.dateStarted = dateStarted

                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status  =   book.status
            rating  =   book.rating
            title   =   book.title
            author  =   book.author
            summary =   book.summary
            dateAdded       = book.dateAdded
            dateCompleted   = book.dateCompleted
            dateStarted     = book.dateStarted
        }
}
var changed: Bool {
    status != book.status
    || rating != book.rating
    || title != book.title
    || author != book.author
    || summary != book.summary
    || dateAdded != book.dateAdded
    || dateCompleted != book.dateCompleted
    || dateStarted != book.dateStarted
}

}

//#Preview {
//    NavigationStack {
//        EditBookView()
//    }
//}

//
//  NewBookView.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 11/10/2023.
//

import SwiftUI

struct NewBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    var body: some View {
        NavigationStack{
            Form{
                TextField("Tytuł ksiązki",text: $title)
                TextField("Autor",text: $author)
                HStack {
                    Button("Anuluj") {

                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .buttonStyle(.bordered)

                    Button("Zapisz") {
                        let newBook = Book(title: title, author: author)
                        context.insert(newBook)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .disabled(title.isEmpty || author.isEmpty)
                }

                .navigationTitle("Nowa książka")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Anuluj") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewBookView()
}

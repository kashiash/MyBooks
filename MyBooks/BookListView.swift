//
//  ContentView.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 11/10/2023.
//

import SwiftUI

struct BookListView: View {
    @State  private var createNewBook = false
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
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
    BookListView()
}

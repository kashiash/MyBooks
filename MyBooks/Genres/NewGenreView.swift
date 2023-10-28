//
//  NewGenreView.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 28/10/2023.
//

import SwiftUI
import SwiftData

struct NewGenreView: View {
    @State private var name = ""
    @State private var color = Color.red
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $name)
                ColorPicker("Set the genre color", selection: $color, supportsOpacity: false)
            }
        }
    }
}

#Preview {
    NewGenreView()
}

//
//  Quote.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 15/10/2023.
//

import Foundation
import SwiftData

@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?

    init(text: String, page: String? = nil) {

        self.text = text
        self.page = page
    }
    var book: Book?
}

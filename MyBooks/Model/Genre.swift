//
//  Genre.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 26/10/2023.
//

import Foundation
import SwiftData

@Model
class Genre {
    var name: String
    var color: String

    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}

//
//  UIColor+xtension.swift
//  MyBooks
//
//  Created by Jacek Kosinski U on 27/10/2023.
//

import SwiftUI
extension Color {

    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

}

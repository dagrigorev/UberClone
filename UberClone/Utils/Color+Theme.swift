//
//  Color+Theme.swift
//  UberClone
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

/// System-backed palette so every screen adapts to light and dark mode for free.
struct ColorTheme {
    let backgroundColor = Color(.systemBackground)
    let secondaryBackgroundColor = Color(.secondarySystemBackground)
    let primaryTextColor = Color(.label)
    let secondaryTextColor = Color(.secondaryLabel)
    let separatorColor = Color(.separator)
    let accent = Color(.label)
}

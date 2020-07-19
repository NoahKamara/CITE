//
//  LayoutType.swift
//  LIT
//
//  Created by Noah Kamara on 18.07.20.
//

import Foundation

enum CollectionLayout {
    case grid
    case list
    
    /// Toggles the CollectionLayout
    public mutating func toggle() {
        switch self {
            case .grid: self = .list
            case .list: self = .grid
        }
    }
}

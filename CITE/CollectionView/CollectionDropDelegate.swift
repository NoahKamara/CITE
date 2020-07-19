//
//  CollectionDropDelegate.swift
//  CITE
//
//  Created by Noah Kamara on 19.07.20.
//

import Foundation
import SwiftUI

class CollectionDropDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        print("PERFORM DROP \(info)")
        return true
    }
    
    
}

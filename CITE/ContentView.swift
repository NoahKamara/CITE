//
//  ContentView.swift
//  CITE
//
//  Created by Noah Kamara on 18.07.20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        NavigationView {
            Sidebar().environment(\.managedObjectContext, managedObjectContext)
//            PrimaryView().environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  CITE
//
//  Created by Noah Kamara on 18.07.20.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let url = URL(string: "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf")!
    var body: some View {
        NavigationView {
            Sidebar().environment(\.managedObjectContext, managedObjectContext)
            CollectionView(.all).environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ReferenceDetailView.swift
//  CITE
//
//  Created by Noah Kamara on 23.08.20.
//

import SwiftUI
import PDFKit

struct ReferenceDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var ref: CITE_Reference?
    @State var pdfView: PDFView = PDFView()
    
    @State var showMetaData: Bool = true
    var body: some View {
        NavigationView() {
            self.sidebar
            Group() {
                if self.ref?.document != nil {
                    PDFKitRepresentedView(data: self.ref!.document!, pdfView: self.$pdfView)
                } else {
                    Text("No PDF found")
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("dismissDetailViewAction", systemImage: "xmark.circle")
                            .labelStyle(IconOnlyLabelStyle())
                    }
                }
            }
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    var sidebar: some View {
        List() {
            Section(header: Text("Hello")) {
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("Hello")
            }
            
            Section(header: Text("Hello 2")) {
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("Hello")
                Text("Hello")
            }
        }.listStyle(SidebarListStyle())
        .navigationBarTitle("Meta Data")
    }
}

struct ReferenceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceDetailView(ref: .constant(CITE_Reference()))
    }
}

//
//  CollectionView.swift
//  CITE
//
//  Created by Noah Kamara on 18.07.20.
//

import SwiftUI

import SwiftUI
import CoreData

struct CollectionView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    private let collectionType: CollectionType
    private let collection: CITE_Collection?
    
    init(_ collectionType: CollectionType, _ collection: CITE_Collection? = nil) {
        self.collection = collection
        self.collectionType = collectionType
        switch collectionType {
            case .all: self.references = FetchRequest(fetchRequest: CITE_Reference.getAll() )
            case .tag:  self.references = FetchRequest(fetchRequest: CITE_Reference.get(for: self.collection!) )
            case .folder:  self.references = FetchRequest(fetchRequest: CITE_Reference.get(for: self.collection!) )
            default: self.references = FetchRequest(fetchRequest: CITE_Reference.getAll() )
        }
    }

    
    /// References of for collection
    var references: FetchRequest<CITE_Reference>
    
    @State var layout: CollectionLayout = .grid
    @State var searchString: String = ""
    @State var collectionItems = []
    
    
    
    private let gridLayout = [ GridItem(.adaptive(minimum: 140)) ]
    
    var body: some View {
        Group() {
            if self.layout == .grid {
                self.gridView
            } else {
                self.listView
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack {
                    Button(action: {
                        self.addReference()
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding()
                    }.hoverEffect(.highlight)
                    
                    Button(action: {
                        self.layout.toggle()
                    }) {
                        Image(systemName: self.layout == .grid ? "square.grid.2x2" : "list.bullet")
                            .imageScale(.large)
                            .padding()
                    }.hoverEffect(.highlight)
                    
                    Rectangle()
                        .frame(width: 100)
                }
            }
            //            ToolbarItem(placement: .principal) {
            //                SearchBar(text: self.$searchString)
            //            }
        }
        
        .navigationBarTitle(
            (self.collection?.type == "folder" || self.collection?.type == "tag")
            ? LocalizedStringKey(self.collection?.label ?? "defaultCollectionLabel") : self.collectionType == .all
            ? LocalizedStringKey("documentsLabel") : self.collectionType == .recent
            ? LocalizedStringKey("recentLabel") : LocalizedStringKey("unknown Collection Type")
        )
    }
    
    var gridView: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, alignment: .center, spacing: 20) {
                ForEach(self.references.wrappedValue, id:\.self) { item in
                    NavigationLink(destination:
                        item.document != nil
                        ? AnyView( PDFViewContainer(data: item.document!) )
                        : AnyView( Text("No Document") )
                    ) {
                        ItemView(ref: item, layout: self.$layout)
                            .padding(.horizontal)
                            .environment(\.managedObjectContext, managedObjectContext)
                            .onDrag { NSItemProvider(object: item) }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var listView: some View {
        List(self.references.wrappedValue, id:\.self) { item in
            NavigationLink(destination:
                item.document != nil
                ? AnyView( PDFViewContainer(data: item.document!) )
                : AnyView( Text("No Document") )
            ) {
                ItemView(ref: item, layout: self.$layout)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .onDrag { NSItemProvider(object: item) }
            }
        }
    }
    
    func addReference() {
        let item = CITE_Reference(context: self.managedObjectContext)
        item.id = UUID()
        item.title = item.id?.uuidString ?? "UID"
        switch collection?.type {
            case "folder": item.folder = collection!
            case "tag": item.addToTags(collection!)
            default: break
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(.all)
    }
}

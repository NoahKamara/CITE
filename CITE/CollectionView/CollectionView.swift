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
    
    @State var test: Bool? = nil
    
    @State var showDocumentView: Bool = false
    @State var showDocumentDetail: Bool = false
    @State var selectedReference: CITE_Reference? = nil
    @State var selectedId: UUID? = nil
    
    @State var layout: CollectionLayout = .grid
    @State var searchString: String = ""
    @State var collectionItems = []
    
    
    private let gridLayout = [ GridItem(.adaptive(minimum: 140)) ]
    
    func showDocumentView(_ doc: CITE_Reference) {
        DispatchQueue.main.async {
            self.selectedReference = doc
            self.showDocumentView.toggle()
        }
    }
    
    func showDocumentDetail(_ doc: CITE_Reference) {
        DispatchQueue.main.async {
            self.selectedReference = doc
            self.showDocumentDetail.toggle()
        }
    }
    
    func makeIsPresented(item: CITE_Reference) -> Binding<Bool> {
        return .init(get: {
            return self.selectedId == item.id
        }, set: { _ in
            self.selectedId = nil
        })
    }
    
    var body: some View {
        Group() {
            if self.layout == .grid {
                self.gridView
            } else {
                self.listView
            }
        }
        .fullScreenCover(isPresented: self.$showDocumentView) {
            ReferenceDetailView(ref: self.$selectedReference)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Label("importAction", systemImage: "plus")
            }
            ToolbarItem(placement: .automatic) {
                Menu {
                    Section() {
                        Button(action: {
                            self.addReference()
                        }) {
                            Label("Add Reference", systemImage: "plus")
                        }.hoverEffect(.highlight)
                    }
                    
                    Section() {
                        Button(action: {
                            self.layout.toggle()
                        }) {
                            Label("toggleLayoutAction", systemImage: self.layout == .grid ? "square.grid.2x2" : "list.bullet")
                        }.hoverEffect(.highlight)
                        Button(action: {
                            self.layout.toggle()
                        }) {
                            Label("symbolsLayoutAction", systemImage: "square.grid.2x2")
                        }.hoverEffect(.highlight)
                        
                        Button(action: {
                            self.layout.toggle()
                        }) {
                            Label("listLayoutAction", systemImage: "list.bullet")
                        }.hoverEffect(.highlight)
                    }
                    
                    Section() {
                        Button(action: {
                            self.layout.toggle()
                        }) {
                            Label("symbolsLayoutAction", systemImage: "list.bullet")
                        }.hoverEffect(.highlight)
                        
                        Button(action: {
                            self.layout.toggle()
                        }) {
                            Label("listLayoutAction", systemImage: "list.bullet")
                        }.hoverEffect(.highlight)
                    }
                    
                    Section() {
                        Button(action: {
                        }) {
                            Text("titleSortAction")
                        }.hoverEffect(.highlight)
                        
                        Button(action: {
                        }) {
                            Text("pubdateSortAction")
                        }.hoverEffect(.highlight)
                        
                        Button(action: {
                        }) {
                            Text("authorSortAction")
                        }.hoverEffect(.highlight)
                        
                        Button(action: {
                        }) {
                            Text("tagSortAction")
                        }.hoverEffect(.highlight)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
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
                    ItemView(ref: item, layout: self.$layout)
                        .padding(.horizontal)
                        .environment(\.managedObjectContext, managedObjectContext)
                        .onDrag { NSItemProvider(object: item) }
                        .onTapGesture {
                            self.showDocumentView(item)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var listView: some View {
        List(self.references.wrappedValue, id:\.self) { item in
            ItemView(ref: item, layout: self.$layout)
                .environment(\.managedObjectContext, managedObjectContext)
                .onDrag { NSItemProvider(object: item) }
                .onTapGesture {
                    self.showDocumentView(item)
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

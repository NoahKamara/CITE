//
//  CollectionViewItem.swift
//  LIT
//
//  Created by Noah Kamara on 18.07.20.
//

import SwiftUI

extension CollectionView{
    
    struct ItemView: View {
        /// Managed Object Context
        @Environment(\.managedObjectContext) var managedObjectContext
        
        /// The Reference for the View
        var ref: CITE_Reference
        
        /// The Parents Views Layout
        @Binding var layout: CollectionLayout
        
        
        /// Collections of type Folder
        @FetchRequest(fetchRequest: CITE_Collection.getFolders()) var folders: FetchedResults<CITE_Collection>
        
        /// Collections of type tag
        @FetchRequest(fetchRequest: CITE_Collection.getTags()) var tags: FetchedResults<CITE_Collection>
        
        /// Determines if the popover is shown
        @State var showPopover: Bool = false
        /// Determines the type of the popover
        @State var popoverViewType: MenuSelection = .info
        
        enum MenuSelection {
            case info
            case folder
            case tags
        }
                
        var body: some View {
            if self.layout == .grid {
                self.gridView
            } else {
                self.listView
            }
        }
        
        var preview: some View {
            Rectangle()
                .foregroundColor(.secondary)
                .opacity(0.7)
                .aspectRatio(1/sqrt(2), contentMode: .fit)
                .clipped()
                .contextMenu {
                    Button(action: {
                        self.popoverViewType = .info
                        self.showPopover.toggle()
                    }) { Label("infosAction", systemImage: "info.circle") }
                    
                    Button(action: {
                        self.popoverViewType = .folder
                        self.showPopover.toggle()
                    }) { Label("folderAction", systemImage: "folder") }
                    
                    Button(action: {
                        self.popoverViewType = .tags
                        self.showPopover.toggle()
                    }) { Label("tagsAction", systemImage: "tag") }
                    
                    Button(action: {
                        print("shareAction")
                    }) { Label("shareAction", systemImage: "square.and.arrow.up") }
                    
                    Button(action: {
                        print("openInNewWindowAction")
                    }) { Label("openInNewWindowAction", systemImage: "square.grid.2x2") }
                    
                    Button(action: {
                        print("deleteAction")
                    }) { Label("deleteAction", systemImage: "trash") }
                    .accentColor(.red)
                }
                .popover(isPresented: self.$showPopover) {
                    if self.popoverViewType == .info {
                        AnyView( self.infoPane.frame(minWidth: 300, minHeight: 500) )
                    } else if self.popoverViewType == .folder {
                        AnyView( self.folderMenu )
                    } else if self.popoverViewType == .tags {
                        AnyView( self.tagsMenu.frame(minWidth: 300, minHeight: 500) )
                    } else {
                        AnyView( self.tagsMenu.frame(minWidth: 300, minHeight: 500) )
                    }
                }
        }
        
        var gridView: some View {
            VStack(spacing: 3) {
                self.preview
                    .cornerRadius(15)
                    .padding(.bottom, 5)
                    
                Text(self.ref.title ?? "No Title")
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Author 01, Author 02, Author 03")
                }
                .foregroundColor(.secondary)
                .font(.callout)
                .lineLimit(1)
                
                
                HStack {
                    Image(systemName: "folder.circle.fill")
                    Text(self.ref.folder?.label ?? "Error")
                }
                .foregroundColor(self.ref.folder != nil ? .secondary : .clear)
                .font(.callout)
                .lineLimit(1)
            }
        }
        
        var listView: some View {
            HStack {
                self.preview
                    .cornerRadius(5)
                    .frame(height: 50)
                VStack(alignment: .leading) {
                    Text(self.ref.title ?? "No Title")
                    
                    Text("Author 01, Author 02, Author 03")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        ForEach((self.ref.tags?.allObjects ?? []) as? [CITE_Collection] ?? [], id:\.self) { tag in
                            Image(systemName: "circle.fill" )
                                .foregroundColor(Color(tag.color ?? UIColor(Color.primary)))
                        }
                    }.frame(height: 20)
                    
                    
                    if self.ref.folder != nil {
                        HStack {
                            Image(systemName: "folder.circle.fill")
                            Text(self.ref.folder?.label ?? "Error")
                        }
                    } else {
                        Text("  ")
                    }
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }.lineLimit(1)
        }
                
        //MARK: Info Pane
        var infoPane: some View {
            VStack {
                List() {
                    Section() {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Spacer()
                                Rectangle()
                                    .aspectRatio(1/sqrt(2), contentMode: .fit)
                                    .clipped()
                                    .cornerRadius(15)
                                    .padding(.bottom, 5)
                                    .frame(height: 150)
                                Spacer()
                            }
                            Text(self.ref.title ?? "defaultReferenceTitle")
                                .font(.title)
                                .lineLimit(2)
                            if self.ref.folder != nil {
                                HStack {
                                    Image(systemName: "folder.circle")
                                    Text(self.ref.folder?.label ?? "noFolderDescription")
                                }
                            }
                        }
                    }
                    Section(header: Text("informationLabel")) {
                        HStack {
                            Group() {
                                Image(systemName: "doc.circle")
                                Text("documentTypeLabel")
                            }.foregroundColor(.secondary)
                            
                            Spacer()
                            Text("Journal")
                        }.font(.footnote).lineLimit(1)
                        
                        HStack {
                            Group() {
                                Image(systemName: "number.circle")
                                Text("doiLabel")
                            }.foregroundColor(.secondary)
                            Spacer()
                            Text("10.1109 5.771073")
                        }.font(.footnote).lineLimit(1)
                        
                        HStack {
                            Group() {
                                Image(systemName: "calendar.circle")
                                Text("publishedLabel")
                            }.foregroundColor(.secondary)
                            Spacer()
                            Text("2019")
                        }.font(.footnote).lineLimit(1)
                    }
                    
                    
                    Section(header: Text("tagsLabel")) {
                        HStack {
                            ForEach((self.ref.tags?.allObjects ?? []) as? [CITE_Collection] ?? [], id:\.self) { tag in
                                Image(systemName: "circle.fill")
                                    .foregroundColor(Color(tag.color ?? UIColor(.primary)))
                            }
                        }
                    }
                }
            }
            
        }
        
        //MARK: Folder Menu
        var folderMenu: some View {
            List(self.folders, id:\.self) { folder in
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(self.ref.folder == folder ? .primary : .clear)
                    Text(folder.label ?? "NO LABEL").lineLimit(1)
                }.onTapGesture {
                    self.ref.folder = folder
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
        //MARK: Tags Menu
        var tagsMenu: some View {
            List(self.tags, id:\.self) { tag in
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(self.ref.hasTag(tag) ? .primary : .clear)
                    Image(systemName: "tag.fill").foregroundColor(Color(tag.color ?? UIColor(Color.primary)))
                    Text(tag.label ?? "NO LABEL").lineLimit(1)
                }.onTapGesture {
                    self.ref.addToTags(tag)
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
        
    struct ItemView_Previews: PreviewProvider {
        static var previews: some View {
            ItemView(ref: CITE_Reference(), layout: .constant(.grid))
            ItemView(ref: CITE_Reference(), layout: .constant(.list))
        }
    }
}

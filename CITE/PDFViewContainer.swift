//
//  PDFView.swift
//  CITE
//
//  Created by Noah Kamara on 21.07.20.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFViewContainer: View {
    @State var pdfView: PDFView = PDFView()
    
    var data: Data
    
    var body: some View {
        HStack(spacing: 0) {
            PDFKitRepresentedView(data: self.data, pdfView: self.$pdfView)
            PDFKitThumbnailRepresentedView(pdfView: self.$pdfView).frame(width: 120)
        }
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                HStack {
//                    Button(action: {
//                    }) {
//                        Image(systemName: "circle.fill")
//                            .imageScale(.large)
//                            .padding()
//                    }.hoverEffect(.highlight)
//                }
//            }
//        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let data: Data
    @Binding var pdfView: PDFView
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: self.data)!
        
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(true)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.autoScales = true
        
        DispatchQueue.main.async {
            self.pdfView = pdfView
        }
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        print("UPDATE PDFVIEW")
        
        DispatchQueue.main.async {
            self.pdfView = pdfView
        }
    }
}


struct PDFKitThumbnailRepresentedView: UIViewRepresentable {
    @Binding var pdfView: PDFView
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitThumbnailRepresentedView>) -> PDFThumbnailView {
        let thumbView = PDFThumbnailView()
        
        thumbView.pdfView = self.pdfView
        thumbView.thumbnailSize = CGSize(width: 120, height: 120/sqrt(2))
        thumbView.layoutMode = .vertical
        thumbView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return thumbView
    }
    
    func updateUIView(_ thumbView: PDFThumbnailView, context: UIViewRepresentableContext<PDFKitThumbnailRepresentedView>) {
        thumbView.pdfView = self.pdfView
    }
}

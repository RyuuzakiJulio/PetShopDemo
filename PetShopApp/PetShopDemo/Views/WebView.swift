//
//  WebView.swift
//  PetShopDemo
//
//  Created by Ryuuzaki on 2020/07/06.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
   let request: URLRequest

   func makeUIView(context: Context) -> WKWebView {
      return WKWebView()
   }

   func updateUIView(_ uiView: WKWebView, context: Context) {
      uiView.load(request)
   }
}

struct WebView_Previews: PreviewProvider {
   static var previews: some View {
      WebView(request: URLRequest(url: URL(string: "https://en.wikipedia.org/wiki/Cat")!))
   }
}

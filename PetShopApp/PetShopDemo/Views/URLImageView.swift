//
//  URLImageView.swift
//  PetShopDemo
//
//  Created by Ryuuzaki on 2020/07/06.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
   let objectWillChange = ObservableObjectPublisher()

   var image: Image? {
      willSet {
         objectWillChange.send()
      }
   }

   func load(url: String) {
      guard let url = URL(string: url) else { return }
      URLSession.shared.dataTask(with: url) { data, response, error in
         guard let data = data, let image = UIImage(data: data) else { return }
         DispatchQueue.main.async {
            self.image = Image(uiImage: image)
         }
      }.resume()
   }
}

struct URLImageView<Content>: View where Content: View {
   @StateObject var imageLoader = ImageLoader()

   private let url: String
   private let content: (_ image: Image) -> Content

   init(url: String, content: @escaping (_ image: Image) -> Content) {
      self.url = url
      self.content = content
   }

   var body: some View {
      ZStack {
         if imageLoader.image != nil {
            content(imageLoader.image!)
         } else {
            content(Image(uiImage: UIImage(systemName: "photo")!))
         }
      }.onAppear {
         self.imageLoader.load(url: self.url)
      }
   }
}

struct URLImageView_Previews: PreviewProvider {
   static var previews: some View {
      URLImageView(url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Cat_poster_1.jpg/1200px-Cat_poster_1.jpg") { (Image) in
         Image.renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(width: 100.0, height: 100.0)
      }
   }
}

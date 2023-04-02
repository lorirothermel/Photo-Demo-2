//
//  ContentView.swift
//  Photo Demo 2
//
//  Created by Lori Rothermel on 4/1/23.
//

import SwiftUI

struct CustomImageView: View {
    @State var image: UIImage = UIImage()
    @ObservedObject var imageLoader: ImageLoaderService
    
    var urlString: String
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:100, height:100)
            .onReceive(imageLoader.$image) { image in
                self.image = image
            }.onAppear {
                imageLoader.loadImage(for: urlString)
            }
    }
}

 class ImageLoaderService: ObservableObject {
    @Published var image: UIImage = UIImage()
     
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }  // DispatchQueue
        }  // let task
        task.resume()
    }  // func loadImage
}


struct ContentView: View {
    @ObservedObject var imageLoader = ImageLoaderService()
    
    
    var body: some View {
        
        VStack {
            CustomImageView(imageLoader: imageLoader, urlString: "https://stackoverflow.design/assets/img/logos/so/logo-stackoverflow.png")
                .contextMenu {
                    Button(action: {
                        UIImageWriteToSavedPhotosAlbum(imageLoader.image, nil, nil, nil)
                    }) {
                        HStack {
                            Text("Save image")
                            Image(systemName: "square.and.arrow.down.fill")
                        }  // HStack
                    }  // Button
                }  // .contextMenu
        }  // VStack
    }  // some View
}  // ContentView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  PhotosViewInfiniteScroll.swift
//  FinalProj (iOS)
//
//  Created by Joonho Hwangbo on 2020/11/22.
//

import Foundation
import SwiftUI
import Combine
import SDWebImageSwiftUI


struct PhotoView: View {
    var photo: Photo
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: photo.urls["thumb"]!))
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    //do action
                }
        }
    }
}


struct PhotosViewInfiniteScroll: View {
    @ObservedObject var viewModel : dataLoader
    
    var body: some View {
        List(viewModel.photos) { photo in
            PhotoView(photo: photo)
                .onAppear {
                    self.elementOnAppear(photo)
                }
        }
    }
    
    private func elementOnAppear(_ photo:Photo) {
        if self.viewModel.isLastPhoto(photo) {
            self.viewModel.loadData { success in
            }
        }
    }
}

//
//  PhotoListView.swift
//  qwerty
//
//  Created by Joonho Hwangbo on 2020/11/23.
//

import Foundation


import Foundation
import SwiftUI
import Combine
import SDWebImageSwiftUI

public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

struct RawPhotoView: View {
    var photo: Photo
    var body: some View {
        HStack{
            WebImage(url: URL(string: photo.urls.thumb))
                .renderingMode(.original)
                .resizable()
                .frame(width: screenWidth/3-15, height: 150)
                
        }
    }
}

//struct ImageView: View {
//    var photo: PhotoView
//    var show: Bool = true
//    @State var selection: String? = nil
//    var body: some View {
//        VStack {
//            if(self.show){
//                NavigationLink (destination: ImageDetails(selectedPhoto: photo), tag: self.photo.id, selection: self.$selection) {
//                    EmptyView()
//                }.frame(width: 0, height: 0)
//                    .hidden()
//                Button(action: {
//                    self.selection = self.photo.id
//                }) {
//                    ThumbImage(imageUrl: photo.thumbnailUrl)
//                }.buttonStyle(PlainButtonStyle())
//            } else {
//                EmptyView()
//            }
//        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 110, alignment: .center).padding(8)
//    }
//}

struct PhotoView: View {
    var photo: Photo
    var show: Bool = true
    @State var selection: String? = nil
    
    var body: some View {
        VStack {
            if(self.show) {
                RawPhotoView(photo: photo)
            } else {
                EmptyView()
            }
        }
    }
}


struct PhotoListView: View {
    @EnvironmentObject var unsplashapi: UnSplashApi
    
    var body: some View {
        VStack {
            List(unsplashapi.photoGrid) { photoRow in
                HStack(alignment: .top) {
                    if photoRow.row.count > 2 {
                        PhotoView(photo: photoRow.row[0])
                        PhotoView(photo: photoRow.row[1])
                        PhotoView(photo: photoRow.row[2])
                    }
                }.onAppear(perform: {self.unsplashapi.lastElementCheck(id:photoRow.id)}).listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))//.frame(minHeight: 150)
                
            }//.listStyle(SidebarListStyle())
        }
    }
    
    private func elementOnAppear(_ photo:Photo) {
      if self.unsplashapi.isLastPhoto(photo) {
          self.unsplashapi.loadMore()
      }
  }
}

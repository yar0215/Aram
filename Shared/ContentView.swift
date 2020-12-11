//
//  ContentView.swift
//  Shared
//
//  Created by Joonho Hwangbo on 2020/11/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PhotosViewInfiniteScroll(viewModel: dataLoader())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

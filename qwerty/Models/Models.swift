//
//  Models.swift
//  qwerty
//
//  Created by Joonho Hwangbo on 2020/11/23.
//

import Foundation


/// Image data / information retrieved from the unsplash api.
struct Photo: Codable, Identifiable, Hashable {

    let id: String
//    let createdAt: String
//    let likes: Int
//    let width: Int
//    let height: Int
//    let color: String // Hex color value
//    let description: String?
//    let altDescription: String?
    let urls: Sizes

    struct Sizes: Codable, Hashable {
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}

struct Response: Codable, Equatable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}

struct PhotoRow: Codable, Identifiable, Hashable {
    var id: String
    var row: [Photo]
}


struct PageInfo {
    var curPage: Int = 1
    var photoCnt: Int = 1
    var pageCnt: Int = 1
}

//struct PhotoGrid: Codable {
//    var total: Int
//    var total_pages: Int
//    var grid: [PhotoRow]
//}

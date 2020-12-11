//
//  Photo.swift
//  FinalProj
//
//  Created by Joonho Hwangbo on 2020/11/21.
//

import Foundation

struct Photo : Identifiable,Decodable,Hashable{
    
    var id : String
    var urls : [String : String]
}


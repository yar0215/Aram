//
//  dataLoader.swift
//  FinalProj
//
//  Created by Joonho Hwangbo on 2020/11/21.
//

import Foundation


class dataLoader : ObservableObject{
    
    // Going to Create Collection View.....
    // Thats Why 2d Array...
    @Published var photos : [Photo] = []

    init() {
        self.loadData {success in}
    }
    
    func loadData(completion: @escaping(Bool) -> Void){
        let key = "Q__UW_zYMxtRtRBw-dvyYv02zcAoJehBPd12hLgAI44"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            guard let data = data else {
                print("URLSession dataTask error:", error ?? "nil")
                return
            }
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data)
                print(json)
                for photo in json {
                    DispatchQueue.main.async {
                        self.photos.append(photo)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func isLastPhoto(_ photo:Photo) -> Bool {
        if let last = self.photos.last {
            return last == photo
        }
        return false
    }
}

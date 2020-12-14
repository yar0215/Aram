//
//  UnSplashApi.swift
//  qwerty
//
//  Created by Joonho Hwangbo on 2020/11/23.
//

import Foundation
import Combine


class UnSplashApi : ObservableObject{
    
    @Published var photos : [Photo] = []
    @Published var photoGrid: [PhotoRow] = []
    @Published var searchText: String = "Cat"
    @Published var pageInfo: PageInfo = PageInfo()
    var searchViewState: SearchViewState
    private var disposables = Set<AnyCancellable>()

    
    init(searchViewState: SearchViewState){
        self.searchViewState = searchViewState
        self.searchViewState.$dst
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main).removeDuplicates()
            .sink { searchText in
                self.loadData(searchText: searchText)
        }.store(in: &disposables)
    }
    
    func getUrl(searchText: String, page: Int = 1) -> String {
        var _searchText = searchText
        if( searchText.isEmpty) {
            return "";
        }
        var text = _searchText.components(separatedBy: ",")
        var _cat = "";
        if(text.count > 1){
            _searchText = text[text.count-1].trimmingCharacters(in: .whitespacesAndNewlines);
            text.removeLast()
            _cat = text.joined(separator: ",")
        } else {
            _searchText = text[0].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let safeText = _searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

        let key = "NdUC2vca-l_jsifGjq1Le64pvHSqjpOVaxGMRODagLA"
        let safeUrl = "https://api.unsplash.com/search/photos/?page=\(page)&query=\(safeText)&client_id=\(key)"
        return safeUrl
    }
    
    func loadData(searchText: String){
        
        self.searchText = searchText
        let searchUrl = getUrl(searchText: searchText)
        
        if(searchUrl.isEmpty) {
            return
        }
        guard let url = URL(string: searchUrl) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url:url)
        URLSession.shared.dataTask(with: request){data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                    DispatchQueue.main.async {
                        self.photos = decodedResponse.results
                        self.buildPhotoRows()
                        self.pageInfo.photoCnt = decodedResponse.total
                        self.pageInfo.pageCnt = decodedResponse.total_pages
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func loadMore(){
        let searchUrl = getUrl(searchText: self.searchText, page: self.pageInfo.curPage+1)
        guard let url = URL(string: searchUrl) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url:url)
        URLSession.shared.dataTask(with: request){data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                    DispatchQueue.main.async {
                        self.photos.append(contentsOf: decodedResponse.results)
                        self.buildPhotoRows()
                        //is this ok?????
                        //to do : init curPage to 0 whenever the search keyword changes
                        self.pageInfo.curPage += 1
                    }
                    return
                }
            }
            print("Load MoreFetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func isLastPhoto(_ photo:Photo) -> Bool {
        if let last = self.photos.last {
            return last == photo
        }
        return false
    }
    
    func isLastPhotoRow(_ photoRow: PhotoRow) -> Bool {
        if let last = self.photoGrid.last {
           return last == photoRow
        }
        return false
    }
    
    func lastElementCheck(id: String){
        if(self.photoGrid.last?.id == id) {
            loadMore()
        }
    }
    
    func buildPhotoRows() {
        self.photoGrid = []
        var i = 0;
        for photo in self.photos {
            if(i%3 == 0) {
                self.photoGrid.append(PhotoRow(id: photo.id, row: [photo]))
            } else {
                self.photoGrid[self.photoGrid.count-1].row.append(photo)
            }
            i += 1
        }
    }
}


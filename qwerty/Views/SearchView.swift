//
//  SearchView.swift
//  qwerty
//
//  Created by Joonho Hwangbo on 2020/11/23.
//


import Foundation
import SwiftUI
import Combine


struct SearchView: View {
    @EnvironmentObject var searchViewState: SearchViewState
    
    var body: some View {
        SearchBar(text: self.$searchViewState.searchText, placeholder: "Categories ..., Free text")
            .onAppear(perform: {})
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            searchBar.showsCancelButton = true;
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false;
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.endEditing(true)
            searchBar.showsCancelButton = false;
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
}


class SearchViewState: ObservableObject {
    @Published var searchText: String = "cat"
    @Published var dst: String = ""
    
    private var disposables = Set<AnyCancellable>()
    init(){
        self.$searchText
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main).removeDuplicates()
          .sink { searchText in
            self.dst = searchText
        }.store(in: &disposables)
    }
}

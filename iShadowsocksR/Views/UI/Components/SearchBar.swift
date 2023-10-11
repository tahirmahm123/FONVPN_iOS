//
//  SearchBar.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 07/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//
import SwiftUI
import Combine

public extension View {
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    @available(macCatalyst, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    func navigationBarSearch(_ searchText: Binding<String>, placeholder: String? = nil, hidesNavigationBarDuringPresentation: Bool = true, hidesSearchBarWhenScrolling: Bool = true, cancelClicked: @escaping () -> Void = {}, searchClicked: @escaping () -> Void = {}) -> some View {
        return overlay(SearchBar<AnyView>(text: searchText, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, hidesSearchBarWhenScrolling: hidesSearchBarWhenScrolling, cancelClicked: cancelClicked, searchClicked: searchClicked).frame(width: 0, height: 0))
    }
    
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    @available(macCatalyst, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    func navigationBarSearch<ResultContent: View>(_ searchText: Binding<String>, placeholder: String? = nil, hidesNavigationBarDuringPresentation: Bool = true, hidesSearchBarWhenScrolling: Bool = true, cancelClicked: @escaping () -> Void = {}, searchClicked: @escaping () -> Void = {}, @ViewBuilder resultContent: @escaping (String) -> ResultContent) -> some View {
        return overlay(SearchBar(text: searchText, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, hidesSearchBarWhenScrolling: hidesSearchBarWhenScrolling, cancelClicked: cancelClicked, searchClicked: searchClicked, resultContent: resultContent).frame(width: 0, height: 0))
    }
}

struct SearchBar<ResultContent: View>: UIViewControllerRepresentable {
    @Binding
    var text: String
    let placeholder: String?
    let hidesNavigationBarDuringPresentation: Bool
    let hidesSearchBarWhenScrolling: Bool
    let cancelClicked: () -> Void
    let searchClicked: () -> Void
    let resultContent: (String) -> ResultContent?
    
    init(text: Binding<String>, placeholder: String?, hidesNavigationBarDuringPresentation: Bool, hidesSearchBarWhenScrolling: Bool, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void, @ViewBuilder resultContent: @escaping (String) -> ResultContent? = { _ in nil }) {
        self._text = text
        self.placeholder = placeholder
        self.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
        self.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        self.cancelClicked = cancelClicked
        self.searchClicked = searchClicked
        self.resultContent = resultContent
    }
    
    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }
    
    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.searchController = context.coordinator.searchController
        controller.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        controller.text = text
        
        context.coordinator.update(placeholder: placeholder, cancelClicked: cancelClicked, searchClicked: searchClicked)
        
        if let resultView = resultContent(text) {
            (controller.searchController?.searchResultsController as? UIHostingController<ResultContent>)?.rootView = resultView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, resultContent: resultContent, cancelClicked: cancelClicked, searchClicked: searchClicked)
    }
    
    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
        @Binding
        var text: String
        var cancelClicked: () -> Void
        var searchClicked: () -> Void
        let searchController: UISearchController
        
        private var updatedText: String
        
        init(text: Binding<String>, placeholder: String?, hidesNavigationBarDuringPresentation: Bool, resultContent: (String) -> ResultContent?, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void) {
            self._text = text
            updatedText = text.wrappedValue
            self.cancelClicked = cancelClicked
            self.searchClicked = searchClicked
            
            let resultView = resultContent(text.wrappedValue)
            let searchResultController = resultView.map { UIHostingController(rootView: $0) }
            self.searchController = UISearchController(searchResultsController: searchResultController)
            
            super.init()
            
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
            searchController.obscuresBackgroundDuringPresentation = false
            
            searchController.searchBar.delegate = self
            searchController.searchBar.text = self.text
            searchController.searchBar.placeholder = placeholder
        }
        
        func update(placeholder: String?, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void) {
            searchController.searchBar.placeholder = placeholder
            
            self.cancelClicked = cancelClicked
            self.searchClicked = searchClicked
        }
        
            // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
                // Make sure the text has actually changed (workaround for #10).
            guard updatedText != text else { return }
            
            DispatchQueue.main.async {
                self.updatedText = text
                self.text = text
            }
        }
        
        
            // MARK: - UISearchBarDelegate
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.cancelClicked()
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.searchClicked()
        }
    }
    
    class SearchBarWrapperController: UIViewController {
        var text: String? {
            didSet {
                self.parent?.navigationItem.searchController?.searchBar.text = text
            }
        }
        
        var searchController: UISearchController? {
            didSet {
                self.parent?.navigationItem.searchController = searchController
            }
        }
        
        var hidesSearchBarWhenScrolling: Bool = true {
            didSet {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            setup()
        }
        override func viewDidAppear(_ animated: Bool) {
            setup()
        }
        
        private func setup() {
            self.parent?.navigationItem.searchController = searchController
            self.parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            
                // make search bar appear at start (default behaviour since iOS 13)
            self.parent?.navigationController?.navigationBar.sizeToFit()
        }
    }
}

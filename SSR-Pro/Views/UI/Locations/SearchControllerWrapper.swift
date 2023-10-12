//
//  SearchControllerWrapper.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 19/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct SearchControllerWrapper: UIViewControllerRepresentable {
    @Binding var searchText: String
    
    class Coordinator: NSObject, UISearchResultsUpdating {
        let binding: Binding<String>
        
        init(binding: Binding<String>) {
            self.binding = binding
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            binding.wrappedValue = searchController.searchBar.text ?? ""
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = context.coordinator
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        let viewController = UIViewController()
        viewController.view.addSubview(searchController.searchBar)
        
            // Ensure the search bar is properly laid out
        searchController.searchBar.sizeToFit()
        
            // Prevent the search bar from being hidden when scrolling
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.hidesSearchBarWhenScrolling = false
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            // No need to update the view controller in this case
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(binding: $searchText)
    }
}

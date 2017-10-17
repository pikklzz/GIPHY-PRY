//
//  PryViewController.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import UIKit
import SDWebImage

class PryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    private var gifs = [GiphyGIF]()
    let searchController = UISearchController(searchResultsController: nil)
    private var networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Y", "G", "PG", "PG-13", "R"]
        searchController.searchBar.delegate = self
        
        navItem.title = "Trending 🔥"
        
        updateSearchResults(for: searchController)
        
    }
    
    
    func gifEverTrended(gif: GiphyGIF) -> Bool {
        return !gif.trendingDate.contains("0001") && !gif.trendingDate.contains("1970")
    }
    
    
    func updateDataset() {
        self.gifs = []
        
        for gifData in networkManager.gifsData {
            self.gifs.append(GiphyGIF(json: gifData))
        }
        
        self.tableView.reloadData()
    }
    
    
    func searchIsActive() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GIFTableViewCell
        
        let gif = gifs[indexPath.row]
        
        cell.gifPreview.sd_setShowActivityIndicatorView(true)
        cell.gifPreview.sd_setIndicatorStyle(.white)
        cell.gifPreview.sd_setImage(with: URL(string: gif.url))
        
        cell.label!.alpha = 0
        
        if gifEverTrended(gif: gif) && !searchBarIsEmpty() {
            cell.label!.alpha = 1
        }
        
        return cell
    }
    
}


extension PryViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let rating = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        let request = networkManager.formRequest(searchController: searchController, rating: rating, isNotSearching: searchBarIsEmpty())
        
        
        networkManager.makeRequest(request: request, completionHandler: {response, error in
            if let rawResponse = response {
                self.networkManager.prepareJson(rawResponse: rawResponse)
            }
            self.updateDataset()
        })
        
    }
    
}

extension PryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
}


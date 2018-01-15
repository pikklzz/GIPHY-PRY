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
    private let searchController = UISearchController(searchResultsController: nil)
    
    public var ratings = Ratings()
    private var gifManager = GifManager()
    
    func localizeRating(rawRating: Ratings.ratings) -> String {
        switch rawRating {
        case .All:   return "All";
        case .Y:     return "0+";
        case .G:     return "6+";
        case .PG:    return "10+";
        case .PG13:  return "13+";
        case .R:     return "18+"
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var ratingsToDisplay: [String] = []
        
        let ratingsRaw = ratings.returnAsArray()
        
        for rating in ratingsRaw {
            let localizedRating = localizeRating(rawRating: rating)
            ratingsToDisplay.append(localizedRating)
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ratingsToDisplay
        searchController.searchBar.delegate = self
        
        navItem.title = "Trending 🔥"
        
        updateSearchResults(for: searchController)
        
    }
    
    func updateDataset() {
        
        gifs = []
        
        for gifData in gifManager.gifsData {
            gifs.append(GiphyGIF(json: gifData))
        }
        
        tableView.reloadData()
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
        
        if !gif.neverTrended() && !searchBarIsEmpty() {
            cell.label!.alpha = 1
        }
        
        return cell
    }
    
}

extension PryViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let searchQuery = searchBar.text!
        ratings.selectedItemIndex = searchBar.selectedScopeButtonIndex
        
        gifManager.getGifs(searchQuery: searchQuery, rating: ratings.convert(), isNotSearchQuery: searchBarIsEmpty(), completionHandler: {completed, error in
            if completed {
                self.updateDataset()
            }
        })
        
    }
    
}

extension PryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
}


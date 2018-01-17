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
    
    private var gifs = [GiphyGIF]()
    let searchController = UISearchController(searchResultsController: nil)
    
    private let cellIdentifer = "Cell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GIFTableViewCell.self, forCellReuseIdentifier: GIFTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigationBar()
        setSearchBar()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Y", "G", "PG", "PG-13", "R"]
        searchController.searchBar.delegate = self
        
        title = "Trending 🔥"
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! GIFTableViewCell
        
        let gif = gifs[indexPath.row]
        
        cell.gifPreview.sd_setShowActivityIndicatorView(true)
        cell.gifPreview.sd_setIndicatorStyle(.white)
        cell.gifPreview.sd_setImage(with: URL(string: gif.url))
        
        cell.trendingLabel.alpha = 0
        
        if gifEverTrended(gif: gif) && !searchBarIsEmpty() {
            cell.trendingLabel.alpha = 1
        }
        
        return cell
    }
    
    func setTableView() {
        let tableViewCellHeight: CGFloat = 210
        
        tableView.backgroundView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.clipsToBounds = true
        
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rowHeight = tableViewCellHeight
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.clearsContextBeforeDrawing = true
        navigationController?.navigationBar.autoresizesSubviews = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    func setSearchBar() {
        UISearchBar.appearance().tintColor = .white
        UISearchBar.appearance().barStyle = .black
        UISearchBar.appearance().isTranslucent = false
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


//
//  PryViewController.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import UIKit
import SDWebImage

class PryViewController: UIViewController {
    
    private var gifs = [GiphyGIF]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GIFTableViewCell.self, forCellReuseIdentifier: GIFTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func setupTableView() {
        var allTableViewConstraints: [NSLayoutConstraint] = []
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
        
        allTableViewConstraints.append(tableView.leftAnchor.constraint(equalTo: view.leftAnchor))
        allTableViewConstraints.append(tableView.rightAnchor.constraint(equalTo: view.rightAnchor))
        allTableViewConstraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        allTableViewConstraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        tableView.rowHeight = tableViewCellHeight
        
        NSLayoutConstraint.activate(allTableViewConstraints)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.clearsContextBeforeDrawing = true
        navigationController?.navigationBar.autoresizesSubviews = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    private var ratingsSegmentControlDataSource = RatingsSegmentControlDataSource()
    private var gifManager = GifManager()
    
    func localizeRating(rawRating: Ratings) -> String {
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
        
        setupTableView()
        setupNavigationBar()
        
        var ratingsToDisplay: [String] = []
        
        let ratingsRaw = ratingsSegmentControlDataSource.ratings
        
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
        
        title = "Trending 🔥"
        
        updateSearchResults(for: searchController)
    }
    
    func searchIsActive() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension PryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        let searchQuery = searchBar.text ?? ""
        ratingsSegmentControlDataSource.selectedItemIndex = searchBar.selectedScopeButtonIndex
        let selectedRatingRawValue = ratingsSegmentControlDataSource.selectedRating.rawValue
        
        gifManager.gifs(searchQuery: searchQuery, rating: selectedRatingRawValue, isTrending: searchBarIsEmpty()) { receivedGifs, error in
            if let receivedGifs = receivedGifs {
                self.gifs = receivedGifs
                self.tableView.reloadData()
            }
        }
    }
}

extension PryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension PryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GIFTableViewCell.cellIdentifier, for: indexPath) as! GIFTableViewCell
        
        let gif = gifs[indexPath.row]
        
        cell.gifPreview.sd_setShowActivityIndicatorView(true)
        cell.gifPreview.sd_setIndicatorStyle(.white)
        cell.gifPreview.sd_setImage(with: URL(string: gif.url))
        
        if !gif.neverTrended() && !searchBarIsEmpty() {
            cell.trendingLabel.alpha = 1
        } else {
            cell.trendingLabel.alpha = 0
        }
        
        return cell
    }
}

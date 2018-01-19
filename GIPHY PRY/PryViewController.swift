//
//  PryViewController.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import UIKit

class PryViewController: UIViewController {
    
    private var gifs = [GiphyGIF]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GIFTableViewCell.self, forCellReuseIdentifier: GIFTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var ratingsSegmentControlDataSource = RatingsSegmentControlDataSource()
    private var gifManager = GifManager()
    
    private func localizeRating(rawRating: Ratings) -> String {
        switch rawRating {
        case .All:   return "All";
        case .Y:     return "0+";
        case .G:     return "6+";
        case .PG:    return "10+";
        case .PG13:  return "13+";
        case .R:     return "18+"
        }
    }
    
    private func configureTableView() {
        tableView.backgroundView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
        tableView.clipsToBounds = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500.0
        
        view.addSubview(tableView)
    }
    
    private func layoutTableView() {
        var allTableViewConstraints: [NSLayoutConstraint] = []
        
        allTableViewConstraints.append(tableView.leftAnchor.constraint(equalTo: view.leftAnchor))
        allTableViewConstraints.append(tableView.rightAnchor.constraint(equalTo: view.rightAnchor))
        allTableViewConstraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        allTableViewConstraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        NSLayoutConstraint.activate(allTableViewConstraints)
    }
    
    private func configureSearchController() {
        var ratingsForScopeButtonTitles: [String] = []
        let ratingsRaw = ratingsSegmentControlDataSource.ratings
        for rating in ratingsRaw {
            let localizedRating = localizeRating(rawRating: rating)
            ratingsForScopeButtonTitles.append(localizedRating)
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ratingsForScopeButtonTitles
        searchController.searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trending 🔥"
        
        configureTableView()
        layoutTableView()
        configureSearchController()
        
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

// MARK: - UISearchResultsUpdating
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

// MARK: - UISearchBarDelegate
extension PryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
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
        
        cell.aspectRatio = gif.aspectRatio
        
        let gifFitsToBeTrended = !gif.neverTrended() && !searchBarIsEmpty()
        cell.appropriateTrendingLabelState(is: gifFitsToBeTrended)
        
        return cell
    }
}

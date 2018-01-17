//
//  GIFTableViewCell.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import UIKit
import SDWebImage

class GIFTableViewCell: UITableViewCell {
    static let cellIdentifier = "Cell"
    private(set) var trendingLabel = UILabel()
    private(set) var gifPreview = FLAnimatedImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        var allConstraints: [NSLayoutConstraint] = []
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(trendingLabel)
        contentView.addSubview(gifPreview)
        
        backgroundColor = .black
        gifPreview.translatesAutoresizingMaskIntoConstraints = false
        gifPreview.contentMode = .scaleAspectFill
        gifPreview.clipsToBounds = true
        
        allConstraints.append(gifPreview.leftAnchor.constraint(equalTo: contentView.leftAnchor))
        allConstraints.append(gifPreview.rightAnchor.constraint(equalTo: contentView.rightAnchor))
        allConstraints.append(gifPreview.topAnchor.constraint(equalTo: contentView.topAnchor))
        allConstraints.append(gifPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        
        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
        trendingLabel.textAlignment = .right
        trendingLabel.font = UIFont.systemFont(ofSize: 30)
        trendingLabel.text = "🔥"
        
        allConstraints.append(trendingLabel.heightAnchor.constraint(equalToConstant: 34))
        allConstraints.append(trendingLabel.leftAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.leftAnchor))
        allConstraints.append(trendingLabel.rightAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.rightAnchor))
        allConstraints.append(trendingLabel.topAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.topAnchor))

        NSLayoutConstraint.activate(allConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

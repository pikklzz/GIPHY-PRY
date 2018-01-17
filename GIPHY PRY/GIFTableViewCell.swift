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
    var trendingLabel = UILabel()
    var gifPreview = FLAnimatedImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(trendingLabel)
        contentView.addSubview(gifPreview)
        
        backgroundColor = .black
        gifPreview.translatesAutoresizingMaskIntoConstraints = false
        gifPreview.frame = CGRect(x: 0, y: 0, width: 375, height: 210)
        gifPreview.contentMode = .scaleAspectFill
        gifPreview.clipsToBounds = true
        
        gifPreview.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        gifPreview.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        gifPreview.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
        trendingLabel.isEnabled = true
        trendingLabel.textAlignment = .right
        trendingLabel.font = UIFont.systemFont(ofSize: 30)
        trendingLabel.frame = CGRect(x: 15, y: 11, width: 345, height: 34)
        trendingLabel.text = "🔥"
        
        trendingLabel.heightAnchor.constraint(equalToConstant: 34)
        trendingLabel.leftAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.leftAnchor).isActive = true
        trendingLabel.rightAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.rightAnchor).isActive = true
        trendingLabel.topAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

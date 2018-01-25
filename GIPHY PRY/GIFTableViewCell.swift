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
    private let trendingLabel = UILabel()
    private(set) var gifPreview = FLAnimatedImageView()
    private var aspectConstraint: NSLayoutConstraint? = nil
    
    var aspectRatio: Double = 0 {
        didSet {
            aspectConstraint = gifPreview.widthAnchor.constraint(equalTo: gifPreview.heightAnchor, multiplier: CGFloat(aspectRatio))
            aspectConstraint?.priority = UILayoutPriority.defaultHigh
            aspectConstraint?.isActive = true
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        func configureCellContent() {
            backgroundColor = .black
            gifPreview.translatesAutoresizingMaskIntoConstraints = false
            gifPreview.contentMode = .scaleToFill
            gifPreview.clipsToBounds = true
            
            trendingLabel.translatesAutoresizingMaskIntoConstraints = false
            trendingLabel.textAlignment = .right
            trendingLabel.font = UIFont.systemFont(ofSize: 30)
            trendingLabel.text = "🔥"
            
            contentView.addSubview(gifPreview)
            contentView.addSubview(trendingLabel)
        }
        
        func layoutCellContent() {
            var allConstraints: [NSLayoutConstraint] = []
            
            allConstraints.append(gifPreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
            allConstraints.append(gifPreview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
            allConstraints.append(gifPreview.topAnchor.constraint(equalTo: contentView.topAnchor))
            allConstraints.append(gifPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
            
            allConstraints.append(trendingLabel.leadingAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.leadingAnchor))
            allConstraints.append(trendingLabel.trailingAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.trailingAnchor))
            allConstraints.append(trendingLabel.topAnchor.constraint(equalTo: gifPreview.layoutMarginsGuide.topAnchor))
            
            NSLayoutConstraint.activate(allConstraints)
        }
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCellContent()
        layoutCellContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func appropriateTrendingLabelState(is state: Bool){
        trendingLabel.isHidden = !state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let aspectConstraint = aspectConstraint {
            gifPreview.removeConstraint(aspectConstraint)
        }
    }
}

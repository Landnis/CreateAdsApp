//
//  SearchResultsCell.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 15/10/25.
//

import UIKit

class SearchResultsCell: UICollectionViewCell {

    @IBOutlet weak var backgroundContainerView: UIView! {
        didSet {
            backgroundContainerView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var resultLabel: UILabel! {
        didSet {
            resultLabel.textColor = .black
            resultLabel.font = UIFont.systemFont(ofSize: 15)
            resultLabel.textAlignment = .left
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

}

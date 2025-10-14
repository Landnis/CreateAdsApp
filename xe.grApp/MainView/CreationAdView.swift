//
//  CreationAdView.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class CreationAdView: UIView {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "New property classified !"
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            titleLabel.layer.shadowColor = UIColor.black.cgColor
            titleLabel.layer.shadowOpacity = 0.3
            titleLabel.layer.shadowRadius = 5
            titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .red
            collectionView.isScrollEnabled = false
            
//            let popularMovieNibname = UINib(nibName: "PopularMoviesCell", bundle: nil)
//            collectionView.register(popularMovieNibname, forCellWithReuseIdentifier: "PopularMoviesCell")
        }
    }
}

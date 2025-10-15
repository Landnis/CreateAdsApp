//
//  CreationAdView.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class CreationAdView: UIView {
    
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var adTitleLabel: UILabel! {
        didSet {
            adTitleLabel.text = "Title"
            adTitleLabel.textColor = .black
            adTitleLabel.textAlignment = .left
            adTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    @IBOutlet weak var adTitleTextField: UITextField! {
        didSet {
            adTitleTextField.backgroundColor = .lightGray.withAlphaComponent(0.3)
            adTitleTextField.keyboardType = .default
            adTitleTextField.placeholder = "Type something..."
        }
    }
    
    @IBOutlet weak var containerBackView: UIView! {
        didSet {
            containerBackView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.text = "Location"
            locationLabel.textColor = .black
            locationLabel.textAlignment = .left
            locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            locationTextField.backgroundColor = .lightGray.withAlphaComponent(0.3)
            locationTextField.keyboardType = .default
            locationTextField.placeholder = "Type something..."
        }
    }
    
    @IBOutlet weak var priceTextFieldLabel: UILabel! {
        didSet {
            priceTextFieldLabel.text = "Price"
            priceTextFieldLabel.textColor = .black
            priceTextFieldLabel.textAlignment = .left
            priceTextFieldLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    @IBOutlet weak var priceTextField: UITextField! {
        didSet {
            priceTextField.backgroundColor = .lightGray.withAlphaComponent(0.3)
            priceTextField.keyboardType = .default
            priceTextField.placeholder = "Type something..."
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Description"
            descriptionLabel.textColor = .black
            descriptionLabel.textAlignment = .left
            descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.backgroundColor = .lightGray.withAlphaComponent(0.3)
            descriptionTextView.keyboardType = .default
            descriptionTextView.text = "Type something..."
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
    
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.setTitle("Submit", for: .normal)
            confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            confirmButton.setTitleColor(.white, for: .normal)
            confirmButton.backgroundColor = .green
            confirmButton.layer.cornerRadius = 8
            confirmButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var clearButton: UIButton! {
        didSet {
            clearButton.setTitle("Clear", for: .normal)
            clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            clearButton.setTitleColor(.white, for: .normal)
            clearButton.backgroundColor = .red
            clearButton.layer.cornerRadius = 8
            clearButton.clipsToBounds = true
        }
    }
}

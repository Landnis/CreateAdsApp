//
//  LaunchView.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class LaunchView: UIView {

    @IBOutlet weak var launchImageView: UIImageView! {
        didSet {
            launchImageView.image = UIImage(named: "xe.gr_Launch_img")
            launchImageView.layer.shadowColor = UIColor.black.cgColor
            launchImageView.layer.shadowOpacity = 0.3
            launchImageView.layer.shadowRadius = 5
            launchImageView.layer.shadowOffset = CGSize(width: 0, height: 5)
            launchImageView.layer.cornerRadius = 5
            launchImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var loadingLabel: UILabel! {
        didSet {
            loadingLabel.text = "Loading..."
            loadingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            loadingLabel.textAlignment = .center
            loadingLabel.layer.shadowColor = UIColor.black.cgColor
            loadingLabel.layer.shadowOpacity = 0.5
            loadingLabel.layer.shadowRadius = 4
            loadingLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
    }
    
}

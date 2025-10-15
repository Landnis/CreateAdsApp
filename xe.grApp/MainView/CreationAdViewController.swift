//
//  CreationAdViewController.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class CreationAdViewController: UIViewController {

    @IBOutlet var creationAdView: CreationAdView! {
        didSet {
            creationAdView.backgroundColor = .white
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        creationAdView.collectionHeightConstraint.constant = 0
        creationAdView.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) {
            self.creationAdView.layoutIfNeeded()
        }
    }

}

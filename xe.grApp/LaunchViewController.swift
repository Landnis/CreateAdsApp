//
//  LaunchViewController.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet var lanchView: LaunchView! {
        didSet {
            lanchView.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 5/255, alpha: 1.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showCreationAdView()
    }

    private func showCreationAdView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            let createAdScreenVC = CreationAdViewController()
            createAdScreenVC.modalPresentationStyle = .fullScreen
            self?.present(createAdScreenVC, animated: true, completion: nil)
        }
    }
}


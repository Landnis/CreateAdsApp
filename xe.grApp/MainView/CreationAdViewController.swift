//
//  CreationAdViewController.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class CreationAdViewController: UIViewController {
    
    var searchResults: [String] = []
    var searchMode: Bool = false
    @IBOutlet var creationAdView: CreationAdView! {
        didSet {
            creationAdView.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        creationAdView.collectionView.delegate = self
        creationAdView.collectionView.dataSource = self
        creationAdView.locationTextField.delegate = self
    }
    
    private func setCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let hasResults = !searchResults.isEmpty
            creationAdView.collectionView.isHidden = !hasResults
            creationAdView.collectionHeightConstraint.constant = hasResults ? 150 : 0
            creationAdView.collectionView.reloadData()
            UIView.animate(withDuration: 0.25) {
                self.creationAdView.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        creationAdView.adTitleTextField.text = nil
        creationAdView.locationTextField.text = nil
        creationAdView.priceTextField.text = nil
        creationAdView.descriptionTextView.text = nil
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
    }
    
}

extension CreationAdViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultsCell", for: indexPath) as? SearchResultsCell else
        {
            return UICollectionViewCell()
        }
        
        cell.resultLabel.text = searchResults[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 3)
    }
}

extension CreationAdViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let current = textField.text as NSString? {
            let newText = current.replacingCharacters(in: range, with: string)
            newText.count == 0 ? (searchMode = false ) : (searchMode = true)
            newText.count == 0 ? (searchResults = []) : (searchResults = ["Naflpio", "Thessaloniki", "Athens","Naflpio", "Thessaloniki", "Athens"])
            setCollectionView()
//            Task {
//                await searchForMovies(textQuery: newText)
//            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  CreationAdViewController.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class CreationAdViewController: UIViewController {
    
    var searchResults: [SearchLocationResponse] = []
    var textFieldQuery: String?
    var shouldShowResults: Bool = false
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
            creationAdView.collectionHeightConstraint.constant = CGFloat(hasResults ? (searchResults.count * 64) : 0) //hasResults ? 150 : 0
            creationAdView.collectionView.reloadData()
            creationAdView.priceTextField.isHidden = hasResults ? true : false
            creationAdView.priceTextFieldLabel.isHidden = hasResults ? true : false
            creationAdView.descriptionTextView.isHidden = hasResults ? true : false
            creationAdView.descriptionLabel.isHidden = hasResults ? true : false
            creationAdView.clearButton.isHidden = hasResults ? true : false
            creationAdView.confirmButton.isHidden = hasResults ? true : false
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
    
    @MainActor
    func searchLocations(textQuery: String) async {
        do {
            let response: [SearchLocationResponse]  = try await NetworkManager.shared.request(
                searchValue: textQuery,
                responseType: [SearchLocationResponse].self
            )
            print("✅ Response:", response)
            searchResults = response
            setCollectionView()
        } catch {
            print("❌ Error:", error.localizedDescription)
        }
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
        
        cell.resultLabel.text = searchResults[indexPath.row].displayText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        creationAdView.endEditing(true)
        creationAdView.locationTextField.text = searchResults[indexPath.row].displayText
        textFieldQuery = searchResults[indexPath.row].displayText
        searchResults.removeAll()
        setCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 64)
    }
}

extension CreationAdViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let current = textField.text as NSString? {
            let newText = current.replacingCharacters(in: range, with: string)
            textFieldQuery = ""
            if newText.count >= 3 {
                Task {
                    await searchLocations(textQuery: newText)
                }
            } else if newText.count == 0 {
                setCollectionView()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        debugPrint(reason)
    }
}

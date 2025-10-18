//
//  CreationAdViewController.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 14/10/25.
//

import UIKit

class CreationAdViewController: UIViewController {
    
    var searchResults: [SearchLocationResponse] = []
    var selectedLocation: String?
    var shouldShowResults: Bool = false
    private var debounceTask: Task<Void, Never>?
    @IBOutlet var creationAdView: CreationAdView! {
        didSet {
            creationAdView.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setResultView()
        creationAdView.collectionView.delegate = self
        creationAdView.collectionView.dataSource = self
        creationAdView.locationTextField.delegate = self
    }
    
    private func setResultView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let hasResults = !searchResults.isEmpty
            creationAdView.collectionView.isHidden = !hasResults
            creationAdView.collectionHeightConstraint.constant = CGFloat(hasResults ? (searchResults.count * 64) : 0) //hasResults ? 150 : 0
            creationAdView.collectionView.reloadData()
            shouldHideTextFields(shouldHide: hasResults)
            UIView.animate(withDuration: 0.25) {
                self.creationAdView.layoutIfNeeded()
            }
        }
    }
    
    private func shouldEnableSubmitButton(_ enabled: Bool) {
        creationAdView.confirmButton.isUserInteractionEnabled = enabled
        creationAdView.confirmButton.alpha = enabled ? 1.0 : 0.5
    }
    
    private func validateForm() {
        let titleValid = !(creationAdView.adTitleTextField.text ?? "").isEmpty
        let locationValid = !(selectedLocation ?? "").isEmpty
        shouldEnableSubmitButton(titleValid && locationValid)
    }
    
    private func shouldHideTextFields(shouldHide: Bool) {
        creationAdView.priceTextField.isHidden = shouldHide
        creationAdView.priceTextFieldLabel.isHidden = shouldHide
        creationAdView.descriptionTextView.isHidden = shouldHide
        creationAdView.descriptionLabel.isHidden = shouldHide
        creationAdView.clearButton.isHidden = shouldHide
        creationAdView.confirmButton.isHidden = shouldHide
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        creationAdView.adTitleTextField.text = nil
        creationAdView.locationTextField.text = nil
        creationAdView.priceTextField.text = nil
        creationAdView.descriptionTextView.text = nil
        searchResults.removeAll()
        setResultView()
        shouldEnableSubmitButton(false)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        debugPrint(
            creationAdView.adTitleTextField.text ?? "",
            selectedLocation ?? "",
            creationAdView.priceTextField.text ?? "",
            creationAdView.descriptionTextView.text ?? ""
        )
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
            setResultView()
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
        selectedLocation = searchResults[indexPath.row].displayText
        searchResults.removeAll()
        setResultView()
        validateForm()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 64)
    }
}

extension CreationAdViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let current = textField.text as NSString? else { return true }
        let newText = current.replacingCharacters(in: range, with: string)
        selectedLocation = nil
        validateForm()
        
        if newText.count < 3 {
            searchResults.removeAll()
            setResultView()
            return true
        }
       
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000) // ~0.4 sec
            await self?.searchLocations(textQuery: newText)
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard textField == creationAdView.locationTextField else { return }
//        guard !isSelectingLocationFromResults else { return } // <-- prevents unwanted hide
//        
//        searchResults.removeAll()
//        setResultView()
    }
}

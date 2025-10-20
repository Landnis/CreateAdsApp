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
    var isSelectingLocationFromResults: Bool = false
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
            creationAdView.collectionHeightConstraint.constant = CGFloat(hasResults ? (searchResults.count * 64) : 0)
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
        let locationValid = !(selectedLocation ?? "").isEmpty
        shouldEnableSubmitButton(locationValid)
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
        clearAllTheFields()
    }
    
    private func clearAllTheFields() {
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
        guard let location = selectedLocation, (selectedLocation != nil) else {
            showAlert(title: "Error", message: "Please fill the location field.")
            return
        }
        
        let ad = AdCreationModel(
            location: location,
            title: creationAdView.adTitleTextField.text ?? " ",
            price: creationAdView.priceTextField.text?.isEmpty == true ? nil : creationAdView.priceTextField.text,
            description:  creationAdView.descriptionTextView.text?.isEmpty == true ? nil :  creationAdView.descriptionTextView.text )
        
        sendTheAdToServer(adCreation: ad)
    }
    
    private func sendTheAdToServer(adCreation: AdCreationModel) {
        do {
            let jsonString = try NetworkManager.shared.encodeToJSON(adCreation)
            
            showAlert(title: "JSON Created", message: jsonString)
            
            clearAllTheFields()
        } catch {
            showAlert(title: "Error", message: "Failed to create JSON: \(error)")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        isSelectingLocationFromResults = true
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelectingLocationFromResults = true
        creationAdView.locationTextField.text = searchResults[indexPath.row].displayText
        selectedLocation = searchResults[indexPath.row].displayText
        searchResults.removeAll()
        setResultView()
        validateForm()
        creationAdView.endEditing(true)
        isSelectingLocationFromResults = false
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
            debounceTask?.cancel()
            searchResults.removeAll()
            setResultView()
            return true
        }
        
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 400_000_000)
            await self?.searchLocations(textQuery: newText)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == creationAdView.locationTextField else { return }
        if !isSelectingLocationFromResults {
            searchResults.removeAll()
            setResultView()
        }
    }
}

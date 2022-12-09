//
//  FoodPreferencesViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/11/22.
//

import UIKit

class FoodPreferencesViewController: UIViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentedControl: VesselSegmentedControl!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: Model
    private let viewModel = FoodPreferencesViewModel()
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .moreTabFlow
    var associatedValue: String?
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            return "Diet"
        }
        else
        {
            return "Allergies"
        }
    }
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📖 did load \(self)")
        }
        
        collectionView.registerFromNib(CheckmarkCollectionViewCell.self)
        updateSaveButton()
        viewModel.onContactSaved = onContactSaved
        viewModel.onError = onError
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        onSaveTapped()
    }
    
    @IBAction func onSaveTapped()
    {
        if viewModel.anyItemChecked() == true
        {
            viewModel.save()
            updateSaveButton()
        }
        else
        {
            let text = viewModel.tooFewItemsSelectedText()
            UIView.showError(text: "", detailText: text, image: nil)
        }
    }
    
    @IBAction func segmentedControlTapped()
    {
        viewModel.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        collectionView.reloadData()
        analytics.log(event: .viewedPage(screenName: String(describing: type(of: self)), flowName: self.flowName, associatedValue: self.associatedValue))
    }
    
    func onContactSaved()
    {
        updateSaveButton()
        navigationController?.popViewController(animated: true)
    }
    
    func onError(_ error: String)
    {
        updateSaveButton()
        UIView.showError(text: "", detailText: error, image: nil)
    }
    
    // MARK: UI
    func updateSaveButton()
    {
        if !viewModel.anyItemChecked() || viewModel.isLoading
        {
            saveButton.backgroundColor = Constants.vesselGray
        }
        else
        {
            saveButton.backgroundColor = Constants.vesselBlack
        }
    }
}

extension FoodPreferencesViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModel.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: CheckmarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let info = viewModel.infoForItemAt(indexPath: indexPath)
        cell.setup(name: info.name, id: info.id, delegate: self, isChecked: viewModel.itemIsChecked(id: info.id))
        return cell
    }
}

extension FoodPreferencesViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height = Constants.CHECK_BUTTON_HEIGHT
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            height = Constants.SMALL_SCREEN_CHECK_BUTTON_HEIGHT
        }
        return CGSize(width: collectionView.frame.width * 0.48, height: height)
    }
}

extension FoodPreferencesViewController: CheckmarkCollectionViewCellDelegate
{
    func checkButtonTapped(id: Int)
    {
        viewModel.itemTapped(id: id)
        NotificationCenter.default.post(name: .updateCheckmarks, object: nil, userInfo: nil)
        updateSaveButton()
    }
    
    func isChecked(forID id: Int) -> Bool
    {
        return viewModel.itemIsChecked(id: id)
    }
}

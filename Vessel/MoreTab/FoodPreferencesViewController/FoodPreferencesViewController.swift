//
//  FoodPreferencesViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/11/22.
//

import UIKit

class FoodPreferencesViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentedControl: VesselSegmentedControl!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: Model
    private let viewModel = FoodPreferencesViewModel()
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }
        
        collectionView.registerFromNib(CheckmarkCollectionViewCell.self)
        updateSaveButton()
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
            navigationController?.popViewController(animated: true)
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
    }
    
    // MARK: UI
    func updateSaveButton()
    {
        if viewModel.anyItemChecked() == true
        {     
            saveButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            saveButton.backgroundColor = Constants.vesselGray
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
        cell.setup(name: info.name, id: info.id, delegate: self, isChecked: viewModel.itemIsChecked(id: info.id), type: viewModel.type)
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
    func checkButtonTapped(forCell cell: UICollectionViewCell, checked: Bool)
    {
        viewModel.selectItem(id: cell.tag, selected: checked)
        //collectionView.reloadData()
        updateSaveButton()
    }
    
    func isChecked(forID id: Int) -> Bool
    {
        return viewModel.itemIsChecked(id: id)
    }
    
    func canCheckMoreButtons() -> Bool
    {
        return true
    }
}

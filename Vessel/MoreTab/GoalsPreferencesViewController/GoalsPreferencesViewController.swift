//
//  FoodPreferencesViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/16/22.
//

import UIKit

class GoalsPreferencesViewController: UIViewController
{
    // MARK: - Views
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: Model
    private let viewModel = GoalsPreferencesViewModel()
    var coordinator: OnboardingCoordinator?
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }
        
        collectionView.registerFromNib(CheckmarkImageCollectionViewCell.self)
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

extension GoalsPreferencesViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModel.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //show image checkmark cell
        let cell: CheckmarkImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let info = viewModel.infoForItemAt(indexPath: indexPath)
        cell.setup(name: info.name, id: info.id, imageName: info.imageName ?? "", delegate: self, isChecked: viewModel.itemIsChecked(id: info.id))
        return cell
    }
}

extension GoalsPreferencesViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width * 0.48, height: collectionView.frame.width * 0.48)
    }
}

extension GoalsPreferencesViewController: CheckmarkImageCollectionViewCellDelegate
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

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
    
    // MARK: Model
    private let viewModel = GoalsPreferencesViewModel()
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.registerFromNib(CheckmarkImageCollectionViewCell.self)
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        viewModel.save()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveTapped()
    {
        viewModel.save()
        navigationController?.popViewController(animated: true)
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
        cell.titleLabel.text = info.name
        cell.backgroundImage.image = UIImage(named: info.imageName ?? "")
        //we'll use the tag to hold the goal ID
        cell.tag = info.id
        cell.delegate = self
        cell.isChecked = viewModel.itemIsChecked(id: info.id)
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
    func checkButtonTapped(forCell cell: UICollectionViewCell, checked: Bool)
    {
        viewModel.selectItem(id: cell.tag, selected: checked)
        collectionView.reloadData()
    }
    
    func canCheckMoreButtons() -> Bool
    {
        return true
    }
}

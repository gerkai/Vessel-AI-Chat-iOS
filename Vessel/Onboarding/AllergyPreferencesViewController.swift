//
//  AllergyPreferencesViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/9/22.
//

import UIKit

class AllergyPreferencesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CheckmarkCollectionViewCellDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var allergyLabelSpacing: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    var viewModel: OnboardingViewModel?
    
    override func viewDidLoad()
    {
        collectionView.registerFromNib(CheckmarkCollectionViewCell.self)
        //on smaller screens move everything up so all checkboxes have best chance of fitting on screen
        //without making the user have to scroll.
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            allergyLabelSpacing.constant = Constants.MIN_VERT_SPACING_TO_BACK_BUTTON
        }
        updateNextButton()
    }
    
    @IBAction func back()
    {
        viewModel?.backup()
        self.navigationController?.fadeOut()
    }
    
    @IBAction func next()
    {
        if viewModel?.anyAllergyChecked() == true
        {
            let vc = OnboardingViewModel.NextViewController()
            navigationController?.fadeTo(vc)
        }
        else
        {
            UIView.showError(text: "", detailText: NSLocalizedString("Please select an answer", comment:"Error message when user hasn't yet made a selection"), image: nil)
        }
    }
    
    func updateNextButton()
    {
        if viewModel?.anyAllergyChecked() == true
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height = Constants.CHECK_BUTTON_HEIGHT
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            height = Constants.SMALL_SCREEN_CHECK_BUTTON_HEIGHT
        }
        return CGSize(width: collectionView.frame.width * 0.48, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Allergies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: CheckmarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.titleLabel.text = Allergies[indexPath.row].name.capitalized
        //we'll use the tag to hold the allergyID
        cell.tag = Allergies[indexPath.row].id
        cell.delegate = self
        cell.isChecked = viewModel?.allergyIsChecked(allergyID: cell.tag) ?? false
        return cell
    }
    
    //MARK: - CheckmarkCollectionViewCell delegates
    func checkButtonTapped(forCell cell: UICollectionViewCell, checked: Bool)
    {
        viewModel?.selectAllergy(allergyID: cell.tag, selected: checked)
        collectionView.reloadData()
        updateNextButton()
    }
    
    func canCheckMoreButtons() -> Bool
    {
        return true
    }
}

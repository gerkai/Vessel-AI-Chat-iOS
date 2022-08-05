//
//  ItemPreferencesViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//
//  Used for Diet Preferences, Allergy Preferences, and Goal selection
//  Will use CheckmarkCollectionViewCell or the larger CheckmarkImageCollectionViewCell depending on itemType variable.

import UIKit

class ItemPreferencesViewController: OnboardingMVVMViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CheckmarkCollectionViewCellDelegate, CheckmarkImageCollectionViewCellDelegate
{
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabelSpacing: NSLayoutConstraint!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTextLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    var titleText: String?
    var subtext: String?
    var itemType: ItemPreferencesType = .Diet
    var hideBackground: Bool = false
    
    override func viewDidLoad()
    {
        collectionView.registerFromNib(CheckmarkCollectionViewCell.self)
        collectionView.registerFromNib(CheckmarkImageCollectionViewCell.self)
        //on smaller screens move everything up so all checkboxes have best chance of fitting on screen
        //without making the user have to scroll.
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            titleLabelSpacing.constant = Constants.MIN_VERT_SPACING_TO_BACK_BUTTON
        }
        updateNextButton()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        titleLabel.text = titleText
        subTextLabel.text = subtext
        backgroundImageView.isHidden = hideBackground
    }
    
    @IBAction func back()
    {
        viewModel?.backup()
        self.navigationController?.fadeOut()
    }
    
    @IBAction func next()
    {
        if viewModel?.anyItemChecked(itemType) == true
        {
            let vc = OnboardingViewModel.NextViewController()
            navigationController?.fadeTo(vc)
        }
        else
        {
            let text = viewModel!.tooFewItemsSelectedText(type: itemType)
            UIView.showError(text: "", detailText: text, image: nil)
        }
    }
    
    func updateNextButton()
    {
        if viewModel?.anyItemChecked(itemType) == true
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
        //SingleGoal uses bigger cells
        if itemType == .SingleGoal
        {
            height = collectionView.frame.width * 0.48
        }
        return CGSize(width: collectionView.frame.width * 0.48, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModel!.itemCount(itemType)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if itemType == .SingleGoal
        {
            //show image checkmark cell
            let cell: CheckmarkImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let info = viewModel!.infoForItemAt(indexPath: indexPath, type: itemType)
            cell.titleLabel.text = info.name
            cell.backgroundImage.image = info.image
            //we'll use the tag to hold the goal ID
            cell.tag = info.id
            cell.delegate = self
            cell.isChecked = viewModel!.itemIsChecked(type: itemType, id: info.id)
            return cell
        }
        else
        {
            //show regular checkmark cell
            let cell: CheckmarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let info = viewModel!.infoForItemAt(indexPath: indexPath, type: itemType)
            cell.titleLabel.text = info.name
            //we'll use the tag to hold the diet/allergy/goal ID
            cell.tag = info.id
            cell.delegate = self
            cell.isChecked = viewModel!.itemIsChecked(type: itemType, id: info.id)
            return cell
        }
    }
    
    //MARK: - CheckmarkCollectionViewCell delegates
    func checkButtonTapped(forCell cell: UICollectionViewCell, checked: Bool)
    {
        viewModel!.selectItem(type: itemType, id: cell.tag, selected: checked)
        collectionView.reloadData()
        updateNextButton()
    }
    
    func canCheckMoreButtons() -> Bool
    {
        return true
    }
}

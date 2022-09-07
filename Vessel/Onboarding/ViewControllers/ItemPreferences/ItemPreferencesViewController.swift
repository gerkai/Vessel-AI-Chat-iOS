//
//  ItemPreferencesViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//
//  Used for Diet Preferences, Allergy Preferences, and Goal selection
//  Will use CheckmarkCollectionViewCell or the larger CheckmarkImageCollectionViewCell depending on itemType variable.

import UIKit

class ItemPreferencesViewController: UIViewController
{
    // MARK: - View
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabelSpacing: NSLayoutConstraint!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTextLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    // MARK: - Logic
    var viewModel = ItemPreferencesViewModel()
    var coordinator: OnboardingCoordinator?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📗 did load \(self)")
        }

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
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("📘 deinit \(self)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        titleLabel.text = viewModel.titleText
        subTextLabel.text = viewModel.subtext
        backgroundImageView.isHidden = viewModel.hideBackground
    }
    
    // MARK: - Actions
    @IBAction func onBackTapped()
    {
        coordinator?.backup()
    }
    
    @IBAction func onNextTapped()
    {
        if viewModel.anyItemChecked() == true
        {
            coordinator?.pushNextViewController()
        }
        else
        {
            let text = viewModel.tooFewItemsSelectedText()
            UIView.showError(text: "", detailText: text, image: nil)
        }
    }
    
    // MARK: - UI
    func updateNextButton()
    {
        if viewModel.anyItemChecked() == true
        {
            nextButton.backgroundColor = Constants.vesselBlack
        }
        else
        {
            nextButton.backgroundColor = Constants.vesselGray
        }
    }
}

// MARK: - CollectionView Delegate and DataSource
extension ItemPreferencesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var height = Constants.CHECK_BUTTON_HEIGHT
        if view.frame.height < Constants.SMALL_SCREEN_HEIGHT_THRESHOLD
        {
            height = Constants.SMALL_SCREEN_CHECK_BUTTON_HEIGHT
        }
        //SingleGoal uses bigger cells
        if viewModel.type == .mainGoal
        {
            height = collectionView.frame.width * 0.48
        }
        return CGSize(width: collectionView.frame.width * 0.48, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModel.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if viewModel.type == .mainGoal
        {
            //show image checkmark cell
            let cell: CheckmarkImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let info = viewModel.infoForItemAt(indexPath: indexPath)
            cell.type = viewModel.type
            cell.titleLabel.text = info.name
            cell.backgroundImage.image = UIImage(named: info.imageName ?? "")
            //we'll use the tag to hold the goal ID
            cell.tag = info.id
            cell.delegate = self
            cell.isChecked = viewModel.itemIsChecked(id: info.id)
            return cell
        }
        else
        {
            //show regular checkmark cell
            let cell: CheckmarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let info = viewModel.infoForItemAt(indexPath: indexPath)
            cell.setup(name: info.name, id: info.id, delegate: self, isChecked: viewModel.itemIsChecked(id: info.id))
            return cell
        }
    }
}

//MARK: - CheckmarkCollectionViewCell delegates
extension ItemPreferencesViewController: CheckmarkCollectionViewCellDelegate, CheckmarkImageCollectionViewCellDelegate
{
    func checkButtonTapped(id: Int)
    {
        viewModel.itemTapped(id: id)
        NotificationCenter.default.post(name: .updateCheckmarks, object: nil, userInfo: nil)
        
        updateNextButton()
    }
    
    func isChecked(forID id: Int) -> Bool
    {
        return viewModel.itemIsChecked(id: id)
    }
}

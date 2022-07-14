//
//  TipInstuctionsViewController.swift
//  vessel-ios
//
//  Created by Mohamed El-Taweel on 13/04/2021.
//  Copyright © 2021 Vessel Health Inc. All rights reserved.
//

import UIKit

class TipInstuctionsViewController: TakeTestMVVMViewController
{
    /*
    var onDimiss = {}
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet var circleViews: [UIView]!
    @IBOutlet var tipsViews: [UIStackView]!
    
    
    var viewModels = [ActivateCardTabCellViewModel(image: nil, title: "Use a cup", isSelected: true),ActivateCardTabCellViewModel(image: nil, title: "Pee on the card", isSelected: false)]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setup()
    }
    
    private func setup()
    {
        circleViews.forEach
        {
            $0.makeViewCircular()
        }
        tabsCollectionView.registerFromNib(ActivateCardTabsCollectionViewCell.self)
        tabsCollectionView.delegate = self
        tabsCollectionView.dataSource = self

    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        onDimiss()
    }
    
    @IBAction func onCloseButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
     */
}

/*
extension TipInstuctionsViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width * 0.48, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ActivateCardTabsCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.config(viewModel: viewModels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.viewModels[0].isSelected = false
        self.viewModels[1].isSelected = false
        self.viewModels[indexPath.item].isSelected = true
        self.tipsViews[0].isHidden = true
        self.tipsViews[1].isHidden = true
        self.tipsViews[indexPath.item].isHidden = false
        tabsCollectionView.reloadData()
    }
}
*/

//
//  DietPreferencesViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/7/22.
//

import UIKit

class DietPreferencesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.fadeOut()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width * 0.5, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Diets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: FoodFilterCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.titleLabel.text = Diets[indexPath.row].name
        /*
        cell.config(with: cells[indexPath.item],isGreen: isSignUpFlow)
        cell.toggleSelectAction = { [weak self] in
            guard let self = self, indexPath.item < self.cells.count else { return }
            self.cells[indexPath.item].isSelected.toggle()
            if self.cells[indexPath.item].title == "None of the above"
            {
                self.cells.enumerated().forEach
                { index, cell in
                    if index != indexPath.item
                    {
                        self.cells[index].isSelected = false
                    }
                }
            }
            else
            {
                self.cells[self.cells.count - 1].isSelected = false
            }
            self.collectionView.reloadData()
        }*/
        return cell
    }
}

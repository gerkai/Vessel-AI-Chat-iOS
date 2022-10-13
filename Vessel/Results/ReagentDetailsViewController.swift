//
//  ReagentDetailsViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 10/12/22.
//

import UIKit

class ReagentDetailsViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //print("Content offset: \(scrollView.contentOffset)")
        print("Wellness Score: \(titleLabel.frame.origin.y)")
    }
}

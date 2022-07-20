//
//  TestAfterWakingUpViewController.swift
//  Vessel
//
//  Created by Carson Whitsett on 7/12/22.
//

import UIKit

enum TestAfterWakingUpResult
{
    case TestNow
    case Cancel
}

protocol TestAfterWakingUpViewControllerDelegate
{
    func didAnswerTestAfterWakingUp(result: TestAfterWakingUpResult)
}
class TestAfterWakingUpViewController: UIViewController
{
    @IBOutlet weak var darkenView: UIView!
    @IBOutlet weak var popupView: UIView!
    var delegate: TestAfterWakingUpViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        darkenView.alpha = 0.0
        popupView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // TODO: Add analytics for viewed page
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
        {
            self.darkenView.alpha = 1.0
            self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        completion:
        { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
            {
                self.popupView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            completion:
            { _ in
            }
        }
    }
    
    @IBAction func testNow()
    {
        popOut()
        {
            self.dismiss(animated: false)
            self.delegate?.didAnswerTestAfterWakingUp(result: .TestNow)
        }
    }
    
    func popOut(finished: @escaping() -> Void)
    {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
        { 
            self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        completion:
        { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
            {
                self.popupView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                self.darkenView.alpha = 0.0
            }
            completion:
            { _ in
                finished()
            }
        }
    }
    @IBAction func cancel()
    {
        popOut()
        {
            self.dismiss(animated: false)
            self.delegate?.didAnswerTestAfterWakingUp(result: .Cancel)
        }
    }
}

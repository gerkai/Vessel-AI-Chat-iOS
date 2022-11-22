//
//  LessonStepView.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/22/22.
//

import UIKit

protocol LessonStepViewDelegate: AnyObject
{
    func onStepSelected(id: Int)
}

enum LessonStepViewCheckedState
{
    case selected
    case correct
    case correctUnselected
    case wrong
    case unselected
}

class LessonStepView: UIView
{
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkImage: UIImageView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    
    private var checkedState: LessonStepViewCheckedState = .unselected
    {
        didSet
        {
            switch checkedState
            {
            case .selected:
                backgroundView.backgroundColor = .white
                checkImage.image = UIImage(named: "checkbox_selected")
            case .correct:
                backgroundView.backgroundColor = .backgroundGreen
                checkImage.image = UIImage(named: "checkbox_selected")
            case .correctUnselected:
                backgroundView.backgroundColor = .backgroundGreen
                checkImage.image = UIImage(named: "checkbox_unselected")
            case .wrong:
                backgroundView.backgroundColor = .backgroundRed
                checkImage.image = UIImage(named: "checkbox_selected")
            case .unselected:
                backgroundView.backgroundColor = .whiteAlpha7
                checkImage.image = UIImage(named: "checkbox_unselected")
            }
        }
    }
    
    var id: Int = -1
    private weak var delegate: LessonStepViewDelegate?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit()
    {
        let xibName = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        rootView.fixInView(self)
        rootView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
    }
    
    func setup(title: String, id: Int, checkedState: LessonStepViewCheckedState, delegate: LessonStepViewDelegate?)
    {
        titleLabel.text = title
        self.id = id
        self.checkedState = checkedState
        self.delegate = delegate
    }
    
    func setup(checkedState: LessonStepViewCheckedState)
    {
        self.checkedState = checkedState
    }
    
    @objc
    func onTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        delegate?.onStepSelected(id: self.id)
    }
}

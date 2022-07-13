//
//  SelectionCheckmarkView.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//

import UIKit

protocol SelectionCheckmarkViewDelegate
{
    func didTapCheckmark(_ isChecked: Bool)
}

class SelectionCheckmarkView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    var originalColor: UIColor!
    var delegate: SelectionCheckmarkViewDelegate?
    
    var defaultText: String?
    {
        didSet
        {
            textLabel.text = defaultText
        }
    }
    var isChecked: Bool = false
    {
        didSet
        {
            //if there's a delegate, let it know
            delegate?.didTapCheckmark(isChecked)
            
            //animate checkmark
            UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
            {
                self.checkImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            completion:
            { completed in
                if self.isChecked == true
                {
                    self.checkImage.image = UIImage(named:"checkbox_selected")
                    self.roundedView.backgroundColor = UIColor.white
                }
                else
                {
                    self.checkImage.image = UIImage(named:"checkbox_unselected")
                    self.roundedView.backgroundColor = self.originalColor
                }
                
                UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
                {
                    self.checkImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                completion:
                { completed in
                }
            }
        }
    }
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        
        commonInit()
    }
   
    /// Inherited initializer.
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit()
    {
        Bundle.main.loadNib(.selectionCheckmarkView, owner: self, options: nil)
        addSubview(contentView)
        self.backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalColor = roundedView.backgroundColor
    }
    
    @IBAction func checkmarkPressed()
    {
        isChecked = !isChecked
    }
}

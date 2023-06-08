//
//  SelectionCheckmarkView.swift
//  Vessel
//
//  Created by Carson Whitsett on 3/6/22.
//

import UIKit

protocol SelectionCheckmarkViewDelegate
{
    func didTapCheckmark(_ checkmarkView: SelectionCheckmarkView, _ isChecked: Bool)
}

class SelectionCheckmarkView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    //@IBOutlet weak var maskedView: UIView!
    //@IBOutlet weak var maskedCheckbox: UIImageView!
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
            //animate checkmark
            UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState)
            {
                self.checkImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            completion:
            { completed in
                if self.isChecked == true
                {
                    self.checkImage.image = UIImage(named: "checkbox_selected")
                    if self.originalColor == nil
                    {
                        self.originalColor = self.roundedView.backgroundColor
                    }
                    self.roundedView.backgroundColor = UIColor.white
                }
                else
                {
                    self.checkImage.image = UIImage(named: "checkbox_unselected")
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
        let xibName = String(describing: type(of: self))
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        addSubview(contentView)
        self.backgroundColor = .clear
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        /* hanging on to this in case it's needed in the future
        let image = getImageWithInvertedPixelsOfImage(image: maskedCheckbox.image!)

        //let view = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        //maskedView.isHidden = true
        let mask = CALayer()
        mask.frame = CGRect(x: maskedCheckbox.frame.origin.x + 20, y: maskedCheckbox.frame.origin.y, width: maskedCheckbox.frame.size.width, height: maskedCheckbox.frame.size.height)
        
       // mask.contents = image.cgImage!
        mask.contents = maskedCheckbox.image!.cgImage!
        roundedView.layer.mask = mask
        roundedView.layer.masksToBounds = true*/
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        originalColor = roundedView.backgroundColor
    }
    
    @IBAction func checkmarkPressed()
    {
        isChecked = !isChecked
        //if there's a delegate, let it know
        delegate?.didTapCheckmark(self, isChecked)
    }
    /* hanging on to this in case it's needed in the future
    func getImageWithInvertedPixelsOfImage(image: UIImage) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(), size: image.size)

        UIGraphicsBeginImageContextWithOptions(image.size, false, 2.0)
        UIGraphicsGetCurrentContext()!.setBlendMode(.copy)
        image.draw(in: rect)
        UIGraphicsGetCurrentContext()!.setBlendMode(.sourceOut)
        UIGraphicsGetCurrentContext()!.setFillColor(UIColor.green.cgColor)
        UIGraphicsGetCurrentContext()!.fill(rect)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }*/
}

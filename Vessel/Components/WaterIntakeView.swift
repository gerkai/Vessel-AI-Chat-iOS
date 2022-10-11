//
//  WaterIntakeView.swift
//  Vessel
//
//  Created by Nicolas Medina on 10/6/22.
//

import UIKit

protocol WaterIntakeViewDelegate: AnyObject
{
    func didCheckGlasses(_ glasses: Int)
}

enum WaterIntakeViewType
{
    case normal
    case green
}

@IBDesignable class WaterIntakeView: UIView
{
    // MARK: - View
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var topStackView: UIStackView!
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private var glassButtons: [UIButton]!
    
    // MARK: - Model
    var numberOfGlasses = 18
    {
        didSet
        {
            reloadUI()
        }
    }
    
    var checkedGlasses = 0
    {
        didSet
        {
            reloadUI()
        }
    }
    
    var waterIntakeViewType: WaterIntakeViewType = .normal
    var delegate: WaterIntakeViewDelegate?
    
    override var intrinsicContentSize: CGSize
    {
        var s = super.intrinsicContentSize
        s.height = numberOfGlasses <= Constants.WATER_GLASSESS_PER_ROW ? 45 : 98
        s.width = 335
        return s
    }
    
    override func prepareForInterfaceBuilder()
    {
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Initializers
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
        contentView.fixInView(self)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        reloadUI()
    }
    
    // MARK: - Actions
    @IBAction func onGlassSelected(_ sender: UIButton)
    {
        guard sender.alpha != 0.0 else { return }
        if let index = glassButtons.firstIndex(of: sender)
        {
            if checkedGlasses == index + 1
            {
                checkedGlasses = index
            }
            else
            {
                checkedGlasses = index + 1
            }
            delegate?.didCheckGlasses(checkedGlasses)
            reloadUI()
        }
    }
}

private extension WaterIntakeView
{
    func reloadUI()
    {
        if numberOfGlasses <= Constants.WATER_GLASSESS_PER_ROW
        {
            bottomStackView.isHidden = true
        }
        for (i, glassButton) in glassButtons.enumerated()
        {
            if i < checkedGlasses
            {
                glassButton.setImage(UIImage(named: waterIntakeViewType == .normal ? "water-glass-empty" : "water-glass-empty-green"), for: .normal)
            }
            else if i < numberOfGlasses
            {
                glassButton.setImage(UIImage(named: "water-glass-full"), for: .normal)
            }
            else
            {
                glassButton.alpha = 0.0
            }
            glassButton.setTitle("", for: .normal)
        }
    }
}

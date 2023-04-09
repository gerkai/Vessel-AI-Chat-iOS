//
//  CheckMarkCardView.swift
//  Vessel
//
//  Created by Nicolas Medina on 11/28/22.
//

import UIKit

protocol CheckMarkCardViewDelegate: AnyObject
{
    func onLessonSelected(id: Int)
}

class CheckMarkCardView: UIView
{
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var checkMark: UIImageView!
    
    var id: Int?
    weak var delegate: CheckMarkCardViewDelegate?
    
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
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onInsightSelected)))
    }
    
    func setup(id: Int, title: String, subtitle: String, description: String, backgroundImage: String, completed: Bool, delegate: CheckMarkCardViewDelegate?)
    {
        self.delegate = delegate
        self.id = id
        titleLabel.text = title
        subtitleLabel.text = subtitle
        descriptionLabel.text = description
        checkMark.image = completed ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
        guard let url = URL(string: backgroundImage) else
        {
            assertionFailure("CheckMarkCardView-setup: backgroundImage not a valid URL")
            return
        }
        backgroundImageView.kf.setImage(with: url)
    }
    
    public func setCompleted(completed: Bool)
    {
        checkMark.image = completed ? UIImage(named: "Checkbox_beige_selected") : UIImage(named: "Checkbox_beige_unselected")
    }
    
    @objc
    private func onInsightSelected(gestureRecognizer: UITapGestureRecognizer)
    {
        guard let delegate = delegate,
              let id = id else { return }
        delegate.onLessonSelected(id: id)
    }
}

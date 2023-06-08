//
//  DashboardStaffCell.swift
//  Vessel
//
//  Created by Nicolas Medina on 5/25/23.
//

import UIKit
import Kingfisher

class DashboardStaffCell: UIView
{
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quizesLabel: UILabel!
    @IBOutlet private weak var salesLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var testLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    
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
    }
    
    func setup(staff: Staff, index: Int, isCurrentUser: Bool)
    {
        if let lastName = staff.last_name
        {
            nameLabel.text = (staff.first_name ?? "") + " " + String((lastName).first ?? Character("")) + "."
        }
        else
        {
            nameLabel.text = (staff.first_name ?? "") + "."
        }
        quizesLabel.text = "\(staff.quizzes_completed ?? 0)"
        salesLabel.text = "\(staff.sales ?? 0)"
        testLabel.text = "\(staff.tests_completed ?? 0)"
        indexLabel.text = "\(index + 1)"
        indexLabel.backgroundColor = index == 0 ? .gold : index == 1 ? .silver : index == 2 ? .bronze : .grayColor
        contentView.backgroundColor = isCurrentUser ? .backgroundGreen : .white
        guard let imageUrl = staff.image_url, let url = URL(string: imageUrl) else
        {
            imageView.image = UIImage(named: "Logo")
            imageView.backgroundColor = .black
            return
        }
        imageView.kf.setImage(with: url)
    }
}

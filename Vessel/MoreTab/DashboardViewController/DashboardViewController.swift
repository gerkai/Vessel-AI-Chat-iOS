//
//  DashboardViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 5/23/23.
//

import UIKit
import Fastis

class DashboardViewController: UIViewController
{
    @IBOutlet private weak var dashboardStackView: UIStackView!
    @IBOutlet private weak var signupsLabel: UILabel!
    @IBOutlet private weak var quizesLabel: UILabel!
    @IBOutlet private weak var testsLabel: UILabel!
    @IBOutlet private weak var salesLabel: UILabel!
    @IBOutlet private weak var dashboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var pickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pickerContainerView: UIView!
    
    private lazy var viewModel = DashboardViewModel(expertId: expertId, reloadUI: self.setupView)
    var expertId: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pickerViewBottomConstraint.constant = -pickerContainerView.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPickerSelected))
        gestureRecognizer.numberOfTapsRequired = 1
        filterLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Actions
    
    @IBAction func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPickerSelected()
    {
        UIView.animate(withDuration: 0.3, delay: 0.0)
        {
            self.pickerViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onPickerDone()
    {
        UIView.animate(withDuration: 0.3, delay: 0.0)
        {
            self.pickerViewBottomConstraint.constant = -self.pickerContainerView.frame.height
            self.view.layoutIfNeeded()
        }
        viewModel.selectedPickerOptionIndex = pickerView.selectedRow(inComponent: 0)
        if viewModel.selectedPickerOptionIndex == 4
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.presentDatePicker()
            })
        }
        else
        {
            viewModel.loadLeaderboard()
        }
    }
    
    // MARK: - Initialization
    func setupView()
    {
        DispatchQueue.main.async
        {
            self.updateUI()
            self.updateDashboardUI()
            
            self.view.layoutIfNeeded()
        }
    }
    
    func updateUI()
    {
        DispatchQueue.main.async
        {
            self.filterLabel.text = "For \(self.viewModel.selectedPickerOption)"
            self.signupsLabel.text = "\(self.viewModel.leaderboard?.totalSignups ?? 0)"
            self.quizesLabel.text = "\(self.viewModel.leaderboard?.totalQuizesCompleted ?? 0)"
            self.testsLabel.text = "\(self.viewModel.leaderboard?.totalTestsCompleted ?? 0)"
            self.salesLabel.text = "\(self.viewModel.leaderboard?.totalSales ?? 0)"
        }
    }
    
    func updateDashboardUI()
    {
        DispatchQueue.main.async
        {
            self.dashboardStackView.removeAllArrangedSubviews()
            self.dashboardHeightConstraint.constant = CGFloat(self.viewModel.ranking.count * 76) + CGFloat(20 * (self.viewModel.ranking.count - 1))
            
            for (index, staff) in self.viewModel.ranking.enumerated()
            {
                let cell = DashboardStaffCell()
                if let staffId = Contact.main()?.staff_id
                {
                    cell.setup(staff: staff, index: index, isCurrentUser: staffId == staff.staff_id)
                }
                else if let expertId = Contact.main()?.expert_id
                {
                    cell.setup(staff: staff, index: index, isCurrentUser: expertId == staff.staff_id)
                }
                else
                {
                    cell.setup(staff: staff, index: index, isCurrentUser: false)
                }
                
                self.dashboardStackView.addArrangedSubview(cell)
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: 76.0)
                ])
            }
        }
    }
    
    private func presentDatePicker()
    {
        var customConfig = FastisConfig.default
        customConfig.dayCell.selectedBackgroundColor = .backgroundGreen
        customConfig.dayCell.selectedLabelColor = .black
        customConfig.dayCell.onRangeBackgroundColor = .backgroundLightGreen
        customConfig.dayCell.dateLabelFont = Constants.FontTitleRegular16
        
        customConfig.currentValueView.textFont = Constants.FontTitleBold18
        customConfig.currentValueView.placeholderTextForRanges = "Custom Date Range"
        customConfig.currentValueView.placeholderTextColor = .black

        customConfig.controller.barButtonItemsColor = .backgroundGreen
        
        customConfig.monthHeader.labelFont = Constants.FontTitleBold16
        
        let fastisController = FastisController(mode: .range, config: customConfig)
        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = false
        fastisController.doneHandler = { resultRange in
            self.viewModel.setDates(startDate: resultRange?.fromDate, endDate: resultRange?.toDate)
            self.viewModel.loadLeaderboard()
        }
        fastisController.present(above: self)
    }
}

extension DashboardViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return viewModel.pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return viewModel.pickerOptions[row]
    }
}

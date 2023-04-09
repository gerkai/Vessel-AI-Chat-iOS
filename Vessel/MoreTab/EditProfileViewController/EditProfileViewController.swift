//
//  EditProfileViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 7/27/22.
//

import UIKit
import IQKeyboardManagerSwift

enum EditProfileContactField
{
    case name
    case lastName
    case gender
    case height
    case weight
    case birthDate
}

enum EditProfileAction
{
    case changeProfilePhoto
    case changePassword
    case requestDeleteAccount
    case editContact(type: EditProfileContactField, value: Any)
}

class EditProfileViewController: KeyboardFriendlyViewController, VesselScreenIdentifiable
{
    // MARK: - Views
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var nameTextField: VesselTextField!
    @IBOutlet private weak var lastNameTextField: VesselTextField!
    @IBOutlet private weak var emailTextField: VesselTextField!
    @IBOutlet private weak var genderSegmentedControl: VesselSegmentedControl!
    @IBOutlet private weak var heightTextField: VesselTextField!
    @IBOutlet private weak var weightTextField: VesselTextField!
    @IBOutlet private weak var birthDateTextField: VesselTextField!
    @IBOutlet private weak var profileImageButton: UIButton!
    @IBOutlet private weak var passwordView: UIView!
    
    private var profileImageView = UIImageView()
    
    private lazy var heightPickerView: UIPickerView =
    {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var birthDatePicker: UIDatePicker =
    {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        datePicker.datePickerMode = .date
        if #available(iOS 14, *)
        {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    
    // MARK: Model
    private lazy var viewModel: EditProfileViewModel =
    {
        let viewModel = EditProfileViewModel()
        viewModel.onModelChanged = self.updateUI
        viewModel.onError = self.onError
        return viewModel
    }()
    
    @Resolved internal var analytics: Analytics
    let flowName: AnalyticsFlowName = .moreTabFlow
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailTextField.isEnabled = false
        heightTextField.inputView = heightPickerView
        birthDateTextField.inputView = birthDatePicker
        birthDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        setDatePickerMinMaxValues()
        setDatePickerInitialValue()
        setupImageView()
        hideChangePasswordIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        updateUI()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 70.0
        IQKeyboardManager.shared.toolbarTintColor = .grayText
        IQKeyboardManager.shared.placeholderColor = .grayText
        
        setupTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10.0
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        setupView()
    }
    
    // MARK: - Actions
    @IBAction func onBackButtonPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChangeProfilePhoto()
    {
        handle(action: .changeProfilePhoto)
    }
    
    @IBAction func onChangePassword()
    {
        handle(action: .changePassword)
    }
    
    @IBAction func onDeleteAccount()
    {
        handle(action: .requestDeleteAccount)
    }
    
    @IBAction func onGenderControlChanged()
    {
        handle(action: .editContact(type: .gender, value: genderSegmentedControl.selectedSegmentIndex))
    }
    
    @objc func handleDatePicker(sender: UIDatePicker)
    {
        birthDateTextField.text = "\(NSLocalizedString("Born", comment: "")) \(viewModel.localDateFormatter.string(from: sender.date).replacingOccurrences(of: "-", with: "/"))"
    }
    
    // MARK: - Public functions
    func updateUI()
    {
        nameTextField.text = viewModel.name
        lastNameTextField.text = viewModel.lastName
        emailTextField.text = viewModel.email
        genderSegmentedControl.selectedSegmentIndex = viewModel.gender ?? 0
        heightTextField.text = viewModel.height
        weightTextField.text = viewModel.weight
        birthDateTextField.text = (viewModel.contactFlags & Constants.DECLINED_BIRTH_DATE == 1) ? nil : viewModel.birthDateString
    }
    
    func onError(_ error: String)
    {
        UIView.showError(text: "", detailText: error)
    }
}

// MARK: - Private methods
private extension EditProfileViewController
{
    func setupView()
    {
        var heightInfoText = ""
        var weightInfoText = ""
        if viewModel.isMetric
        {
            weightInfoText = NSLocalizedString("KG", comment: "Abbreviation for Kilograms")
            heightInfoText = NSLocalizedString("CM", comment: "Abbreviation for height in 'centimeters'")
            setHeightForPickerView(centimeters: viewModel.heightForPickerView().0)
        }
        else
        {
            heightInfoText = NSLocalizedString("FT", comment: "Abbreviation for Feet")
            weightInfoText = NSLocalizedString("LBS", comment: "Abbreviation for Feet")
            let heightForPickerView = viewModel.heightForPickerView()
            self.setHeightForPickerView(feet: heightForPickerView.0, inches: heightForPickerView.1)
        }
        
        let heightInfoButton = createInfoButton(text: heightInfoText, parentFrame: heightTextField.frame)
        heightTextField.addSubview(heightInfoButton)
        
        let weightInfoButton = createInfoButton(text: weightInfoText, parentFrame: weightTextField.frame)
        weightTextField.addSubview(weightInfoButton)
        
        heightPickerView.subviews[safe: 1]?.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func setupTextFields()
    {
        let textFieldsFont = UIFont(name: "NoeText-Book", size: 16.0)
        let textFieldsColor: UIColor = .grayText
        nameTextField.font = textFieldsFont
        nameTextField.textColor = textFieldsColor
        lastNameTextField.font = textFieldsFont
        lastNameTextField.textColor = textFieldsColor
        emailTextField.font = textFieldsFont 
        emailTextField.textColor = textFieldsColor
        heightTextField.font = textFieldsFont
        heightTextField.textColor = textFieldsColor
        weightTextField.font = textFieldsFont
        weightTextField.textColor = textFieldsColor
        birthDateTextField.font = textFieldsFont
        birthDateTextField.textColor = textFieldsColor
    }
    
    func setupImageView()
    {
        profileImageView.image = UIImage(named: "Logo")?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = .black
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.frame = CGRect(x: 23.0, y: 23.0, width: 50.0, height: 50.0)
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.addSubview(profileImageView)
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = profileImageButton.frame.size.height / 2
        profileImageButton.layer.masksToBounds = false
    }
    
    func hideChangePasswordIfNeeded()
    {
        if viewModel.shouldHidePassword
        {
            passwordView.isHidden = true
        }
    }
    
    func createInfoButton(text: String, parentFrame: CGRect) -> UIButton
    {
        let infoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 57, height: 33))
        infoButton.setTitle(text, for: .normal)
        infoButton.isUserInteractionEnabled = false
        infoButton.backgroundColor = .blackAlpha5
        infoButton.layer.cornerRadius = 15
        infoButton.layer.masksToBounds = true
        infoButton.titleLabel?.font = UIFont(name: "BananaGrotesk-Semibold", size: 13.0)
        infoButton.frame.origin = CGPoint(x: parentFrame.width - infoButton.frame.width - 15.0, y: (parentFrame.height - infoButton.frame.height) / 2.0)
        return infoButton
    }
    
    func handle(action: EditProfileAction)
    {
        switch action
        {
        case .changeProfilePhoto:
            // TODO: Route to Change Profile Photo and add page viewed analytics
            break
        case .changePassword:
            let storyboard = UIStoryboard(name: "MoreTab", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
            navigationController?.pushViewController(vc, animated: true)
        case .requestDeleteAccount:
            GenericAlertViewController.presentAlert(in: self,
                                                    type: .titleSubtitleButton(title: GenericAlertLabelInfo(title: "Delete Account?", alignment: .left),
                                                                               subtitle: GenericAlertLabelInfo(title: "Are you sure you would like to delete your Vessel account? If you delete your account you will permanently lose all of your past test results, activites and progress.This action cannot be reversed.", height: 130.0),
                                                                               button: GenericAlertButtonInfo(label: GenericAlertLabelInfo(title: "Delete Account"), type: .dark)),
                                                    description: GenericAlertViewController.DELETE_ACCOUNT_ALERT,
                                                    showCloseButton: true,
                                                    alignment: .bottom,
                                                    animation: .modal,
                                                    delegate: self)
        case .editContact(let type, let value):
            if Reachability.isConnectedToNetwork()
            {
                switch type
                {
                case .name:
                    guard let name = value as? String else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't parse name value to String")
                        return
                    }
                    viewModel.name = name
                case .lastName:
                    guard let lastName = value as? String else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't parse lastName value to String")
                        return
                    }
                    viewModel.lastName = lastName
                case .gender:
                    guard let gender = value as? Int else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't parse gender value to Int")
                        return
                    }
                    viewModel.gender = gender
                case .height:
                    guard let height = value as? String else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't parse height value to String")
                        return
                    }
                    viewModel.height = height
                case .weight:
                    guard let weight = value as? String else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't parse weight value to String")
                        return
                    }
                    viewModel.weight = weight
                case .birthDate:
                    guard let birthDate = value as? String else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't parse birthDate value to String")
                        return
                    }
                    let strings = birthDate.split(separator: " ")
                    guard let dateString = strings[safe: 1] else
                    {
                        assertionFailure("EditProfileViewController-handle.editContact: Couldn't get dateString from splitting of birthDate")
                        return
                    }
                    let date = viewModel.localDateFormatter.date(from: String(dateString))
                    viewModel.birthDate = date
                }
            }
            else
            {
                UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
            }
        }
    }
    
    func getSelections() -> Double
    {
        if viewModel.isMetric
        {
            let centimeters = Double(heightPickerView.selectedRow(inComponent: HeightComponentMetric.centimeters.rawValue) + Constants.MIN_HEIGHT_METRIC)
            return centimeters
        }
        else
        {
            let feet = Double(heightPickerView.selectedRow(inComponent: HeightComponentImperial.feet.rawValue))
            let inches = Double(heightPickerView.selectedRow(inComponent: HeightComponentImperial.inches.rawValue))
            let feetCentimeters = Measurement(value: feet, unit: UnitLength.feet).converted(to: UnitLength.centimeters)
            let inchesCentimeters = Measurement(value: inches, unit: UnitLength.inches).converted(to: UnitLength.centimeters)
            let result = feetCentimeters + inchesCentimeters
            return result.value
        }
    }
    
    func setHeightForPickerView(centimeters: Int)
    {
        if viewModel.isMetric
        {
            if centimeters > Constants.MAX_HEIGHT_METRIC
            {
                heightPickerView.selectRow(Constants.MAX_HEIGHT_METRIC - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
            else if centimeters < Constants.MIN_HEIGHT_METRIC
            {
                heightPickerView.selectRow(Constants.MIN_HEIGHT_METRIC - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
            else
            {
                heightPickerView.selectRow(centimeters - Constants.MIN_HEIGHT_METRIC, inComponent: HeightComponentMetric.centimeters.rawValue, animated: false)
            }
        }
    }
    
    func setHeightForPickerView(feet: Int, inches: Int)
    {
        if !viewModel.isMetric
        {
            let (minFeet, _) = viewModel.getMinHeightImperial()
            
            //some old users have 0' for height. Added this to prevent crash bug
            var heightFeet = feet
            if heightFeet < minFeet
            {
                heightFeet = minFeet
            }
            heightPickerView.selectRow(heightFeet - minFeet, inComponent: HeightComponentImperial.feet.rawValue, animated: false)
            heightPickerView.selectRow(inches, inComponent: HeightComponentImperial.inches.rawValue, animated: false)
        }
    }
    
    func setDatePickerMinMaxValues()
    {
        viewModel.minDateComponents = viewModel.calendar.dateComponents([.day, .month, .year], from: Date())
        viewModel.maxDateComponents = viewModel.calendar.dateComponents([.day, .month, .year], from: Date())
        if let year = viewModel.minDateComponents.year,
           let month = viewModel.minDateComponents.month,
           let day = viewModel.minDateComponents.day
        {
            viewModel.minDateComponents.year = year - viewModel.minAge
            viewModel.minDateComponents.month = month
            viewModel.minDateComponents.day = day
            if let date = viewModel.calendar.date(from: viewModel.minDateComponents)
            {
                viewModel.maxDate = date
            }
        }
        if let year = viewModel.maxDateComponents.year
        {
            viewModel.maxDateComponents.year = abs(viewModel.maxAge - year)
            if let date = viewModel.calendar.date(from: viewModel.maxDateComponents)
            {
                viewModel.minDate = date
            }
        }
        birthDatePicker.minimumDate = viewModel.minDate
        birthDatePicker.maximumDate = viewModel.maxDate
    }
    
    func setDatePickerInitialValue()
    {
        if let birthDate = viewModel.birthDate
        {
            birthDatePicker.setDate(birthDate, animated: false)
        }
    }
}

// MARK: - TextField Delegates
extension EditProfileViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) // if implemented, called in place of textFieldDidEndEditing:
    {
        if reason == .committed
        {
            guard let contactField = getContactField(textField),
                  let value = textField.text else { return }
            handle(action: .editContact(type: contactField, value: value))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == heightTextField || textField == weightTextField
        {
            guard !(textField.text ?? "").contains(".") || string != "." else { return false }
            let characterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            return string == string.components(separatedBy: characterSet).joined(separator: "")
        }
        return true
    }
    
    private func getContactField(_ textField: UITextField) -> EditProfileContactField?
    {
        if textField == nameTextField
        {
            return .name
        }
        if textField == lastNameTextField
        {
            return .lastName
        }
        else if textField == heightTextField
        {
            return .height
        }
        else if textField == weightTextField
        {
            return .weight
        }
        else if textField == birthDateTextField
        {
            return .birthDate
        }
        return nil
    }
}

// MARK: - UIPicker Delegate and DataSource

extension EditProfileViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        if viewModel.isMetric
        {
            return HeightComponentMetric.allCases.count
        }
        else
        {
            return HeightComponentImperial.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if viewModel.isMetric
        {
            return Constants.MAX_HEIGHT_METRIC - Constants.MIN_HEIGHT_METRIC
        }
        else
        {
            let heightComponent = HeightComponentImperial(rawValue: component)
            let (minFeet, _) = viewModel.getMinHeightImperial()
            let (maxFeet, _) = viewModel.getMaxHeightImperial()
            
            switch heightComponent
            {
                case .feet:
                    return maxFeet - minFeet + 1
                case .inches:
                    return 12
                default:
                    return 0
            }
        }
    }
}

extension EditProfileViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if viewModel.isMetric
        {
            return String(format: NSLocalizedString("%i cm", comment: "abbreviation for height in 'centimeters'"), row + Constants.MIN_HEIGHT_METRIC)
        }
        else
        {
            let heightComponent = HeightComponentImperial(rawValue: component)
            let (minFeet, minInches) = viewModel.getMinHeightImperial()
            
            switch heightComponent
            {
                case .feet:
                    return String(format: NSLocalizedString("%i ft", comment: "abbreviation for height in 'feet'"), row + minFeet)
                case .inches:
                    return String(format: NSLocalizedString("%i in", comment: "abbreviation for height in 'inches'"), row + minInches)
                default:
                    return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if viewModel.isMetric
        {
            let height = Double(heightPickerView.selectedRow(inComponent: HeightComponentMetric.centimeters.rawValue) + Constants.MIN_HEIGHT_METRIC)
            heightTextField.text = String(format: "%.0f", height)
        }
        else
        {
            let (minFeet, _) = viewModel.getMinHeightImperial()
            
            let feet = Int(heightPickerView.selectedRow(inComponent: HeightComponentImperial.feet.rawValue)) + minFeet
            let inches = Int(heightPickerView.selectedRow(inComponent: HeightComponentImperial.inches.rawValue))
            heightTextField.text = "\(feet)'\(inches)\""
        }
    }
}

extension EditProfileViewController: GenericAlertDelegate
{
    func onAlertPresented(_ alert: GenericAlertViewController, alertDescription: String)
    {
        if alertDescription == GenericAlertViewController.DELETE_ACCOUNT_ALERT
        {
            analytics.log(event: .viewedPage(screenName: "DeleteAccountPopupViewController", flowName: self.flowName))
        }
    }
    
    func onAlertButtonTapped(_ alert: GenericAlertViewController, index: Int, alertDescription: String)
    {
        if alertDescription == GenericAlertViewController.DELETE_ACCOUNT_ALERT
        {
            if Reachability.isConnectedToNetwork()
            {
                Server.shared.deleteAccount()
                {
                    self.analytics.log(event: .accountDeleted)
                    Server.shared.logOut()
                    let story = UIStoryboard(name: "Login", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "Welcome")
                    
                    //set Welcome screen as root viewController. This causes MainViewController to get deallocated.
                    UIApplication.shared.windows.first?.rootViewController = vc
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                } onFailure: { error in
                    print(error)
                }
            }
            else
            {
                UIView.showError(text: "", detailText: Constants.INTERNET_CONNECTION_STRING, image: nil)
            }
        }
    }
    
    func onAlertDismissed(_ alert: GenericAlertViewController, alertDescription: String)
    {
        analytics.log(event: .viewedPage(screenName: String(describing: type(of: self)), flowName: self.flowName))
    }
}

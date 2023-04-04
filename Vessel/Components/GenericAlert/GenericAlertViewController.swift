//
//  GenericAlertViewController.swift
//  Vessel
//
//  Created by Nicolas Medina on 8/2/22.
//

import UIKit

class GenericAlertViewController: UIViewController
{
    // MARK: - Alerts Constants
    static let DELETE_ACCOUNT_ALERT = "DeleteAccountAlert"
    static let GAMIFICATION_CONGRATULATIONS_ALERT = "GamificationCongratulationsAlert"
    
    private struct Constants
    {
        static let GENERIC_ALERT_BOTTOM_SPACING = 35.0
        static let NOT_SELECTED = -1
    }
    
    static func presentAlert(in viewController: UIViewController,
                             type: GenericAlertType,
                             description: String = "",
                             background: GenericAlertBackground = .cream,
                             showCloseButton: Bool = false,
                             alignment: GenericAlertAlignment = .center,
                             animation: GenericAlertAnimation = .popUp,
                             shouldCloseWhenButtonTapped: Bool = true,
                             shouldCloseWhenTappedOutside: Bool = true,
                             showConfetti: Bool = false,
                             delegate: GenericAlertDelegate? = nil)
    {
        let viewModel = GenericAlertViewModel(type: type,
                                              description: description,
                                              background: background,
                                              showCloseButton: showCloseButton,
                                              alignment: alignment,
                                              animation: animation,
                                              shouldCloseWhenButtonTapped: shouldCloseWhenButtonTapped,
                                              shouldCloseWhenTappedOutside: shouldCloseWhenTappedOutside,
                                              showConfetti: showConfetti)
        let alert = GenericAlertViewController(viewModel: viewModel)
        alert.modalPresentationStyle = .overFullScreen
        let bounds = viewController.view.frame
        alert.preferredContentSize = CGSize(width: bounds.width, height: bounds.height)
        alert.delegate = delegate
        viewController.present(alert, animated: false, completion: {
            NSLayoutConstraint.activate([
                alert.view.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: 1.0),
                alert.view.heightAnchor.constraint(equalTo: viewController.view.heightAnchor, multiplier: 1.0),
            ])
        })
    }
    
    // MARK: - Views
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var backgroundBlur: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var alertViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private var alertViewTopSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var alertViewBottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var buttons: [BounceButton]!
    @IBOutlet private weak var horizontalButtonsStackView: UIStackView!
    @IBOutlet private weak var confettiImageView: UIImageView!
    @IBOutlet private weak var confettiTopConstraint: NSLayoutConstraint!
    
    // MARK: Model
    private var viewModel: GenericAlertViewModel!
    private var delegate: GenericAlertDelegate?
    private let buttonCloseAnimationDelay = 0.3
    private var screenHeight: CGFloat
    {
        return UIScreen.main.bounds.height
    }
    
    // MARK: Flags
    private var alertSetup = false
    private var alertPresented = false
    private var layedOut = false
    
    // MARK: Initializers
    init(viewModel: GenericAlertViewModel)
    {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        commonInitializer()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        self.viewModel = GenericAlertViewModel(type: .title(text: GenericAlertLabelInfo(title: "")), description: "")
        commonInitializer()
    }
    
    func commonInitializer()
    {
        let xibName = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(view)
        viewDidLoad()
    }
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if !layedOut && alertPresented
        {
            layedOut = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if self.viewModel.showConfetti
                {
                    self.confettiTopConstraint.constant = self.view.window?.windowScene?.windows.first?.frame.height ?? 0
                    UIView.animate(withDuration: 2.0, delay: 0.0)
                    {
                        self.view.layoutIfNeeded()
                    }
                completion:
                    { completed in
                        self.confettiTopConstraint.constant = -400
                        self.view.layoutIfNeeded()
                    }
                }
            })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentView.alpha = 0.0
        switch viewModel.animation
        {
        case .popUp:
            alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        case .modal:
            alertViewCenterYConstraint.constant = screenHeight
            alertViewTopSpacingConstraint.isActive = false
            alertViewBottomSpacingConstraint.isActive = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        backgroundBlur.blur(radius: 5.44)
        setupStackView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        setupView()
        
        if !alertPresented
        {
            alertPresented = true
            switch viewModel.animation
            {
            case .popUp:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
                { [weak self] in
                    self?.contentView.alpha = 1.0
                    self?.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
                completion:
                { [weak self] _ in
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
                    {
                        self?.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
                    completion:
                    { _ in
                        guard let self = self else { return }
                        self.delegate?.onAlertPresented?(self, alertDescription: self.viewModel.description)
                    }
                }
            case .modal:
                let constant = viewModel.alignment == .center ? 0 : ((screenHeight - (alertView.frame.height)) / 2.0) - 35
                alertViewCenterYConstraint.constant = constant
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut)
                { [weak self] in
                    guard let self = self else { return }
                    self.contentView.alpha = 1.0
                    self.view.layoutIfNeeded()
                }
                completion:
                { [weak self] _ in
                    guard let self = self else { return }
                    self.alertViewTopSpacingConstraint = NSLayoutConstraint(item: self.view!,
                                                                            attribute: .top,
                                                                            relatedBy: .greaterThanOrEqual,
                                                                            toItem: self.alertView,
                                                                            attribute: .top,
                                                                            multiplier: 1.0,
                                                                            constant: 0.0)
                    self.alertViewTopSpacingConstraint.isActive = true
                    self.alertViewTopSpacingConstraint.priority = .init(rawValue: 900)

                    self.alertViewBottomSpacingConstraint = NSLayoutConstraint(item: self.view!,
                                                                            attribute: .bottom,
                                                                            relatedBy: .greaterThanOrEqual,
                                                                            toItem: self.alertView,
                                                                            attribute: .bottom,
                                                                            multiplier: 1.0,
                                                                            constant: 0.0)
                    self.alertViewBottomSpacingConstraint.isActive = true
                    self.alertViewBottomSpacingConstraint.priority = .init(rawValue: 900)
                    self.delegate?.onAlertPresented?(self, alertDescription: self.viewModel.description)
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc
    func onBackgroundTapped(alertButtonIndexTapped: Int = Constants.NOT_SELECTED)
    {
        if viewModel.animation == .popUp
        {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
            { [weak self] in
                self?.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            completion:
            { [weak self] _ in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut)
                {
                    self?.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    self?.contentView.alpha = 0.0
                }
                completion:
                { [weak self] _ in
                    guard let self = self else { return }
                    if alertButtonIndexTapped != Constants.NOT_SELECTED && self.viewModel.shouldCloseWhenButtonTapped
                    {
                        self.delegate?.onAlertButtonTapped?(self, index: alertButtonIndexTapped, alertDescription: self.viewModel.description)
                    }
                    self.delegate?.onAlertDismissed?(self, alertDescription: self.viewModel.description)
                    self.dismiss(animated: false)
                }
            }
        }
        else
        {
            self.alertViewCenterYConstraint.constant = screenHeight
            alertViewTopSpacingConstraint.isActive = false
            alertViewBottomSpacingConstraint.isActive = false

            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn)
            { [weak self] in
                self?.view.layoutIfNeeded()
                self?.contentView.alpha = 0.0
            }
            completion:
            { [weak self] _ in
                guard let self = self else { return }
                if alertButtonIndexTapped != Constants.NOT_SELECTED && self.viewModel.shouldCloseWhenButtonTapped
                {
                    self.delegate?.onAlertButtonTapped?(self, index: alertButtonIndexTapped, alertDescription: self.viewModel.description)
                }
                self.delegate?.onAlertDismissed?(self, alertDescription: self.viewModel.description)
                self.dismiss(animated: false)
            }
        }
    }
    
    @IBAction func onCloseButtonTapped()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + buttonCloseAnimationDelay, execute: { [weak self] in
            self?.onBackgroundTapped()
        })
    }
    
    @objc
    func onButtonTapped(sender: BounceButton)
    {
        if let index = buttons.firstIndex(of: sender)
        {
            if viewModel.shouldCloseWhenButtonTapped
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + buttonCloseAnimationDelay, execute: { [weak self] in
                    self?.onBackgroundTapped(alertButtonIndexTapped: index)
                })
            }
            else
            {
                delegate?.onAlertButtonTapped?(self, index: index, alertDescription: viewModel.description)
            }
        }
        else if let index = horizontalButtonsStackView.arrangedSubviews.firstIndex(of: sender)
        {
            if viewModel.shouldCloseWhenButtonTapped
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + buttonCloseAnimationDelay, execute: { [weak self] in
                    self?.onBackgroundTapped(alertButtonIndexTapped: index)
                })
            }
            else
            {
                delegate?.onAlertButtonTapped?(self, index: index, alertDescription: viewModel.description)
            }
        }
    }
}

extension GenericAlertViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        let point = gestureRecognizer.location(in: contentView)
        guard let viewTouched = contentView.hitTest(point, with: nil) else { return false }
        return viewTouched == contentView
    }
}

// MARK: - Private methods
private extension GenericAlertViewController
{
    func setupView()
    {
        if !viewModel.showCloseButton
        {
            closeButton.isHidden = true
        }
        
        if viewModel.shouldCloseWhenTappedOutside
        {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped))
            gestureRecognizer.delegate = self
            contentView.addGestureRecognizer(gestureRecognizer)
        }
        
        if viewModel.alignment == .bottom
        {
            alertViewTopSpacingConstraint.isActive = false
            alertViewBottomSpacingConstraint.isActive = false
            alertViewCenterYConstraint.constant = ((screenHeight - (alertView.frame.height * 100)) / 2.0) - Constants.GENERIC_ALERT_BOTTOM_SPACING
        }
        
        if viewModel.background == .green
        {
            alertView.backgroundColor = .backgroundGreen
        }
    }
    
    func setupButton(_ button: BounceButton?, withInfo info: GenericAlertButtonInfo)
    {
        guard let button = button else { return }
        setupLabel(button.titleLabel, withInfo: info.label)
        button.setTitle(info.label.title, for: .normal)
        if let image = info.image
        {
            button.setImage(image, for: .normal)
        }
        
        switch info.type
        {
        case .dark:
            button.backgroundColor = .codGray
        case .gray:
            button.backgroundColor = .transparentCodGray
        case .clear:
            button.backgroundColor = .white
            button.setTitleColor(.codGray, for: .normal)
        case .plain:
            button.backgroundColor = .clear
            button.layer.masksToBounds = false
            button.setTitleColor(.codGray, for: .normal)
            let underline = UIView()
            underline.backgroundColor = button.titleColor(for: .normal)
            underline.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(underline)
            guard let titleLabel = button.titleLabel else { return }
            NSLayoutConstraint.activate([
                underline.heightAnchor.constraint(equalToConstant: 1.0),
                underline.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, constant: 0.0),
                underline.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0.0),
                underline.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.0),
            ])
        }
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    func setupLabel(_ label: UILabel?, withInfo info: GenericAlertLabelInfo)
    {
        guard let label = label else { return }
        label.text = info.title
        
        if let attributedString = info.attributedString
        {
            label.attributedText = attributedString
        }
        else
        {
            if let font = info.font
            {
                label.font = font
            }
            if let color = info.color
            {
                label.textColor = color
            }
            if let numberLines = info.numberLines
            {
                label.numberOfLines = numberLines
            }
            if let lineBreak = info.lineBreak
            {
                label.lineBreakMode = lineBreak
            }
            if let alignment = info.alignment
            {
                label.textAlignment = alignment
            }
        }
        
        if let height = info.height
        {
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
    
    func setupStackView()
    {
        if !alertSetup
        {
            alertSetup = true
            switch viewModel.type
            {
            case .title(let textInfo):
                setupLabel(titleLabel, withInfo: textInfo)
                buttons.forEach({ $0.isHidden = true})
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                horizontalButtonsStackView.isHidden = true
            case .titleButton(let textInfo, let buttonInfo):
                setupLabel(titleLabel, withInfo: textInfo)
                setupButton(buttons.first, withInfo: buttonInfo)
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                horizontalButtonsStackView.isHidden = true
            case .titleButtons(let titleInfo, let buttonsInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupVerticalButtons(buttonsInfo: buttonsInfo)
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                horizontalButtonsStackView.isHidden = true
            case .titleHorizontalButtons(let titleInfo, let buttonsInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                buttons.forEach({ $0.isHidden = true})
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                setupHorizontalButtons(buttonsInfo: buttonsInfo)
            case .titleSubtitle(let titleInfo, let subtitleInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                buttons.forEach({ $0.isHidden = true})
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.isHidden = true
                horizontalButtonsStackView.isHidden = true
            case .titleSubtitleButton(let titleInfo, let subtitleInfo, let buttonInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupButton(buttons.first, withInfo: buttonInfo)
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.isHidden = true
                horizontalButtonsStackView.isHidden = true
            case .titleSubtitleButtons(let titleInfo, let subtitleInfo, let buttonsInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupVerticalButtons(buttonsInfo: buttonsInfo)
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.isHidden = true
                horizontalButtonsStackView.isHidden = true
            case .titleSubtitleHorizontalButtons(let titleInfo, let subtitleInfo, let buttonsInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                buttons.forEach({ $0.isHidden = true})
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.isHidden = true
                setupHorizontalButtons(buttonsInfo: buttonsInfo)
            case .imageTitleSubtitleButton(let image, let titleInfo, let subtitleInfo, let buttonInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupButton(buttons.first, withInfo: buttonInfo)
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.image = image
                horizontalButtonsStackView.isHidden = true
            case .imageTitleSubtitleButtons(let image, let titleInfo, let subtitleInfo, let buttonsInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupVerticalButtons(buttonsInfo: buttonsInfo)
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.image = image
                horizontalButtonsStackView.isHidden = true
            case .imageTitleSubtitleHorizontalButtons(let image, let titleInfo, let subtitleInfo, let buttonsInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                buttons.forEach({ $0.isHidden = true})
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.image = image
                setupHorizontalButtons(buttonsInfo: buttonsInfo)
            case .imageTitleButton(let image, let titleInfo, let buttonInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupButton(buttons.first, withInfo: buttonInfo)
                subtitleLabel.isHidden = true
                imageView.image = image
                horizontalButtonsStackView.isHidden = true
            case .imageSubtitleButton(let image, let subtitleInfo, let buttonInfo):
                titleLabel.isHidden = true
                setupButton(buttons.first, withInfo: buttonInfo)
                setupLabel(subtitleLabel, withInfo: subtitleInfo)
                imageView.image = image
                horizontalButtonsStackView.isHidden = true
            case .titleCustomView(let titleInfo, let view):
                setupLabel(titleLabel, withInfo: titleInfo)
                buttons.forEach({ $0.isHidden = true})
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                setupCustomView(view)
                horizontalButtonsStackView.isHidden = true
            case .titleCustomViewButton(let titleInfo, let view, let buttonInfo):
                setupLabel(titleLabel, withInfo: titleInfo)
                setupButton(buttons.first, withInfo: buttonInfo)
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                setupCustomView(view)
                horizontalButtonsStackView.isHidden = true
            case .customView(let view):
                titleLabel.isHidden = true
                buttons.forEach({ $0.isHidden = true})
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                setupCustomView(view)
                horizontalButtonsStackView.isHidden = true
            case .customViewButton(let view, let buttonInfo):
                titleLabel.isHidden = true
                setupButton(buttons.first, withInfo: buttonInfo)
                subtitleLabel.isHidden = true
                imageView.isHidden = true
                setupCustomView(view)
                horizontalButtonsStackView.isHidden = true
            }
            
            view.layoutIfNeeded()
        }
    }
    
    func setupVerticalButtons(buttonsInfo: [GenericAlertButtonInfo])
    {
        guard buttonsInfo.count > 0 else { return }
        setupButton(buttons.first, withInfo: buttonsInfo[0])
        for i in stride(from: 1, to: buttonsInfo.count, by: 1)
        {
            let button = BounceButton()
            button.setupView()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont(name: "BananaGrotesk-Semibold", size: 16.0)
            stackView.addArrangedSubview(button)
            buttons.append(button)
            setupButton(button, withInfo: buttonsInfo[i])
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 60.0),
                button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0)
            ])
            button.layer.cornerRadius = 22.0
            button.layer.masksToBounds = true
        }
    }
    
    func setupHorizontalButtons(buttonsInfo: [GenericAlertButtonInfo])
    {
        guard buttonsInfo.count > 0 else { return }
        setupButton(horizontalButtonsStackView.arrangedSubviews.first as? BounceButton, withInfo: buttonsInfo[0])
        for i in stride(from: 1, to: buttonsInfo.count, by: 1)
        {
            let button = BounceButton()
            button.setupView()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont(name: "BananaGrotesk-Semibold", size: 16.0)
            horizontalButtonsStackView.addArrangedSubview(button)
            setupButton(button, withInfo: buttonsInfo[i])
            button.layer.cornerRadius = 22.0
            button.layer.masksToBounds = true
        }
    }
    
    func setupCustomView(_ view: UIView)
    {
        stackView.insertArrangedSubview(view, at: stackView.arrangedSubviews.count - 1)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: 40),
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -20)
        ])
    }
}

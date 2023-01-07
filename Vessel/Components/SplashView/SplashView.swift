//
//  SplashView.swift
//  Vessel
//
//  Created by Carson Whitsett on 12/9/22.
//
//  Splash View defaults to invisible (alpha = 0).  Call set(visible:true) to turn on

import UIKit
import Lottie

protocol SplashViewDelegate: AnyObject
{
    func splashAnimationFinished()
}

class SplashView: UIView
{
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var animationContainerView: UIView!
    @IBOutlet private weak var contentView: UIView!
    
    let activityIndicatorAppearanceInterval = 4.0 //Seconds
    
    var animationView: LottieAnimationView!
    weak var delegate: SplashViewDelegate?
    var timer: Timer!
    var activityTimer: Timer!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(showSplashScreen), name: .showSplashScreen, object: nil)
        
        animationView = .init(name: "splash_animation")
        animationView!.frame = animationContainerView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.0
        animationContainerView.addSubview(animationView!)
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("✳️ \(self)")
        }
        startActivityTimer()
    }
    
    deinit
    {
        if UserDefaults.standard.bool(forKey: Constants.KEY_PRINT_INIT_DEINIT)
        {
            print("❌ \(self)")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func startActivityTimer()
    {
        print("Splash View start activity timer")
        activityTimer = Timer.scheduledTimer(timeInterval: activityIndicatorAppearanceInterval, target: self, selector: #selector(showActivityIndicator), userInfo: nil, repeats: false)
    }
    
    func playAnimation()
    {
        print("Splash View start animation")
        animationView!.play
        {(isFinished) in
            if isFinished
            {
                self.delegate?.splashAnimationFinished()
            }
        }
    }
    
    @objc func showActivityIndicator()
    {
        activityIndicatorView.startAnimating()
    }
    
    func set(visible: Bool)
    {
        if visible == true
        {
            isHidden = false
            contentView.alpha = 1.0
        }
        else
        {
            isHidden = true
        }
    }
    
    //response to .showSplashScreen notification. "show" should be true or false to show or hide.
    //"fade", if true will do a 1.0S fade, otherwise if missing or false the screen will show/hide instantly.
    @objc func showSplashScreen(_ notification: NSNotification)
    {
        var fadeTime = 0.1
        if let shouldFade = notification.userInfo?["fade"] as? Bool
        {
            if shouldFade == true
            {
                fadeTime = 1.0
            }
        }
        if let shouldShow = notification.userInfo?["show"] as? Bool
        {
            //print("Got showSplash notification: show: \(shouldShow), fade: \(fadeTime)")
            if shouldShow == true
            {
                isHidden = false
                UIView.animate(withDuration: fadeTime)
                {
                    self.contentView.alpha = 1.0
                }
                completion:
                { done in
                    self.playAnimation()
                }
            }
            else
            {
                UIView.animate(withDuration: fadeTime)
                {
                    self.contentView.alpha = 0.0
                }
                completion:
                { done in
                    self.isHidden = true
                }
            }
        }
        else
        {
            //print("Got showSplash notification: Don't Show, fade: \(fadeTime)")
            UIView.animate(withDuration: fadeTime)
            {
                self.contentView.alpha = 0.0
            }
        }
    }
}

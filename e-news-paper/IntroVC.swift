//
//  IntroVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 6/4/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import SwiftyOnboard

let mySpecialNotificationKey = "com.simpumind.e-news-paper"

protocol IntroVCDelegate {
    func closeVC()
}

class IntroVC: UIViewController, IntroVCDelegate {
    
    func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissVC() {
        dismiss(animated: false, completion: nil)
    }
    

    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0.5921568627, green: 0.3843137255, blue: 0.6431372549, alpha: 1),#colorLiteral(red: 0.2156862745, green: 0.7254901961, blue: 0.937254902, alpha: 1),#colorLiteral(red: 0.7215686275, green: 0.7333333333, blue: 0.7294117647, alpha: 1)]
    var titleArray: [String] = ["E-News Paper", "E-News Paper", "E-News Paper"]
    var subTitleArray: [String]?
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(setTexts(notification:)), name: kNotificationLanguageChanged, object: nil)
        UIApplication.shared.statusBarStyle = .lightContent
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissVC), name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)
        
    }
    
    func setTexts(notification:NSNotification) {
        if notification.name == kNotificationLanguageChanged {
            configureView()
        }
    }

func configureView(){
    subTitleArray = [Localization("firstText"), Localization("secondText"), Localization("thirdText")]
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !SetLanguage("French_fr") {
            changeLanguage()
        }
    }
    
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    func handleFinish(){
        let log = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumberViewController
        let loginVc = UINavigationController(rootViewController: log)
        present(loginVc, animated: true, completion: nil)
    }
}

extension IntroVC: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 3
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        let imgIndex = index  + 1
        view.imageView.image = UIImage(named: "a\(imgIndex)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "Lato-Heavy", size: 22)
        view.subTitle.font = UIFont(name: "Lato-Regular", size: 16)
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray?[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont(name: "Lato-Heavy", size: 16)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continue", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
            overlay.continueButton.removeTarget(self, action: #selector(handleFinish), for: .touchUpInside)
            overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        } else {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            overlay.continueButton.removeTarget(self, action: #selector(handleContinue), for: .touchUpInside)
            overlay.continueButton.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
            overlay.skipButton.isHidden = true
        }
    }
    
    func changeLanguage(){
        
        Localisator.sharedInstance.saveInUserDefaults = true
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Default Language", preferredStyle: .alert)
        
        let attributedString = NSAttributedString(string: "", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15), //your font here
            NSForegroundColorAttributeName : UIColor.black
            ])
        
        optionMenu.setValue(attributedString, forKey: "attributedTitle")
        
        let englishAction = UIAlertAction(title: "English", style: .default, handler: nil)
        
        let frenchAction = UIAlertAction(title: "French", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if SetLanguage("French_fr") {
                let alert = UIAlertView(title: nil, message: Localization("languageChangedWarningMessage"), delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                self.viewDidLoad()
            }
        })
        
        optionMenu.addAction(englishAction)
        optionMenu.addAction(frenchAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}



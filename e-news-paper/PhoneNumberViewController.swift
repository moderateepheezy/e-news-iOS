//
//  LoginVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 4/8/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

public protocol PhoneNumberViewControllerDelegate {
    func phoneNumberViewController(_ phoneNumberViewController: PhoneNumberViewController, didEnterPhoneNumber phoneNumber: String)
    func phoneNumberViewControllerDidCancel(_ phoneNumberViewController: PhoneNumberViewController)
}

public final class PhoneNumberViewController: UIViewController, CountriesViewControllerDelegate, NVActivityIndicatorViewable{
    public class func standardController() -> PhoneNumberViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumberViewController
    }
    
    
    @IBOutlet weak var goButton: UIButton!
    
    
    @IBOutlet weak public var countryButton: UIButton!
    @IBOutlet weak public var countryTextField: UITextField!
    @IBOutlet weak public var phoneNumberTextField: UITextField!
    
    @IBOutlet public var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet public var doneBarButtonItem: UIBarButtonItem!
    
    public var cancelBarButtonItemHidden = false { didSet { setupCancelButton() } }
    public var doneBarButtonItemHidden = false { didSet { setupDoneButton() } }
    
    fileprivate func setupCancelButton() {
        if let cancelBarButtonItem = cancelBarButtonItem {
            navigationItem.leftBarButtonItem = cancelBarButtonItemHidden ? nil: cancelBarButtonItem
        }
    }
    
    fileprivate func setupDoneButton() {
        if let doneBarButtonItem = doneBarButtonItem {
            navigationItem.rightBarButtonItem = doneBarButtonItemHidden ? nil: doneBarButtonItem
        }
    }
    
    @IBOutlet weak public var backgroundTapGestureRecognizer: UITapGestureRecognizer!
    
    public var delegate: PhoneNumberViewControllerDelegate?
    
    public var phoneNumber: String? {
        if let countryText = countryTextField.text, let phoneNumberText = phoneNumberTextField.text, !countryText.isEmpty && !phoneNumberText.isEmpty {
            return countryText + phoneNumberText
        }
        return nil
    }
    
    public var country = Country.currentCountry
    
    //MARK: Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = true
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                navigationController?.navigationBar.shadowImage = UIImage()
        
        setupCancelButton()
        setupDoneButton()
        
        updateCountry()
        
        goButton.layer.cornerRadius = goButton.frame.height / 2
        
        //phoneNumberTextField.becomeFirstResponder()
    }
    

    
    @IBAction fileprivate func changeCountry(_ sender: UIButton) {
        let countriesViewController = CountriesViewController.standardController()
        countriesViewController.delegate = self
        countriesViewController.cancelBarButtonItemHidden = true
        
        countriesViewController.selectedCountry = country
        countriesViewController.majorCountryLocaleIdentifiers = ["GB", "US", "IT", "DE", "RU", "BR", "IN"]
        
        navigationController?.pushViewController(countriesViewController, animated: true)
    }
    
    public func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) { }
    
    public func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        navigationController?.popViewController(animated: true)
        self.country = country
        updateCountry()
    }
    
    @IBAction fileprivate func textFieldDidChangeText(_ sender: UITextField) {
        if let countryText = sender.text, sender == countryTextField {
            country = Countries.countryFromPhoneExtension(countryText)
        }
        updateTitle()
    }
    
    fileprivate func updateCountry() {
        countryTextField.text = country.phoneExtension
        updateCountryTextField()
        updateTitle()
    }
    
    fileprivate func updateTitle() {
        updateCountryTextField()
        if countryTextField.text == "+" {
            countryButton.setTitle("Select From List", for: UIControlState())
        } else {
            countryButton.setTitle(country.name, for: UIControlState())
        }
        
        var title = ""
        if let newTitle = phoneNumber  {
            title = newTitle
        }
        navigationItem.title = title
        
        validate()
    }
    
    fileprivate func updateCountryTextField() {
        if countryTextField.text == "+" {
            countryTextField.text = ""
        }
        else if let countryText = countryTextField.text, !countryText.hasPrefix("+") && !countryText.isEmpty {
            countryTextField.text = "+" + countryText
        }
    }
    
    @IBAction fileprivate func done(_ sender: UIBarButtonItem) {
        if !countryIsValid || !phoneNumberIsValid {
            return
        }
        if let phoneNumber = phoneNumber {
            delegate?.phoneNumberViewController(self, didEnterPhoneNumber: phoneNumber)
        }
    }
    
    @IBAction fileprivate func cancel(_ sender: UIBarButtonItem) {
        delegate?.phoneNumberViewControllerDidCancel(self)
    }
    
    @IBAction fileprivate func tappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: Validation
    public var countryIsValid: Bool {
        if let countryCodeLength = countryTextField.text?.length {
            return country != Country.emptyCountry && countryCodeLength > 1 && countryCodeLength < 5
        }
        return false
    }
    
    public var phoneNumberIsValid: Bool {
        if let phoneNumberLength = phoneNumberTextField.text?.length {
            return phoneNumberLength > 5 && phoneNumberLength < 15
        }
        return false
    }
    @IBAction func goButtonTapped(_ sender: Any) {
        
        guard let number = phoneNumber else {
            return
        }
        let first4 = number.substring(to:(number.index((number.startIndex), offsetBy: 4)))
        
        if !countryIsValid || !phoneNumberIsValid {
            print("Not Valid")
            showAlert(message: "Not A Valid Number")
            return
        }else{
            if first4 == "+234" && number.characters.count == 14{
                print("Welcome to Nigeria")
                
                saveMssisdn(msisdn: number)
                
            }else if first4 == "+220" && number.characters.count == 13{
                print("Welcome to Gambia")
            }else{
                
                showAlert(message: "Not yet available for your country")
                print("Not yet available for your country")
            }
        }
        if let phoneNumber = phoneNumber {
            delegate?.phoneNumberViewController(self, didEnterPhoneNumber: phoneNumber)
        }
    }
    
    
    fileprivate func showAlert(message: String){
        let alertController = UIAlertController(title: "E-News", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Re-try", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func validate() {
        _ = countryIsValid
        _ = phoneNumberIsValid
        
       // doneBarButtonItem.isEnabled = validCountry && validPhoneNumber
    }
    
    fileprivate func saveMssisdn(msisdn: String){
        startAnimating(CGSize(width:100, height: 100), type: .ballPulse, color: .white, padding: 30)
        
        print(msisdn)
        
        AppFirRef.subscriberRef.queryOrdered(byChild: "msisdn").queryEqual(toValue: msisdn).observeSingleEvent(of: .value, with: { (snapshot) in
            
        print(snapshot)
            
            if snapshot.childrenCount > 0{
                print(snapshot)
                
                for case let snap as FIRDataSnapshot in snapshot.children{
                    
                    let subscriberKey = snap.key
                    
                    UserDefaults.standard.setUserKey(value: subscriberKey)
                    
                }
                self.goToMain()
            }else{
                print(snapshot)
                let newsubscriber = AppFirRef.subscriberRef.childByAutoId()
                newsubscriber.child("msisdn").setValue(msisdn, withCompletionBlock: { (error, ref) in
    
                    if error != nil{
                        return
                    }
                    
                    UserDefaults.standard.setUserKey(value: newsubscriber.key)
                    self.goToMain()
                })
            }
            
            UserDefaults.standard.setMsisdn(value: msisdn)
        })
    }
    
    private func goToMain(){
        stopAnimating()
        let mainVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab") as! MainTabBarController
        present(mainVc, animated: true, completion: nil)
    }
    
}

private extension String {
    var length: Int {
        return utf16.count
    }
}

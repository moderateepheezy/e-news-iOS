//
//  VerifiyVC.swift
//  e-news-paper
//
//  Created by SimpuMind on 7/11/17.
//  Copyright © 2017 SimpuMind. All rights reserved.
//

import UIKit
import Firebase
import PinCodeTextField
import FirebaseAuth
import NVActivityIndicatorView

class VerifiyVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var pinTextField: PinCodeTextField!
    
    var introVcDelegate: IntroVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinTextField.keyboardType = .numberPad
    }
    
    
    @IBAction func verifyButton(_ sender: Any) {
        
        guard let code = pinTextField.text else {return}
        
        let defaults = UserDefaults.standard
        
        let credentails: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: code)
        
        Auth.auth().signIn(with: credentails) { (user, error) in
            if error != nil {
                print("\(error.debugDescription)")
            }else{
                
                //let userInfo = user?.providerData[0]
                
                self.saveMssisdn(msisdn: (user?.phoneNumber)!)
                self.stopAnimating()
                self.goToMain()
            }
        }
    }
    
    private func goToMain(){
        self.dismiss(animated: false) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: mySpecialNotificationKey), object: nil)
        }
    }
    
    fileprivate func saveMssisdn(msisdn: String){
        startAnimating(CGSize(width:100, height: 100), type: .ballPulse, color: .white, padding: 30)
        print(msisdn)
        
        AppFirRef.subscriberRef.queryOrdered(byChild: "msisdn").queryEqual(toValue: msisdn).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            if snapshot.childrenCount > 0{
                print(snapshot)
                
                for case let snap as DataSnapshot in snapshot.children{
                    
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

}

//
//  AddContact.swift
//  addContact
//
//  Created by ELizabeth Kukla on 8/5/17.
//  Copyright © 2017 ELizabeth Kukla. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts
import MessageUI


class AddContact: UIViewController, MFMessageComposeViewControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBOutlet weak var addContactButton: UIButton!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        addContactButton.layer.cornerRadius = 4
        
        firstName.delegate = self
        lastName.delegate = self
        companyName.delegate = self
        phoneNumber.delegate = self
        emailAddress.delegate = self
        
        if firstName.text!.isEmpty{
            addContactButton.isUserInteractionEnabled = false
            addContactButton.alpha = 0.50
        }
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if firstName.text! != "" {
            addContactButton.isUserInteractionEnabled = true
            addContactButton.alpha = 1
        }
        else {
            addContactButton.isUserInteractionEnabled = false
            addContactButton.alpha = 0.50
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentLocation(_ sender: UIButton){
        let loc = manager.location
        let alertController = UIAlertController(title: "Current Location", message:
            "Your location is: \n \(loc)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true,
                     completion: nil)
    }
    
    @IBAction func saveContact(_ sender: UIButton) {
        let contact = CNMutableContact()
        let loc = manager.location
        
        contact.givenName = firstName.text!
        contact.familyName = lastName.text!
        contact.note = "You added this contact at: \n \(loc)"
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberMain,
            value:CNPhoneNumber(stringValue:phoneNumber.text!))]
        contact.emailAddresses = [CNLabeledValue(
            label:CNLabelHome,
            value: emailAddress.text! as NSString)]

        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        try! store.execute(saveRequest)
        
        
        let alertController = UIAlertController(title: firstName.text! + " " + lastName.text! + " added!", message: "Would you like to send them a text?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler:{ _ in self.afterTextMessage()}))
        alertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default,handler:{ _ in self.sendTextMessage()}))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion:nil)
        
    }
    
    func afterTextMessage() {
        firstName.text = ""
        lastName.text = ""
        companyName.text = ""
        phoneNumber.text = ""
        emailAddress.text = ""
    }
    
    func sendTextMessage(){
        let loc = manager.location
        let controller = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            controller.body = "Hey it's " + UIDevice.current.name + "! \n We met at \(loc) \n\n with Contac+ elizabethkukla.com"
            controller.recipients = [phoneNumber.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            print("SMS services are not availible")
        }
        self.afterTextMessage()
        
    }


}


//
//  SelectLocationViewController.swift
//  addContact
//
//  Created by ELizabeth Kukla on 8/5/17.
//  Copyright © 2017 ELizabeth Kukla. All rights reserved.
//

import UIKit
import CoreLocation
import QuadratTouch


class SelectLocationViewController: UIViewController {
    
    var firstName = ""
    var lastName = ""
    var companyName = ""
    var phoneNumber = ""
    var emailAddress = ""
    
    @IBOutlet weak var testSearchOutput: UITextView!
    var session: Session!
    var location: CLLocation!
    var currentTask: Task?
    var venues: [JSONParameters]!

    
    let manager = CLLocationManager()



    override func viewDidLoad() {
        super.viewDidLoad()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        searchLocations()
        // Do any additional setup after loading the view.
    }
    
    func searchLocations() {
        let loc = manager.location
        let lat_log = "\(String(format: "%f", loc!.coordinate.latitude)) , \(String(format: "%f", loc!.coordinate.longitude))"
        var parameters = [Parameter.ll:lat_log]
        
        self.currentTask?.cancel()
        self.currentTask? = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                self.venues = response["venues"] as? [JSONParameters]
                print(self.venues)
                NSLog("%@", self.venues);
                
                self.testSearchOutput.text = self.venues[0]["name"] as! String
            }
        }
        self.currentTask?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SelectLocationToAddContact") {
            let vc = segue.destination as! AddContact
            vc.PphoneNumber  = phoneNumber
            vc.PfirstName    = firstName
            vc.PlastName     = lastName
            vc.PcompanyName  = companyName
            vc.PemailAddress = emailAddress
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

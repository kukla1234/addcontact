//
//  SelectLocation.swift
//  addContact
//
//  Created by ELizabeth Kukla on 8/6/17.
//  Copyright © 2017 ELizabeth Kukla. All rights reserved.
//

import UIKit
import CoreLocation
import QuadratTouch
import MapKit


typealias JSONParameters = [String: AnyObject]

class SelectLocation: UITableViewController {
    
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
    let distanceFormatter = MKDistanceFormatter()



    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        location = manager.location
        
        session = Session.sharedSession()
        
        updateSearchResults()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! LocationCells
        let venue = venues[(indexPath as NSIndexPath).row]
        print(venue)
        cell.venueNameLabel.text = "test string"//venue["name"] as? String
//        if let venueLocation = venue["location"] as? JSONParameters {
//            var detailText = ""
//            if let distance = venueLocation["distance"] as? CLLocationDistance {
//                detailText = distanceFormatter.string(fromDistance: distance)
//            }
//            if let address = venueLocation["address"] as? String {
//                detailText = detailText +  " - " + address
//            }
//            cell.detailTextLabel?.text = detailText
//        }
        return cell
    }
    
    
    
    
    func updateSearchResults() { //for searchController: UISearchController
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
//        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        
        if self.location == nil {
            return
        }
      
        var parameters = [Parameter.query:"Burgers"]
        parameters += self.location.parameters()
        let searchTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                self.venues = response["venues"] as! [JSONParameters]?
                self.tableView.reloadData()
            }
        }
        searchTask.start()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let venues = self.venues {
            return venues.count
        }
        return 5
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}

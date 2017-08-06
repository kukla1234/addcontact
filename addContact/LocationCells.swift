//
//  LocationCells.swift
//  addContact
//
//  Created by ELizabeth Kukla on 8/6/17.
//  Copyright © 2017 ELizabeth Kukla. All rights reserved.
//

import UIKit

class LocationCells: UITableViewCell {
    
    /** A cell to display venue name, rating and user tip. */
        
    @IBOutlet weak var venueNameLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

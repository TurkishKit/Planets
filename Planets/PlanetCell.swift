//
//  PlanetCell.swift
//  Planets
//
//  Created by Ege Sucu on 14.10.2019.
//  Copyright © 2019 Ege Sucu. All rights reserved.
//

import UIKit

class PlanetCell: UITableViewCell {
    
    
//    IBOutlet variables
    @IBOutlet weak var planetTitle: UILabel!
    @IBOutlet weak var planetDescription: UITextView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

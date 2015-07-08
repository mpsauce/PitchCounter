//
//  CustomPitcherListCell.swift
//  PitchCounter
//
//  Created by Matthew Surowiec on 6/18/15.
//  Copyright (c) 2015 MPS. All rights reserved.
//

import UIKit

class CustomPitcherListCell: UITableViewCell {
    
    @IBOutlet weak var playerNameOutlet: UILabel!
    @IBOutlet weak var totalNumberPitchedOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

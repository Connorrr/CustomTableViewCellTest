//
//  DCAlarmTableViewCell.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 11/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class DCAlarmTableViewCell: UITableViewCell {
    
    let colourSwatchArray = [Colours.aqua, Colours.blue, Colours.mustard, Colours.orange, Colours.purple, Colours.red]

    @IBOutlet weak var alarmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAlarmLabel(time: String){
        setAlarmLabel(time: time, font: UIFont(name: "HelveticaNeue-Thin", size: 24)!)
    }
    
    func setAlarmLabel(time: String, font: UIFont){
        self.alarmLabel.text = time
        self.alarmLabel.font = font
    }
    
    //  Sets the background colour to a specified DC Colour
    func setDCColour(index: Int){
        self.backgroundColor = colourSwatchArray[index % colourSwatchArray.count]
    }
    
}

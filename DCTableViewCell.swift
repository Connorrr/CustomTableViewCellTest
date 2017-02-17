//
//  DCTableViewCell.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 10/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class DCTableViewCell: UITableViewCell {
    
    let colourSwatchArray = [Colours.aqua, Colours.blue, Colours.clear, Colours.mustard, Colours.orange, Colours.purple, Colours.red, Colours.white]
    
    @IBOutlet weak var alarmTime: UILabel!
    
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
        self.alarmTime.text = time
        self.alarmTime.font = font
    }
    
    //  Sets the background colour to a specified DC Colour
    func setDCColour(index: Int) -> UIColor{
        self.backgroundColor = colourSwatchArray[index % colourSwatchArray.count]
        return self.backgroundColor!
    }

}

//
//  DCTableViewCell.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 10/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class DCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alarmTime: UILabel!
    
    convenience override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.init(style: style, reuseIdentifier: reuseIdentifier, colour: UIColor.white)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, colour: UIColor) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = colour
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

}

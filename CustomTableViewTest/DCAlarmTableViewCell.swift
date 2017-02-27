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
    
    let leftShoulder: UIView = UIView(frame: CGRect.zero)
    let rightShoulder: UIView = UIView(frame: CGRect.zero)

    @IBOutlet weak var alarmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("Entered Custom Update Focus")
        super.didUpdateFocus(in: context, with: coordinator)
    }
    
    func setAlarmLabel(time: String){
        setAlarmLabel(time: time, font: UIFont(name: "HelveticaNeue-Thin", size: 24)!)
    }
    
    func setAlarmLabel(time: String, font: UIFont){
        self.alarmLabel.text = time
        self.alarmLabel.font = font
    }
    
    //  Sets the background colour to a specified DC Colour
    func setDCColour(index: Int) -> UIColor{
        backgroundColor = colourSwatchArray[index % colourSwatchArray.count]
        return backgroundColor!
    }
    
    
    /// Sets a swipe gesture recognizer up on the cell
    func initSwipe(){
        let swipeCell = UIPanGestureRecognizer(target: self, action: #selector(self.swipeCellLeft(gestureRecognizer:)))
        self.addGestureRecognizer(swipeCell)
    }
    
    @objc private func swipeCellLeft(gestureRecognizer: UIPanGestureRecognizer){
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self)
            //  Start Pull Down
            print(translation.x)
            self.frame = CGRect(origin: CGPoint(x: translation.x, y: self.frame.origin.y), size: self.frame.size)
        }
    }
    
}

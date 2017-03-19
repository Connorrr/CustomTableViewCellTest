//
//  DCAlarmTableViewCell.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 11/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

protocol DCAlarmTableViewDelegate: class {
    func animateAlarmCellShoulder(yPos: CGFloat, xTranslation: CGFloat, index: Int, cellWidth: CGFloat, cellHeight: CGFloat)
    func returnToCenter(cell: DCAlarmTableViewCell)
}

class DCAlarmTableViewCell: UITableViewCell {
    
    weak var delegate: DCAlarmTableViewDelegate?
    
    var cellIndex: Int?
    
    var restingFrame: CGRect = CGRect.zero

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
        backgroundColor = Globals.rowColours[index % Globals.rowColours.count]
        return backgroundColor!
    }
    
    /// Sets a swipe gesture recognizer up on the cell
    func initSwipe(){
        let swipeCell = UIPanGestureRecognizer(target: self, action: #selector(self.swipeCellLeft(gestureRecognizer:)))
        self.restingFrame = self.frame
        self.addGestureRecognizer(swipeCell)
    }
    
    @objc private func swipeCellLeft(gestureRecognizer: UIPanGestureRecognizer){
        //  Moves the main view in one direction and lets another take its place
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self)
            let xTranslation = translation.x / 2
            self.frame.origin.x = xTranslation
            if ((cellIndex) != nil) {
                delegate?.animateAlarmCellShoulder(yPos: self.frame.origin.y, xTranslation: xTranslation, index: cellIndex!, cellWidth: self.frame.width, cellHeight: self.frame.height)
            }else{
                print("error (DCAlarmTableViewCell): Cell index must exist to animate the shoulder views")
            }
        }else if gestureRecognizer.state == .ended {
            delegate?.returnToCenter(cell: self)
        }
    }
    
}

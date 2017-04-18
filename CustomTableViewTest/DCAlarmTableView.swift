//
//  DCAlarmTableView.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 3/3/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class DCAlarmTableView: UITableView, DCAlarmTableViewDelegate {
    
    var multiplier : CGFloat = 0.0
    
    var shoulderViews : [[UIView]] = []
    var shoulderLayers : [[TableCellShoulderLayer]] = []
    
    var pullLayer : TableCellShoulderLayer? = nil
    
    /// Initializes a left and right shoulderview for each row in the table
    ///
    /// - Parameter numOfRows: number of rows in the table
    func initShoulderVews(numOfRows: Int){
        self.backgroundColor = UIColor.clear
        
        for i in 0..<numOfRows{
            let leftShoulder = UIView()
            let rightShoulder = UIView()
            let leftShoulderLayer : TableCellShoulderLayer
            let rightShoulderLayer : TableCellShoulderLayer
            leftShoulder.backgroundColor = UIColor.clear
            rightShoulder.backgroundColor = UIColor.clear
            shoulderViews.append([leftShoulder, rightShoulder])
            leftShoulderLayer = TableCellShoulderLayer(parentView: shoulderViews[i][0])
            rightShoulderLayer = TableCellShoulderLayer(parentView: shoulderViews[i][1])
            leftShoulderLayer.fillColor = Globals.rowColours[i].cgColor
            rightShoulderLayer.fillColor = Globals.rowColours[i].cgColor
            shoulderLayers.append([leftShoulderLayer, rightShoulderLayer])
            shoulderViews[i][0].layer.addSublayer(shoulderLayers[i][0])
            shoulderViews[i][1].layer.addSublayer(shoulderLayers[i][1])
            self.addSubview(shoulderViews[i][0])
            self.addSubview(shoulderViews[i][1])
        }
    }

    
    /// Delegate function:  Stretches the shoulder views with the horizontal xTranslation value
    ///
    /// - Parameters:
    ///   - yPos: Origin Y position for the shoulder view
    ///   - xTranslation: Translation.x value from the pan geesture
    ///   - index: The cell index in the table view (row number starting from 0)
    ///   - cellWidth: Width of the TableViewCell
    ///   - cellHeight: Height of the TableViewCell
    func animateAlarmCellShoulder(yPos: CGFloat, xTranslation: CGFloat, index: Int, cellWidth: CGFloat, cellHeight: CGFloat){
        
        let maxShoulderSize = cellWidth/4
        if fabs(xTranslation) > maxShoulderSize {
            multiplier = 1.0
        }else{
            multiplier = fabs(xTranslation)/maxShoulderSize
        }
        if xTranslation < 0 {
            shoulderViews[index][1].frame = CGRect(origin: CGPoint(x: xTranslation + cellWidth, y: yPos), size: CGSize(width: fabs(xTranslation), height: cellHeight))
            shoulderLayers[index][1].path = shoulderLayers[index][1].getStretchPath(parentFrame: shoulderViews[index][1].frame, multiplier: multiplier, isLeftShoulder: false).cgPath
        }else if xTranslation > 0 {
            shoulderViews[index][0].frame = CGRect(origin: CGPoint(x: 0.0, y: yPos), size: CGSize(width: fabs(xTranslation), height: cellHeight))
            shoulderLayers[index][0].path = shoulderLayers[index][0].getStretchPath(parentFrame: shoulderViews[index][0].frame, multiplier: multiplier, isLeftShoulder: true).cgPath
        }else {
            shoulderViews[index][0].frame = CGRect(origin: CGPoint(x: 0.0, y: yPos), size: CGSize(width: 0.0, height: cellHeight))
            shoulderViews[index][1].frame = CGRect(origin: CGPoint(x: cellWidth, y: yPos), size: CGSize(width: 0.0, height: cellHeight))
            shoulderLayers[index][0].path = shoulderLayers[index][0].getStretchPath(parentFrame: shoulderViews[index][0].frame, multiplier: multiplier, isLeftShoulder: true).cgPath
            shoulderLayers[index][1].path = shoulderLayers[index][1].getStretchPath(parentFrame: shoulderViews[index][1].frame, multiplier: multiplier, isLeftShoulder: false).cgPath
        }
    }
    
    /// Controls the animation to return the alarm table cell to center
    ///
    /// - Parameter cell: The DCAlarmTableViewCell which centers the shoulder view
    func returnToCenter(cell: DCAlarmTableViewCell){
        if (cell.cellIndex != nil) {
            let index = cell.cellIndex!
            self.shoulderLayers[index][0].path = nil
            self.shoulderLayers[index][1].path = nil
            
            shoulderLayers[index][0].animateSnap(parentFrame: self.shoulderViews[index][0].frame, multiplier: multiplier, isLeftShoulder: true)
            shoulderLayers[index][1].animateSnap(parentFrame: self.shoulderViews[index][1].frame, multiplier: multiplier, isLeftShoulder: false)
            UIView.animate(withDuration: Globals.shoulderSnapAnimationDuration, delay: 0.0, options: .curveLinear, animations: {
                self.shoulderViews[index][0].frame = CGRect(x: 0, y: cell.frame.origin.y, width: 0, height: cell.frame.height)
                self.shoulderViews[index][1].frame = CGRect(x: cell.frame.width, y: cell.frame.origin.y, width: 0, height: cell.frame.height)
                cell.frame = CGRect(origin: CGPoint(x: 0, y: cell.frame.origin.y), size: cell.frame.size)
            }, completion: ({finished in
                self.multiplier = 0.0
                self.shoulderViews[index][0].frame = CGRect(origin: CGPoint(x: 0.0, y: cell.frame.origin.y), size: CGSize(width: 0.0, height: cell.frame.height))
                self.shoulderViews[index][1].frame = CGRect(origin: CGPoint(x: cell.frame.width, y: cell.frame.origin.y), size: CGSize(width: 0.0, height: cell.frame.height))
                self.shoulderLayers[index][0].path = self.shoulderLayers[index][0].getStretchPath(parentFrame: self.shoulderViews[index][0].frame, multiplier: 0.0, isLeftShoulder: true).cgPath
                self.shoulderLayers[index][1].path = self.shoulderLayers[index][1].getStretchPath(parentFrame: self.shoulderViews[index][1].frame, multiplier: 0.0, isLeftShoulder: false).cgPath
            }))
        }else{
            print("error(DCAlarmTableView): index must be non nil for func returnToCenter to operate.")
        }
    }

}

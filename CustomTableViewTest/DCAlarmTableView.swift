//
//  DCAlarmTableView.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 3/3/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class DCAlarmTableView: UITableView, DCAlarmTableViewDelegate {
    
    var shoulderViews : [[UIView]] = []

    func animateAlarmCellShoulder(yPos: CGFloat, xTranslation: CGFloat, index: Int, cellWidth: CGFloat, cellHeight: CGFloat){
        
        print("ShoulderViewsCount: \(shoulderViews.count)")
        
        if xTranslation < 0 {
            shoulderViews[index][1].frame = CGRect(origin: CGPoint(x: xTranslation + cellWidth, y: yPos), size: CGSize(width: fabs(xTranslation), height: cellHeight))
        }else if xTranslation > 0 {
            shoulderViews[index][0].frame = CGRect(origin: CGPoint(x: 0.0, y: yPos), size: CGSize(width: fabs(xTranslation), height: cellHeight))
        }else {
            shoulderViews[index][0].frame = CGRect.zero
            shoulderViews[index][1].frame = CGRect.zero
        }
    }
    
    /// Initializes a left and right shoulderview for each row in the table
    ///
    /// - Parameter numOfRows: number of rows in the table
    func initShoulderVews(numOfRows: Int){
        print("Num of View Array Rows: \(shoulderViews.count)")
        print("numOfRows: \(numOfRows)")

        for i in 0..<numOfRows{
            let leftShoulder = UIView()
            let rightShoulder = UIView()
            leftShoulder.backgroundColor = Colours.blue
            rightShoulder.backgroundColor = Colours.red
            shoulderViews.append([leftShoulder, rightShoulder])
            self.addSubview(shoulderViews[i][0])
            self.addSubview(shoulderViews[i][1])
        }
        print("Num of View Array Rows: \(shoulderViews.count)")
    }

}

//
//  PullDownLayer.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 15/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class PullDownLayer: CAShapeLayer {
    
    var height: CGFloat
    
    fileprivate var splines = [[CGPoint]]()

    func initPoints(tableViewHeight: CGFloat){
        
        let width = frame.width
        
        //  Starting points
        var firstPoint = CGPoint(x: 0.0, y: 0.0)
        var secondPoint = CGPoint(x: width/2, y: 0.0)
        var thirdPoint = CGPoint(x: width, y: 0.0)
        var fourthPoint = CGPoint(x: 0.0, y: 0.0)
        
        let first = [firstPoint, secondPoint, thirdPoint, fourthPoint]
        splines.append(first)
        
        
        
    }
    
    
}

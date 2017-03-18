//
//  TableCellShoulderLayer.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 7/3/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class TableCellShoulderLayer: CAShapeLayer {
    
    var topLeft : CGPoint
    var topLeftShelf : CGPoint
    var topCP : CGPoint
    var topRightShelf : CGPoint
    var topRight : CGPoint
    var bottomRight : CGPoint
    var bottomRightShelf : CGPoint
    var bottomCP : CGPoint
    var bottomLeftShelf : CGPoint
    var bottomLeft : CGPoint
    var parentFrame : CGRect
    
    let shelfBuffer : CGFloat = 8       //  A shelf on the outer edges of the path
    
    init(parentView: UIView){
        parentFrame = parentView.frame
        topLeft = CGPoint(x: 0 - shelfBuffer, y: 0)
        topLeftShelf = CGPoint(x: 0, y: 0)
        topCP = CGPoint(x: parentFrame.width/2, y: 0)
        topRightShelf = CGPoint(x: parentFrame.width, y: 0)
        topRight = CGPoint(x: parentFrame.width + shelfBuffer, y: 0)
        bottomRight = CGPoint(x: parentFrame.width + shelfBuffer, y: parentFrame.height)
        bottomRightShelf = CGPoint(x: parentFrame.width, y: parentFrame.height)
        bottomCP = CGPoint(x: parentFrame.width/2, y: parentFrame.height)
        bottomLeftShelf = CGPoint(x: 0, y: parentFrame.height)
        bottomLeft = CGPoint(x: 0 - shelfBuffer, y: parentFrame.height)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///  Used to update the Control Points based on the parent view frame borders
    private func setNewControlPoints(parentFrame: CGRect){
        self.parentFrame = parentFrame
        topLeft = CGPoint(x: 0 - shelfBuffer, y: 0)
        topLeftShelf = CGPoint(x: 0, y: 0)
        topCP = CGPoint(x: parentFrame.width/2, y: 0)
        topRightShelf = CGPoint(x: parentFrame.width, y: 0)
        topRight = CGPoint(x: parentFrame.width + shelfBuffer, y: 0)
        bottomRight = CGPoint(x: parentFrame.width + shelfBuffer, y: parentFrame.height)
        bottomRightShelf = CGPoint(x: parentFrame.width, y: parentFrame.height)
        bottomCP = CGPoint(x: parentFrame.width/2, y: parentFrame.height)
        bottomLeftShelf = CGPoint(x: 0, y: parentFrame.height)
        bottomLeft = CGPoint(x: 0 - shelfBuffer, y: parentFrame.height)
    }
    
    /// Takes a multiplier value to compute the control points for the shoulder layer
    ///
    /// - parentView:  The layers parent view
    /// - Returns: path for the shoulder layer
    func getStretchPath(parentFrame: CGRect, multiplier: CGFloat, isLeftShoulder: Bool) -> UIBezierPath {
        setNewControlPoints(parentFrame: parentFrame)
        let path = UIBezierPath()
        let topCPY = parentFrame.height * 0.75 * multiplier
        let botCPY = parentFrame.height - parentFrame.height * 0.75 * multiplier
        let cPX: CGFloat = 20
        
        if isLeftShoulder {
            topLeftShelf.y = topCPY / 2
            bottomLeftShelf.y = parentFrame.height - topCPY / 2
        }else{
            topRightShelf.y = topCPY / 2
            bottomRightShelf.y = parentFrame.height - topCPY / 2
        }
        
        if parentFrame.width < cPX * 2 {
            topCP = CGPoint(x: parentFrame.width/2, y: topCPY)
            bottomCP = CGPoint(x: parentFrame.width/2, y: botCPY)
        }else{
            if isLeftShoulder {
                topCP = CGPoint(x: cPX, y: topCPY)
                bottomCP = CGPoint(x: cPX, y: botCPY)
            }else{
                topCP = CGPoint(x: parentFrame.width-cPX, y: topCPY)
                bottomCP = CGPoint(x: parentFrame.width-cPX, y: botCPY)
            }
        }
        
        path.move(to: topLeft)
        path.addLine(to: topLeftShelf)
        path.addQuadCurve(to: topRightShelf, controlPoint: topCP)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomRightShelf)
        path.addQuadCurve(to: bottomLeftShelf, controlPoint: bottomCP)
        path.addLine(to: bottomLeft)
        path.close()
        return path
    }
    
    func animateSnap(parentFrame: CGRect, multiplier: CGFloat, isLeftShoulder: Bool){
        
        let collapsedFrame : CGRect = CGRect(x: 0, y: parentFrame.origin.y, width: 0, height: parentFrame.height)
        
        let currentPath = getStretchPath(parentFrame: parentFrame, multiplier: multiplier, isLeftShoulder: isLeftShoulder).cgPath
        let collapsedPath = getStretchPath(parentFrame: collapsedFrame, multiplier: 0.0, isLeftShoulder: isLeftShoulder).cgPath
        
        let snapAnimation = CABasicAnimation(keyPath: "path")
        snapAnimation.fromValue = currentPath
        snapAnimation.toValue = collapsedPath
        snapAnimation.beginTime = CACurrentMediaTime()
        snapAnimation.duration = Globals.shoulderSnapAnimationDuration
        //snapAnimation.fillMode = kCAFillModeForwards
        //snapAnimation.isRemovedOnCompletion = false
        
        add(snapAnimation, forKey: nil)
    }

}

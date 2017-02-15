//
//  PullDownLayer.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 15/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//
//  Animated pulldown layer to mask a tableview before it is presented.

import UIKit

class PullDownLayer: CAShapeLayer {
    
    var height: CGFloat
    
    fileprivate var splines = [[CGPoint]]()
    
    init(tableViewHeight: CGFloat){
        height = tableViewHeight
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initPoints(){
        
        let width = frame.width
        
        //  Starting points
        var firstPoint = CGPoint(x: 0.0, y: 0.0)
        var secondPoint = CGPoint(x: 0.0, y: 0.0)
        var thirdPoint = CGPoint(x: width/2, y: 0.0)
        var fourthPoint = CGPoint(x: width, y: 0.0)
        var fifthPoint = CGPoint(x: width, y: 0.0)
        
        let first = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(first)
        
        //  Second points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: 0.0)
        thirdPoint = CGPoint(x: width/2, y: height/4)
        fourthPoint = CGPoint(x: width, y: 0.0)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let second = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(second)
        
        //  Third points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: height/2)
        thirdPoint = CGPoint(x: width/2, y: height/2)
        fourthPoint = CGPoint(x: width, y: height/2)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let third = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(third)
        
        //  Fourth points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: height*3/4)
        thirdPoint = CGPoint(x: width/2, y: height*5/8)
        fourthPoint = CGPoint(x: width, y: height*3/4)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(fourth)
        
        //  Fifth points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(fifth)
        
    }
    
    //  Shape 1 Bezier Path
    func getStartingPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[0][0])
        path.addLine(to: splines[0][1])
        path.addLine(to: splines[0][2])
        path.addLine(to: splines[0][3])
        path.addLine(to: splines[0][4])
        path.close()
        return path
    }
    
    //  Shape 2 Bezier Path
    func getSecondPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[1][0])
        path.addCurve(to: splines[1][3], controlPoint1: splines[1][1], controlPoint2: splines[1][2])
        path.addLine(to: splines[1][4])
        path.close()
        return path
    }
    
    //  Shape 3 Bezier Path
    func getThirdPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[2][0])
        path.addLine(to: splines[2][1])
        path.addLine(to: splines[2][2])
        path.addLine(to: splines[2][3])
        path.addLine(to: splines[2][4])
        path.close()
        return path
    }
    
    //  Shape 4 Bezier Path
    func getFourthPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[3][0])
        path.addCurve(to: splines[3][3], controlPoint1: splines[3][1], controlPoint2: splines[3][2])
        path.addLine(to: splines[3][4])
        path.close()
        return path
    }
    
    //  Shape 5 Bezier Path
    func getFifthPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[4][0])
        path.addLine(to: splines[4][1])
        path.addLine(to: splines[4][2])
        path.addLine(to: splines[4][3])
        path.addLine(to: splines[4][4])
        path.close()
        return path
    }
    
    func animate(){
        
        let path1 = getStartingPath().cgPath
        let path2 = getSecondPath().cgPath
        let path3 = getThirdPath().cgPath
        let path4 = getFourthPath().cgPath
        let path5 = getFifthPath().cgPath
        
        //  Animation Durations
        let d1 = 0.3
        let d2 = 0.3
        let d3 = 0.3
        let d4 = 0.4
        
        let startAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        startAnimation.fromValue = path1
        startAnimation.toValue = path2
        startAnimation.beginTime = 0.0
        startAnimation.duration = d1
        
        let secondAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        secondAnimation.fromValue = path2
        secondAnimation.toValue = path3
        secondAnimation.beginTime = startAnimation.beginTime + startAnimation.duration
        secondAnimation.duration = d2
        
        let thirdAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        thirdAnimation.fromValue = path3
        thirdAnimation.toValue = path4
        thirdAnimation.beginTime = secondAnimation.beginTime + secondAnimation.duration
        thirdAnimation.duration = d3
        
        let fourthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        fourthAnimation.fromValue = path4
        fourthAnimation.toValue = path5
        fourthAnimation.beginTime = thirdAnimation.beginTime + thirdAnimation.duration
        fourthAnimation.duration = d4
        
        let shrinkAnimationGroup : CAAnimationGroup = CAAnimationGroup()
        shrinkAnimationGroup.animations = [startAnimation, secondAnimation, thirdAnimation, fourthAnimation]
        shrinkAnimationGroup.duration = fourthAnimation.beginTime + fourthAnimation.duration
        shrinkAnimationGroup.fillMode = kCAFillModeForwards
        shrinkAnimationGroup.isRemovedOnCompletion = false
        add(shrinkAnimationGroup, forKey: nil)
        
    }
}



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
    
    private var height: CGFloat
    private var width: CGFloat
    
    //  Animation Durations
    private let d1: CFTimeInterval = 0.07
    private let d2: CFTimeInterval = 0.07
    private let d3: CFTimeInterval = 0.07
    private let d4: CFTimeInterval = 0.07
    
    var animationDuration: CFTimeInterval
    
    fileprivate var splines = [[CGPoint]]()
    
    
    /// Initialize the pulldown layer with a reference frame
    ///
    /// - Parameter frame: frame should be the same as any views is will cover
    init(frame: CGRect){
        height = frame.height
        width = frame.width
        animationDuration = d1 + d2 + d3 + d4
        super.init()
        self.initPoints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initPoints(){
        
        //print("width: \(width), height \(height)")
        
        //  Starting points
        var firstPoint = CGPoint(x: 0.0, y: 0.0)
        var secondPoint = CGPoint(x: 0.0, y: 1.0)
        var thirdPoint = CGPoint(x: width/2, y: 1.0)
        var fourthPoint = CGPoint(x: width, y: 1.0)
        var fifthPoint = CGPoint(x: width, y: 0.0)
        
        let first = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(first)
        
        //  Second points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: 1.0)
        thirdPoint = CGPoint(x: width/2, y: height/2)
        fourthPoint = CGPoint(x: width, y: 1.0)
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
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height*3/4)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(fourth)
        
        //  Fifth points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height + height/8)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(fifth)
        
        //  Sixth points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(sixth)
        
    }
    
    //  Shape 1 Bezier Path
    private func getStartingPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[0][0])
        path.addLine(to: splines[0][1])
        //path.addLine(to: splines[0][2])
        path.addLine(to: splines[0][3])
        path.addLine(to: splines[0][4])
        path.close()
        return path
    }
    
    //  Shape 2 Bezier Path
    private func getSecondPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[1][0])
        path.addLine(to: splines[1][1])
        path.addQuadCurve(to: splines[1][3], controlPoint: splines[1][2])
        path.addLine(to: splines[1][4])
        path.close()
        return path
    }
    
    //  Shape 3 Bezier Path
    private func getThirdPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[2][0])
        path.addLine(to: splines[2][1])
        //path.addLine(to: splines[2][2])
        path.addLine(to: splines[2][3])
        path.addLine(to: splines[2][4])
        path.close()
        return path
    }
    
    //  Shape 4 Bezier Path
    private func getFourthPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[3][0])
        path.addLine(to: splines[3][1])
        path.addQuadCurve(to: splines[3][3], controlPoint: splines[3][2])
        path.addLine(to: splines[3][4])
        path.close()
        return path
    }
    
    //  Shape 5 Bezier Path
    private func getFifthPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[4][0])
        path.addLine(to: splines[4][1])
        path.addQuadCurve(to: splines[4][3], controlPoint: splines[4][2])
        path.addLine(to: splines[4][4])
        path.close()
        return path
    }
    
    //  Shape 6 Bezier Path
    private func getSixthPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[5][0])
        path.addLine(to: splines[5][1])
        path.addLine(to: splines[5][3])
        path.addLine(to: splines[5][4])
        path.close()
        return path
    }
    
    /// Returns the path for the first stretched ceiling shape based on a multiplier value between 0 - 1
    ///
    /// - Parameter multiplier: multiplier between 0 - 1
    /// - Returns: path to be added to layer
    func getStretchPath(multiplier: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        let cp = CGPoint(x: width/2, y: splines[1][2].y * multiplier)
        path.move(to: splines[1][0])
        path.addLine(to: splines[1][1])
        path.addQuadCurve(to: splines[1][3], controlPoint: cp)
        path.addLine(to: splines[1][4])
        path.close()
        return path
    }
    
    
    /// Animate the pull down
    func animate(){
        
        //let path1 = getStartingPath().cgPath  Starting pather superceded by getStretchPath
        let path2 = getSecondPath().cgPath
        let path3 = getThirdPath().cgPath
        let path4 = getFourthPath().cgPath
        let path5 = getFifthPath().cgPath
        let path6 = getSixthPath().cgPath
        
        let startAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        startAnimation.fromValue = path2
        startAnimation.toValue = path3
        startAnimation.beginTime = 0.0
        startAnimation.duration = d1
        
        let secondAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        secondAnimation.fromValue = path3
        secondAnimation.toValue = path4
        secondAnimation.beginTime = startAnimation.beginTime + startAnimation.duration
        secondAnimation.duration = d2
        
        let thirdAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        thirdAnimation.fromValue = path4
        thirdAnimation.toValue = path5
        thirdAnimation.beginTime = secondAnimation.beginTime + secondAnimation.duration
        thirdAnimation.duration = d3
        
        let fourthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        fourthAnimation.fromValue = path5
        fourthAnimation.toValue = path6
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



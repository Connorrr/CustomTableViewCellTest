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
    var d1: CFTimeInterval = 0.04
    var d2: CFTimeInterval = 0.04
    var d3: CFTimeInterval = 0.04
    var d4: CFTimeInterval = 0.06
    var d5: CFTimeInterval = 0.06
    var d6: CFTimeInterval = 0.06
    
    var animationDuration: CFTimeInterval
    var timeUntilTableIsCovered: CFTimeInterval
    
    /// Animation dimension helper variables
    var bounceHeight: CGFloat
    
    /// The Ideal time for dissolve duration
    var idealDissolveDuration: CFTimeInterval
    
    fileprivate var splines = [[CGPoint]]()
    
    
    /// Initialize the pulldown layer with a reference frame
    ///
    /// - Parameter frame: frame should be the same as any views is will cover
    init(frame: CGRect){
        height = frame.height - 1
        width = frame.width
        timeUntilTableIsCovered = d1 + d2
        idealDissolveDuration = 5.0
        animationDuration = d1 + d2 + d3 + d4
        bounceHeight = height*3/32
        super.init()
        self.addMultiplierToTimes(multiplier: 2.0)
        self.initPoints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addMultiplierToTimes(multiplier: CFTimeInterval){
        d1 = d1 * multiplier
        d2 = d2 * multiplier
        d3 = d3 * multiplier
        d4 = d4 * multiplier
        d5 = d5 * multiplier
        d6 = d6 * multiplier
        animationDuration = d1 + d2 + d3 + d4 + d5 + d6
        timeUntilTableIsCovered = d1 + d2
    }

    private func initPoints(){
        
        //  Starting points
        var firstPoint = CGPoint(x: 0.0, y: 0.0)
        var secondPoint = CGPoint(x: 0.0, y: 20.0)
        var thirdPoint = CGPoint(x: width/2, y: height/2)
        var fourthPoint = CGPoint(x: width, y: 20.0)
        var fifthPoint = CGPoint(x: width, y: 0.0)
        
        let first = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(first)
        
        //  Second points
        firstPoint = CGPoint(x: 0.0, y: 0.0)
        secondPoint = CGPoint(x: 0.0, y: 20.0)
        thirdPoint = CGPoint(x: width/2, y: height/2)
        fourthPoint = CGPoint(x: width, y: 20.0)
        fifthPoint = CGPoint(x: width, y: 0.0)
        
        let second = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(second)
        
        //  Third points
        firstPoint = CGPoint(x: 0.0, y: height/4)
        secondPoint = CGPoint(x: 0.0, y: height/2)
        thirdPoint = CGPoint(x: width/2, y: height/2)
        fourthPoint = CGPoint(x: width, y: height/2)
        fifthPoint = CGPoint(x: width, y: height/4)
        
        let third = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(third)
        
        //  Fourth points
        firstPoint = CGPoint(x: 0.0, y: height/2)
        secondPoint = CGPoint(x: 0.0, y: height*3/4)
        thirdPoint = CGPoint(x: width/2, y: height/2)
        fourthPoint = CGPoint(x: width, y: height*3/4)
        fifthPoint = CGPoint(x: width, y: height/2)
        
        let fourth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(fourth)
        
        //  Fifth points
        firstPoint = CGPoint(x: 0.0, y: height)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: height)
        
        let fifth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(fifth)
        
        //  Sixth points
        firstPoint = CGPoint(x: 0.0, y: height)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height*9/8)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: height)
        
        let sixth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(sixth)
        
        //  Seventh points
        firstPoint = CGPoint(x: 0.0, y: height*7/8)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height*15/16)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: height*7/8)
        
        let seventh = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(seventh)
        
        //  Eighth points
        firstPoint = CGPoint(x: 0.0, y: height)
        secondPoint = CGPoint(x: 0.0, y: height)
        thirdPoint = CGPoint(x: width/2, y: height)
        fourthPoint = CGPoint(x: width, y: height)
        fifthPoint = CGPoint(x: width, y: height)
        
        let eighth = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint]
        splines.append(eighth)
        
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
        path.addQuadCurve(to: splines[2][3], controlPoint: splines[2][2])
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
        path.addQuadCurve(to: splines[5][3], controlPoint: splines[5][2])
        path.addLine(to: splines[5][4])
        path.close()
        return path
    }
    
    //  Shape 7 Bezier Path
    private func getSeventhPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[6][0])
        path.addLine(to: splines[6][1])
        path.addQuadCurve(to: splines[6][3], controlPoint: splines[6][2])
        path.addLine(to: splines[6][4])
        path.close()
        return path
    }
    
    //  Shape 8 Bezier Path
    private func getEighthPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: splines[7][0])
        path.addLine(to: splines[7][1])
        path.addQuadCurve(to: splines[7][3], controlPoint: splines[7][2])
        path.addLine(to: splines[7][4])
        path.close()
        return path
    }
    
    /// Returns the path for the first stretched ceiling shape based on a multiplier value between 0 - 1
    ///
    /// - Parameter multiplier: multiplier between 0 - 1
    /// - Returns: path to be added to layer
    func getStretchPath(multiplier: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        let cp = CGPoint(x: width/2, y: splines[0][2].y * multiplier)
        path.move(to: splines[0][0])
        path.addLine(to: splines[0][1])
        path.addQuadCurve(to: splines[0][3], controlPoint: cp)
        path.addLine(to: splines[0][4])
        path.close()
        return path
    }
    
    
    /// (Animation) Makes the fillColor transition from current to clear
    ///
    /// - Parameter duration: duration of Animation
    func dissolveLayerWithAnimation(duration: CFTimeInterval){
        let dissolveAnimation = CABasicAnimation(keyPath: "fillColor")
        dissolveAnimation.duration = duration
        dissolveAnimation.fromValue = self.fillColor
        dissolveAnimation.toValue = UIColor.clear.cgColor
        dissolveAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        add(dissolveAnimation, forKey: "fillColor")
    }
    
    /// Animate the pull down
    func animate(){
        
        //let path1 = getStartingPath().cgPath  Starting pather superceded by getStretchPath
        let path2 = getSecondPath().cgPath
        let path3 = getThirdPath().cgPath
        let path4 = getFourthPath().cgPath
        let path5 = getFifthPath().cgPath
        let path6 = getSixthPath().cgPath
        let path7 = getSeventhPath().cgPath
        let path8 = getEighthPath().cgPath
        
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
        
        let fifthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        fifthAnimation.fromValue = path6
        fifthAnimation.toValue = path7
        fifthAnimation.beginTime = fourthAnimation.beginTime + fourthAnimation.duration
        fifthAnimation.duration = d5
        
        let sixthAnimation : CABasicAnimation = CABasicAnimation(keyPath: "path")
        sixthAnimation.fromValue = path7
        sixthAnimation.toValue = path8
        sixthAnimation.beginTime = fifthAnimation.beginTime + fifthAnimation.duration
        sixthAnimation.duration = d6
        
        let shrinkAnimationGroup : CAAnimationGroup = CAAnimationGroup()
        shrinkAnimationGroup.animations = [startAnimation, secondAnimation, thirdAnimation, fourthAnimation, fifthAnimation, sixthAnimation]
        shrinkAnimationGroup.duration = sixthAnimation.beginTime + sixthAnimation.duration
        shrinkAnimationGroup.fillMode = kCAFillModeForwards
        shrinkAnimationGroup.isRemovedOnCompletion = false
        add(shrinkAnimationGroup, forKey: nil)
        
    }
    
}



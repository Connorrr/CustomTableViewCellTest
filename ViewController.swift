//
//  ViewController.swift
//  CustomTableViewTest
//
//  Created by Connor Reid on 10/2/17.
//  Copyright © 2017 Connor Reid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    var cellHeight: CGFloat = 66;
    var numTableRows: CGFloat = 3;
    var holderView = UIView()
    var pullDownLayer = PullDownLayer(frame: CGRect.zero)
    var pullDownLayerColour = UIColor.clear
    var isAnimating = false
    var isGesturing = false     //  Flag used to signify when a pan gesture is in progress
    var isPulledDown = false    //  Flag used to tell if the table has been pulled down
    
    // MARK:  Computed Variables
    var tableSize: CGSize {
        return CGSize(width: self.view.frame.width, height: self.cellHeight*self.numTableRows)
    }
    
    var tableViewFrame: CGRect {
        var frame: CGRect
        if isPulledDown {
            frame = CGRect(origin: CGPoint(x: 0.0, y: 20.0), size: tableSize)
        }else{
            frame = CGRect(origin: CGPoint(x: 0.0, y: 20.0 - tableSize.height), size: tableSize)
        }
        return frame
    }
    
    @IBAction func button(_ sender: UIButton) {
        if sender.isSelected {
            print("This is the selected frame origin\(self.tableView.frame.origin)")
            self.tableView.frame = self.tableView.frame.offsetBy(dx: 0.0, dy: self.tableView.frame.height)
            sender.isSelected = false
        }else{
            print("This is the unselected frame origin\(self.tableView.frame.origin)")
            self.tableView.frame = self.tableView.frame.offsetBy(dx: 0.0, dy: -self.tableView.frame.height)
            sender.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = self.cellHeight
        
        setupTableView()
        setupHolderAndLayer()
        
        self.view.isUserInteractionEnabled = true
        self.tableView.isUserInteractionEnabled = true
        
        let panTableView = UIPanGestureRecognizer(target: self, action: #selector(self.panUPDownTable(gestureRecognizer:)))
        self.tableView.addGestureRecognizer(panTableView)
        self.view.addGestureRecognizer(panTableView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DCAlarmTableViewCell", owner: self, options: nil)?.first as! DCAlarmTableViewCell
        self.pullDownLayerColour = cell.setDCColour(index: indexPath.row)
        pullDownLayer.fillColor = pullDownLayerColour.cgColor
        cell.setAlarmLabel(time: "10:23:52")
        return cell
    }
    
    
    /// Function to assign actions to specific pan gestures on the Main View and the TableView.
    /// Passed to a UIGestureRecognizer action
    ///
    /// - Parameter gestureRecognizer: UIPanGestureRecognizer
    func panUPDownTable(gestureRecognizer: UIPanGestureRecognizer){
        if (!isAnimating && !isPulledDown){ //  Not Pulled Down already and not in the process of pulling down
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self.tableView)
                //  Start Pull Down
                if (translation.y < 180 && translation.y > 0){
                    stretchCeiling(stretch: translation.y)
                }else if(translation.y >= 180){     //  Strat animation
                    pullDownAnimation()
                }
            }
            if gestureRecognizer.state == .ended {
                isGesturing = false
                stretchCeiling(stretch: CGFloat(0))
            }
        }else if isPulledDown && !isAnimating{      //  Look for a push up gesture
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self.tableView)
                if translation.y > -90 && translation.y < 0 {
                    manualPushUpTable(yPosChange: translation.y)
                }else if translation.y <= -90 {
                    pushUpAnimationEnd()
                }
            }
            if gestureRecognizer.state == .ended {
                pullDownTableViewAnimationNoBounce()
            }
        }
    }
    
    /// Takes the y value from a Pan gesture translation and stretches the ceiling shape layer accordingly
    func stretchCeiling(stretch: CGFloat){
        pullDownLayer.path = pullDownLayer.getStretchPath(multiplier: stretch / CGFloat(tableView.frame.height)).cgPath
    }
    
    /// Initializes the holderview and its sublayer
    func setupHolderAndLayer(){
        let maskSize = CGSize(width: tableSize.width, height: tableSize.height + 20.0)
        holderView = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: maskSize))
        holderView.backgroundColor = UIColor.clear
        self.view.addSubview(holderView)
        pullDownLayer = PullDownLayer(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: maskSize))
        pullDownLayer.fillColor = pullDownLayerColour.cgColor
        pullDownLayer.backgroundColor = pullDownLayerColour.cgColor
        holderView.layer.addSublayer(pullDownLayer)
    }
    
    
    /// Animates the pulldown view.  Must run setupHolderAndLayer() before.
    func pullDownAnimation(){
        isAnimating = true
        pullDownLayer.animate()
        pullDownTableViewAnimation()
        Timer.scheduledTimer(timeInterval: pullDownLayer.animationDuration, target: self, selector: #selector(self.pullDownAnimationEnd), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: pullDownLayer.timeUntilTableIsCovered, target: self, selector: #selector(self.pullDownAnimationAlmostEnd), userInfo: nil, repeats: false)
    }
    
    
    /// "Disolves" the mask before animation end
    func pullDownAnimationAlmostEnd(){
        //self.pullDownLayer.dissolveLayerWithAnimation(duration: pullDownLayer.timeUntilTableIsCovered)
        //self.tableView.frame = self.tableView.frame.offsetBy(dx: 0.0, dy: self.tableView.frame.height)  //  Move the table down
    }
    
    ///  Executed at the end of the animation
    func pullDownAnimationEnd(){
        isAnimating = false
        isPulledDown = true
        holderView.layer.removeAllAnimations()
        pullDownLayer.removeFromSuperlayer()
        setupHolderAndLayer()
    }
    
    /// While the other pull down animtaions focus on the PullDownLayer, this ones is for the Table
    func pullDownTableViewAnimation(){
        let tableHeight = tableView.frame.height
        self.view.bringSubview(toFront: holderView)
        UIView.animate(withDuration: pullDownLayer.d1, delay: 0.0, options: .curveLinear, animations: {
            self.tableView.frame.origin = CGPoint(x: self.tableView.frame.origin.x, y: 20.0 - tableHeight*3/4)
        }, completion: nil)
        UIView.animate(withDuration: pullDownLayer.d2, delay: pullDownLayer.d1, options: .curveLinear, animations: {
            self.tableView.frame.origin = CGPoint(x: self.tableView.frame.origin.x, y: 20.0 - tableHeight/2)
        }, completion: nil)
        UIView.animate(withDuration:  pullDownLayer.d3, delay: pullDownLayer.d1 + pullDownLayer.d2, options: .curveLinear, animations: {
            self.tableView.frame.origin = CGPoint(x: self.tableView.frame.origin.x, y: 20.0)
        }, completion: nil)

        UIView.animate(withDuration: pullDownLayer.d5, delay: pullDownLayer.d1 + pullDownLayer.d2 + pullDownLayer.d3 + pullDownLayer.d4, options: .curveLinear, animations: {
            self.tableView.frame.origin = CGPoint(x: self.tableView.frame.origin.x, y: 20.0 - tableHeight/8)
        }, completion: nil)
        UIView.animate(withDuration: pullDownLayer.d6, delay: pullDownLayer.d1 + pullDownLayer.d2 + pullDownLayer.d3 + pullDownLayer.d4 + pullDownLayer.d5, options: .curveLinear, animations: {
            self.tableView.frame.origin = CGPoint(x: self.tableView.frame.origin.x, y: 20.0)
        }, completion: nil)
    }
    
    
    /// Just the first part of the pullDownTableViewAnimation animation
    func pullDownTableViewAnimationNoBounce(){
        UIView.animate(withDuration: pullDownLayer.timeUntilTableIsCovered, delay: 0.0, options: .curveLinear, animations: {
            self.tableView.frame.origin = CGPoint(x: self.tableView.frame.origin.x, y: 20.0)
        }, completion:nil)
    }
    
    /// Starts the table being pushed back up
    ///
    /// - Parameter yPosChange: The y transition value taken from the Pan Gesture
    func manualPushUpTable(yPosChange: CGFloat){
        self.tableView.frame.origin = CGPoint(x: tableView.frame.origin.x, y: 20.0 + yPosChange)
    }
    
    
    /// Shifts the table back out of frame
    func pushUpAnimationEnd(){
        isAnimating = true
        UIView.animate(withDuration: 0.1, animations: {
            self.tableView.frame.origin = CGPoint(x: 0.0, y: 20.0 - self.tableSize.height)
        }, completion: {finished in
            self.isAnimating = false
            self.isPulledDown = false
        })
    }
    
    func setupTableView(){
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        tableView.frame = self.tableViewFrame
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

}

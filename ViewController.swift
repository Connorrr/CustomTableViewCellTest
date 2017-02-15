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
    var isAnimating = false
    
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
        setupHolderAndLayer()
        
        self.view.isUserInteractionEnabled = true
        self.tableView.isUserInteractionEnabled = true
        
        let panTableView = UIPanGestureRecognizer(target: self, action: #selector(self.panUPDownTable(gestureRecognizer:)))
        self.tableView.addGestureRecognizer(panTableView)
        self.view.addGestureRecognizer(panTableView)
        
        print(self.tableView.frame.origin)
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
        //print("What dis index eh \(indexPath.row)")
        cell.setDCColour(index: indexPath.row)
        cell.setAlarmLabel(time: "10:23:52")
        self.cellHeight = cell.frame.height
        return cell
    }
    
    
    func panUPDownTable(gestureRecognizer: UIPanGestureRecognizer){
        if (!isAnimating){
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self.tableView)
                //  Start Pull Down
                if (translation.y < 180 && translation.y > 0){
                    stretchCeiling(stretch: translation.y)
                }else if(translation.y >= 180){     //  Strat animation
                    pullDownAnimation()
                }
            }
            if (gestureRecognizer.state == .ended){
                stretchCeiling(stretch: CGFloat(0))
            }
        }
    }
    
    /*
     Takes the y value from a Pan gesture translation and stretches the ceiling 
     shape layer accordingly
     */
    func stretchCeiling(stretch: CGFloat){
        //print("I looked everywhere and this is the only stretch value I could find... \(stretch)\nplease dont hit me like last time.")
        pullDownLayer.path = pullDownLayer.getStretchPath(multiplier: stretch / CGFloat(180)).cgPath
    }
    
    /*
     Initializes the holderview and its sublayer
     */
    func setupHolderAndLayer(){
        let tableSize = CGSize(width: self.view.frame.width, height: self.cellHeight*self.numTableRows)
        holderView = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 20.0), size: tableSize))
        holderView.backgroundColor = UIColor.clear
        self.view.addSubview(holderView)
        pullDownLayer = PullDownLayer(frame: CGRect(origin: CGPoint(x: 0.0, y: 20.0), size: tableSize))
        holderView.layer.addSublayer(pullDownLayer)
    }
    
    /*
     Animates the pulldown view.  Must run setupHolderAndLayer() before.
     */
    func pullDownAnimation(){
        isAnimating = true
        pullDownLayer.animate()
        Timer.scheduledTimer(timeInterval: pullDownLayer.animationDuration, target: self, selector: #selector(self.pullDownAnimationEnd), userInfo: nil, repeats: false)
    }
    
    func pullDownAnimationEnd(){
        isAnimating = false
        holderView.layer.removeAllAnimations()
        pullDownLayer.removeFromSuperlayer()
        setupHolderAndLayer()
    }
    
    func setupTableView(){
        self.tableView.separatorStyle = .none
        let tableSize = CGSize(width: self.view.frame.width, height: self.cellHeight*self.numTableRows)
        self.tableView.isScrollEnabled = false
        tableView.frame = CGRect(origin: CGPoint(x: 0.0, y: 20.0), size: tableSize)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

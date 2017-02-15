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
        setupTableView()
        
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
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.tableView)
            print(translation)
            
        }
        /*print("Oi looks like we gotta swipe dis: \(sender.direction)")
        if gestureRecognizer.direction == .up {
            print("This is the selected frame origin\(self.tableView.frame.origin)")
            self.tableView.frame = self.tableView.frame.offsetBy(dx: 0.0, dy: self.tableView.frame.height)
        }else if (gestureRecognizer.direction == .down){
            print("This is the unselected frame origin\(self.tableView.frame.origin)")
            self.tableView.frame = self.tableView.frame.offsetBy(dx: 0.0, dy: -self.tableView.frame.height)
        }*/
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

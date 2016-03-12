//
//  ViewController.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataArray: [LineChartModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view,
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        let VC = LineChartViewController()
        self.presentViewController(VC, animated: true, completion: nil)
    }
}


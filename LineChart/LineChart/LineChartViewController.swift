//
//  LineChartViewController.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

class LineChartViewController: UIViewController, WDLineChartViewDataSource{
    
    @IBOutlet weak var lineChartView: WDLineChartView!
    var dataArray: [[LineChartDataModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChartView.dataSource = self
        self.loadData()
        self.lineChartView.reloadData()
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadData() {
        let max: UInt32 = 100
        let min: UInt32 = 5
        for i in 0...2 {
            var data: [LineChartDataModel] = []
            for j in 0...9 {
                let lineChartDataModel: LineChartDataModel = LineChartDataModel()
                lineChartDataModel.lineChartData = CGFloat(arc4random_uniform(max - min) + min)
                lineChartDataModel.lineChartColor = i == 0 ? UIColor.redColor() : i == 1 ? UIColor.greenColor() : UIColor.yellowColor()
                lineChartDataModel.lineChartName = "\(i+1)-\(j+1)"
                data.append(lineChartDataModel)
            }
            self.dataArray.append(data)
        }

    }
    
    // datasource
    func lineChartView(lineChartView: WDLineChartView, dataForItemAtLine line: Int) -> [LineChartDataModel] {
        return self.dataArray[line]
    }
    
    func numberOfLinesInLineChartView(lineChartView: WDLineChartView) -> Int {
        return self.dataArray.count
    }
}

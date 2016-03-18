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
//    UIColor.init(red: 104, green: 184, blue: 16, alpha: 1) : i == 1 ? UIColor.init(red: 245, green: 166, blue: 35, alpha: 1) : UIColor.init(red: 20, green: 193, blue: 234, alpha: 1)
    func loadData() {
        let max: UInt32 = 100
        let min: UInt32 = 5
        for i in 0...2 {
            var data: [LineChartDataModel] = []
            for j in 0...9 {
                var lineChartDataModel: LineChartDataModel = LineChartDataModel()
                lineChartDataModel.lineChartData = CGFloat(arc4random_uniform(max - min) + min)
                lineChartDataModel.lineChartColor = i == 0 ? UIColor ( red: 0.6533, green: 0.7664, blue: 0.2395, alpha: 1.0 ) : i == 1 ? UIColor ( red: 0.8885, green: 0.3633, blue: 0.0, alpha: 1.0 ) : UIColor ( red: 0.3087, green: 0.5, blue: 0.8417, alpha: 1.0 )
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

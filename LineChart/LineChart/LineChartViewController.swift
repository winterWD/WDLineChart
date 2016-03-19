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
    var maxYAxisValue: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChartView.dataSource = self
        self.loadData()
        self.lineChartView.reloadData()
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func randomNumber() -> CGFloat {
        let max: UInt32 = 5
        let min: UInt32 = 0
        return CGFloat(arc4random_uniform(max - min))
    }
    
    // fake data
    func loadData() {
        var maxValue: CGFloat  = 1.0
        var datas: [[LineChartDataModel]] = []
        for i in 0...2 {
            var data: [LineChartDataModel] = []
            for j in 0...9 {
                var lineChartDataModel: LineChartDataModel = LineChartDataModel()
                lineChartDataModel.lineChartData = self.randomNumber()
                lineChartDataModel.lineChartColor = i == 0 ? UIColor ( red: 0.6533, green: 0.7664, blue: 0.2395, alpha: 1.0 ) : i == 1 ? UIColor ( red: 0.8885, green: 0.3633, blue: 0.0, alpha: 1.0 ) : UIColor ( red: 0.3087, green: 0.5, blue: 0.8417, alpha: 1.0 )
                lineChartDataModel.lineChartName = "\(i+1)-\(j+1)"
                data.append(lineChartDataModel)
                
                maxValue = max(maxValue, lineChartDataModel.lineChartData)
            }
            datas.append(data)
        }
        self.maxYAxisValue = maxValue
        self.dataArray = datas.reverse()
        self.lineChartView.reloadData()
    }

    // datasource
    
    func maxYAxisValueInLineChartView(lineChartView: WDLineChartView) -> CGFloat {
        return self.maxYAxisValue
    }
    
    func numberOfLinesInLineChartView(lineChartView: WDLineChartView) -> Int {
        return self.dataArray.count
    }
    
    func lineChartView(lineChartView: WDLineChartView, dataForItemAtLine line: Int) -> [LineChartDataModel] {
        return self.dataArray[line]
    }
}

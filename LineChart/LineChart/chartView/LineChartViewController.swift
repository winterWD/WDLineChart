//
//  LineChartViewController.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

class LineChartViewController: UIViewController {

    @IBOutlet weak var lineChartView: WDLineChartView!
    var dataArray: [LineChartModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.loadData()
        
        self.lineChartView.configureData(self.dataArray)
    }
    
    func loadData() {
        let max: UInt32 = 100
        let min: UInt32 = 5
        for index in 0...10 {
            let lineChartModel: LineChartModel = LineChartModel()
            lineChartModel.date = "02-\(index)"
            var data: [LineModel] = []
            for i in 0...1 {
                let model: LineModel = LineModel()
                model.lineColor = i == 0 ? UIColor.redColor() :UIColor.greenColor()
                if index == 0 {
                    model.noStart = true
                    model.curValue = CGFloat(arc4random_uniform(max - min) + min)
                    model.nextValue = CGFloat(arc4random_uniform(max - min) + min)
                }
                else if index == 10 {
                    model.noEnd = true
                    let preModel = (self.dataArray[index - 1] ).lineModels[0] 
                    model.preValue = preModel.curValue
                    model.curValue = preModel.nextValue
                }
                else {
                   let preModel = (self.dataArray[index - 1] ).lineModels[0] 
                    model.preValue = preModel.curValue
                    model.curValue = preModel.nextValue
                    model.nextValue = CGFloat(arc4random_uniform(max - min) + min)
                }
                data.append(model)
            }
            lineChartModel.lineModels = data
            self.dataArray.append(lineChartModel)
        }
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

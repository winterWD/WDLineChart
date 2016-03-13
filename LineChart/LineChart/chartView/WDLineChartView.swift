//
//  WDLineChartView.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

protocol WDLineChartViewDataSource {
    func lineChartViewData(lineChartView: WDLineChartView) -> [LineChartDataModel]
}

class WDLineChartView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataArray: [LineChartModel] = []
    var dataSource: WDLineChartViewDataSource?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.redColor()
        self.setupView()
    }
    
    func setupView() -> Void {
        NSBundle.mainBundle().loadNibNamed("WDLineChartView", owner: self, options: nil)
        self.addSubview(self.view)
        self.collectionView.registerNib(UINib.init(nibName: "WDLineChartCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
    }
    // MARK:
//    func reloadData() -> Void {
//        if let dataSource = self.dataSource?.lineChartViewData(self) {
//            for var index = 0; index < dataSource.count; index++ {
//                let objModel: LineChartDataModel = dataSource[index];
//                let lineChartModel: LineChartModel = LineChartModel()
//                lineChartModel.bottomString = objModel.lineChartName
//                var data: [LineModel] = []
//                for i in 0...2 {
//                    let model: LineModel = LineModel()
//                    model.lineColor = i == 0 ? UIColor.redColor() : i == 1 ? UIColor.greenColor() : UIColor.yellowColor()
//                    if index == 0 {
//                        model.noStart = true
//                        model.curValue =  
//                        model.nextValue =  
//                    }
//                    else if index == 10 {
//                        model.noEnd = true
//                        let preModel = (self.dataArray[index - 1] ).lineModels[i]
//                        model.preValue = preModel.curValue
//                        model.curValue = preModel.nextValue
//                    }
//                    else {
//                        let preModel = (self.dataArray[index - 1] ).lineModels[i]
//                        model.preValue = preModel.curValue
//                        model.curValue = preModel.nextValue
//                        model.nextValue =  
//                    }
//                    data.append(model)
//                }
//                lineChartModel.lineModels = data
//                self.dataArray.append(lineChartModel)
//            }
//        }
//    }
    
    // MARK: 
    func configureData(dataModels: [LineChartModel]) -> Void {
        self.dataArray = dataModels
        self.collectionView.reloadData()
    }
    
    // MARK: collection delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: WDLineChartCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WDLineChartCell
        let cellModel = self.dataArray[indexPath.item]
        cell.drawLineChart(cellModel)
        return cell
    }
}

// 外部一般数据 转为图表数据 入口
class LineChartDataModel {
    var lineChartData: CGFloat! = 0.0
    var lineChartName: String!
}

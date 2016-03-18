//
//  WDLineChartView.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

protocol WDLineChartViewDataSource {
    func lineChartView(lineChartView: WDLineChartView, dataForItemAtLine line: Int) -> [LineChartDataModel]
    func numberOfLinesInLineChartView(lineChartView: WDLineChartView) -> Int
}

class WDLineChartView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataArray: [LineChartModel] = []
    var dataSource: WDLineChartViewDataSource?
    var indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    private func setupView() -> Void {
        NSBundle.mainBundle().loadNibNamed("WDLineChartView", owner: self, options: nil)
        self.addSubview(self.view)
        self.collectionView.registerNib(UINib.init(nibName: "WDLineChartCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    // MARK:
    func reloadData() -> Void {
        
        // 1，将外部数据转为可以划线的model
        if let allData: Array = self.dataConvert() {
            // 2， 将已经转换好的model 进行分组
            if let datas: Array = self.dataGroup(allData) {
                self.configureData(datas)
            }
        }
    }
    
    // 将外部数据转为可以划线的model
    private func dataConvert() -> [[LineModel]] {
        var allData: Array = [[LineModel]()]
        if let lineNumber = self.dataSource?.numberOfLinesInLineChartView(self) {
            allData.removeAll()
            for var lineIndex = 0; lineIndex < lineNumber; lineIndex++ {
                if let dataSource = self.dataSource?.lineChartView(self, dataForItemAtLine: lineIndex) {
                    let maxVaue = self.calculateMaxValueInDatas(dataSource)
                    var lineModelData: [LineModel] = []
                    for var index = 0; index < dataSource.count; index++ {
                        
                        let lineChartDataModel: LineChartDataModel = dataSource[index];
                        var model: LineModel = LineModel()
                        
                        model.lineColor = lineChartDataModel.lineChartColor
                        model.bottomString = lineChartDataModel.lineChartName
                        if index == 0 {
                            // 第一个
                            let nextModel = dataSource[index + 1];
                            model.noStart = true
                            model.curValue = lineChartDataModel.lineChartData
                            model.nextValue = nextModel.lineChartData
                        }
                        else {
                            let preModel = dataSource[index - 1]
                            model.preValue = preModel.lineChartData
                            model.curValue = lineChartDataModel.lineChartData
                            if index == dataSource.count-1 {
                                // 最后一个
                                model.noEnd = true
                            } else {
                                let nextModel = dataSource[index + 1]
                                model.nextValue = nextModel.lineChartData
                            }
                        }
                        model.yAxisValue = maxVaue
                        lineModelData.append(model)
                    }
                    allData.append(lineModelData)
                }
            }
        }
        return allData
    }
    
    // 将已经转换好的model 进行分组
    private func dataGroup(allData: [[LineModel]]) -> [LineChartModel] {
        var dataGroup: [LineChartModel] = []
        // 获取需要画多少段
        let itemIndex = allData[0].count
        for var i = 0; i < itemIndex; i++ {
            var lineChartModel: LineChartModel = LineChartModel()
            for var j = 0; j < allData.count; j++ {
                let objModel = allData[j][i]
                lineChartModel.lineModels.append(objModel)
                lineChartModel.bottomString = objModel.bottomString
            }
            dataGroup.append(lineChartModel)
        }
        return dataGroup
    }
    
    // MARK: 计算数据中的最大值
    private func calculateMaxValueInDatas(datas: [LineChartDataModel]) -> CGFloat {
        var maxValue: CGFloat = 1.0
        for data in datas {
            maxValue = max(maxValue, data.lineChartData)
        }
        return maxValue
    }
    
    // MARK: 刷新数据
    private func configureData(dataModels: [LineChartModel]) {
        self.dataArray = dataModels
        self.collectionView.reloadData()
        let item = dataModels.count - 1
        let lastItemIndex = NSIndexPath(forItem: item, inSection: 0)
        self.indexPath = lastItemIndex
        self.collectionView?.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    // MARK: collection delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: WDLineChartCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WDLineChartCell
        let cellModel = self.dataArray[indexPath.item]
        cell.drawLineChart(cellModel, showValue: indexPath.item == self.indexPath.item)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 移除先前的
        if let preCell: WDLineChartCell = collectionView.cellForItemAtIndexPath(self.indexPath) as? WDLineChartCell {
            preCell.removeValueLabels()
        }
        // 显示当前的
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let cell: WDLineChartCell = collectionView.cellForItemAtIndexPath(indexPath) as! WDLineChartCell
        let cellModel = self.dataArray[indexPath.item]
        cell.drawLineChart(cellModel, showValue: true)
        self.indexPath = indexPath
    }
}

// 外部一般数据 转为图表数据 入口
struct LineChartDataModel {
    var lineChartData: CGFloat! = 0.0
    var lineChartName: String!
    var lineChartColor: UIColor!
}

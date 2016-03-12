//
//  WDLineChartView.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

class WDLineChartView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataArray: [LineChartModel] = []
    
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

class LineChartModel: NSObject {
    var lineModels: [LineModel] = []
    var date: String!
}
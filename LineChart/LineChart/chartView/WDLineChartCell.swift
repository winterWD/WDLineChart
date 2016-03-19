//
//  WDLineChartCell.swift
//  LineChart
//
//  Created by winter on 16/3/12.
//  Copyright © 2016年 winter. All rights reserved.
//

import UIKit

class WDLineChartCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomStrLabel: UILabel!
    private var lineModels: [LineModel] = []
    private var circleViews: [UIView] = []
    private var valueLabels: [UILabel] = []
    private var isTopLayout: Bool = false  // 向上显示
    private var isFirstLayout: Bool = false // 第一次开始布局
    
    // MARK: 更新数据
    func drawLineChart(lineChartModel: LineChartModel, showValue: Bool) {
        self.lineModels = lineChartModel.lineModels
        self.bottomStrLabel.text = lineChartModel.bottomString
        self.setNeedsDisplay()
        
        // 画圆圈
        self.drawCircleView(self.lineModels)
        
        // 显示数值
        if showValue {
            self.displayValue(self.lineModels)
        } else {
            self.removeValueLabels()
        }
    }
    
    // MARK: 重新布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layouts(self.valueLabels)
    }
    
    // 重新布局valueLabel的位置
    private func layouts(array:[UILabel]) {
        
        self.isTopLayout = false
        self.isFirstLayout = false
        
        for var i = 0; i < array.count; i++ {
            let baseLabel = array[i]
            for var j = i+1; j < array.count; j++ {
                self.updateLayout(baseLabel, objLabel: array[j])
            }
        }
    }
    
    // 是否有重叠，有就调整位置
    private func updateLayout(baseLabel: UILabel, objLabel: UILabel) {
        let baseFrame: CGRect = baseLabel.frame
        // 重叠范围 修正±
        let fixValue: CGFloat = 0.0
        let objPointTop: CGPoint = CGPointMake(objLabel.frame.origin.x, objLabel.frame.origin.y + fixValue)
        let objPointBottom: CGPoint = CGPointMake(objLabel.frame.origin.x, objLabel.frame.origin.y + objLabel.frame.size.height - fixValue)
        if baseFrame.contains(objPointTop) || baseFrame.contains(objPointBottom) {
            self.layoutLabels(baseLabel, objLabel: objLabel)
        }
    }
    
    // baseLabel 作为参考点，调整objLabel位置
    private func layoutLabels(baseLabel: UILabel, objLabel: UILabel) {
        let centerY: CGFloat = baseLabel.center.y // 参考点
        let height: CGFloat = baseLabel.frame.size.height
        
        let center = objLabel.center
        
        guard self.isFirstLayout else {
            self.isFirstLayout = true
            if centerY > 93.0 {
                // 向上显示  93 刚好显示3个
                self.isTopLayout = true
                objLabel.center = CGPointMake(center.x, centerY - height)
            }
            else {
                // 向下显示
                self.isTopLayout = false
                objLabel.center = CGPointMake(center.x, centerY + height)
            }
            return
        }
        
        if self.isTopLayout {
            // 向上显示
            objLabel.center = CGPointMake(center.x, centerY - height)
        }
        else {
            // 向下显示
            objLabel.center = CGPointMake(center.x, centerY + height)
        }
    }
    
    // MARK: 显示valueLabel
    private func displayValue(lineModels: [LineModel]) {
        for model in lineModels {
            let valueLabel = UILabel.init()
            valueLabel.backgroundColor = model.lineColor
            valueLabel.textColor = UIColor.whiteColor()
            valueLabel.text = "\(model.curValue)"
            valueLabel.font = UIFont.systemFontOfSize(11)
            valueLabel.textAlignment = .Center
            valueLabel.frame.size = self.calculateLabelSize(valueLabel)
            valueLabel.center = CGPointMake(model.curPoint().x, model.curPoint().y - 12)
            valueLabel.layer.cornerRadius = 3
            valueLabel.layer.masksToBounds = true
            self.addSubview(valueLabel)
            self.valueLabels.insert(valueLabel, atIndex: 0)
        }
    }
    
    func removeValueLabels() {
        for view in self.valueLabels {
            view.removeFromSuperview()
        }
        self.valueLabels.removeAll()
    }
    
    private func calculateLabelSize(statusLabel: UILabel) -> CGSize {
        let statusLabelText: NSString = statusLabel.text!
        let statusLabelSize = statusLabelText.sizeWithAttributes([NSFontAttributeName : statusLabel.font])
        return CGSizeMake(max(statusLabelSize.width+6, 40.0), 15)
    }
    
    // MARK: 圆圈
    private func drawCircleView(lineModels: [LineModel]) {
        // 移除圆圈 解决复用
        for view in self.circleViews {
            view.removeFromSuperview()
        }
        self.circleViews.removeAll()
        let pointSize: CGFloat! = 6.0
        for model in lineModels {
            let circleView: UIView = UIView.init(frame: CGRectMake(0, 0, pointSize, pointSize))
            circleView.center = model.curPoint()
            circleView.backgroundColor = self.backgroundColor
            self.addSubview(circleView)
            circleView.layer.cornerRadius = pointSize/2.0
            circleView.layer.borderWidth = 1.0
            circleView.layer.borderColor = model.lineColor.CGColor
            circleView.layer.masksToBounds = true
            self.circleViews.append(circleView)
        }
    }
    
    // MARK: 画线
    override func drawRect(rect: CGRect) {
        // 清楚所有绘画
        self.clearsContextBeforeDrawing = true
        
        for model in self.lineModels {
            let startPoint: CGPoint = model.prePoint()
            let middlePoint: CGPoint = model.curPoint()
            let endPoint: CGPoint = model.nextPoint()
            
            // 获取当前画板
            let context: CGContextRef = UIGraphicsGetCurrentContext()!
            CGContextSetAllowsAntialiasing(context, true)// 抗锯齿
            CGContextSetLineWidth(context, 1) // 画笔宽度
            CGContextSetLineCap(context, .Round)
            
            CGContextSetStrokeColorWithColor(context, model.lineColor.CGColor)
            CGContextSetFillColorWithColor(context, model.lineColor.CGColor)
            
            // 画直线
            if model.noStart {
                CGContextMoveToPoint(context, middlePoint.x, middlePoint.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
            }
            else if model.noEnd {
                CGContextMoveToPoint(context, startPoint.x, startPoint.y)
                CGContextAddLineToPoint(context, middlePoint.x, middlePoint.y)
            }
            else {
                CGContextMoveToPoint(context, startPoint.x, startPoint.y)
                CGContextAddLineToPoint(context, middlePoint.x, middlePoint.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
            }
            CGContextStrokePath(context)//结束
        }
    }
}

// 中间数据转换 由普通数据转为图标所需要的数据
struct LineChartModel {
    var lineModels: [LineModel] = [] // 数组的个数就是线条的个数
    var bottomString: String! // 底部显示文字
}

// 计算每条线的位置
struct LineModel {
    
    private let halfWidth: CGFloat = 50.0/2.0 // 每一个cell的宽度一半，固定值
    private let height: CGFloat = 135.0 // 每一个cell的高度，固定值
    var yAxisValue: CGFloat = 0.0 // y轴上最大值
    
    var lineColor: UIColor!
    var preValue: CGFloat! = 0.0
    var curValue: CGFloat! = 0.0
    var nextValue: CGFloat! = 0.0
    var bottomString: String!
    
    var showValue: Bool = false // 是否显示value
    var noStart: Bool = false // 无起点
    var noEnd: Bool  = false // 无终点
    
    /// 计算前一值 所对应的高度点
    func prePoint() -> CGPoint {
        let tempvalue: CGFloat = self.preValue * self.height / self.yAxisValue
        let curvalue = height - self.curPoint().y
        // 前一个点距边线距离 和 后一个点距边线距离相等，所以在这两个点中间值就是边线上的点（起点）
        let y = height - (tempvalue + curvalue) / 2.0
        return CGPointMake(0, y)
    }
    
    /// 计算当前值 所对应的高度点
    func curPoint() -> CGPoint {
        // 中间点
        let y = self.curValue * self.height / self.yAxisValue
        return CGPointMake(self.halfWidth, height - y)
    }
    
    /// 计算后一值 所对应的高度点
    func nextPoint() -> CGPoint {
        let tempvalue: CGFloat = self.nextValue * self.height / self.yAxisValue
        let curvalue = height - self.curPoint().y
        // 终点
        let y = height - (tempvalue + curvalue) / 2.0
        return CGPointMake(self.halfWidth*2, y)
    }
}
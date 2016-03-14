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
    
    func drawLineChart(lineChartModel: LineChartModel) -> Void {
        self.lineModels = lineChartModel.lineModels
        self.bottomStrLabel.text = lineChartModel.bottomString
        self.setNeedsDisplay()
        
        // 移除圆圈
        self.removeCircleView(self.circleViews)
        // 画圆圈
        self.drawCircleView(self.lineModels)
    }
    
    func drawCircleView(lineModels: [LineModel]) -> Void {
        let pointSize: CGFloat! = 4.0
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
    
    func removeCircleView(circleViews: [UIView]) -> Void {
        for view in circleViews {
            view.removeFromSuperview()
        }
    }
    
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
class LineChartModel: NSObject {
    var lineModels: [LineModel] = [] // 数组的个数就是线条的个数
    var bottomString: String! // 底部显示文字
}

// 计算每条线的位置
class LineModel: NSObject {
    
    private let halfWidth: CGFloat = 50.0/2.0 // 每一个cell的宽度一半，固定值
    private let height: CGFloat = 135.0 // 每一个cell的高度，固定值
    private let yAxisValue: CGFloat = 100.0 // y轴上最大值
    
    var lineColor: UIColor!
    var preValue: CGFloat! = 1.0
    var curValue: CGFloat! = 1.0
    var nextValue: CGFloat! = 1.0
    var bottomString: String!
    
    var showValue: Bool = false // 是否显示value
    var noStart: Bool = false // 无起点
    var noEnd: Bool  = false // 无终点
    
    /// 计算前一值 所对应的高度点
    func prePoint() -> CGPoint {
        let tempvalue: CGFloat = self.preValue * self.height / self.yAxisValue
        let curvalue = self.curPoint().y
        // 前一个点距边线距离 和 后一个点距边线距离相等，所以在这两个点中间值就是边线上的点（起点）
        let y = (tempvalue + curvalue) / 2.0
        return CGPointMake(0, y)
    }
    
    /// 计算当前值 所对应的高度点
    func curPoint() -> CGPoint {
        // 中间点
        let y = self.curValue * self.height / self.yAxisValue
        return CGPointMake(self.halfWidth, y)
    }
    
    /// 计算后一值 所对应的高度点
    func nextPoint() -> CGPoint {
        let tempvalue: CGFloat = self.nextValue * self.height / self.yAxisValue
        let curvalue = self.curPoint().y
        // 终点
        let y = (tempvalue + curvalue) / 2.0
        return CGPointMake(self.halfWidth*2, y)
    }
}
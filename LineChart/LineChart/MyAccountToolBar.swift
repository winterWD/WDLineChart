//
//  MyAccountToolBar.swift
//  dealer
//
//  Created by winter on 16/3/10.
//  Copyright © 2016年 wedo. All rights reserved.
//

import UIKit

enum ToolBarActionType {
    case withdraw
    case charge
}


class MyAccountToolBar: UIView {
    
    @IBOutlet var view: UIView!
    
    var block: ((actionType: ToolBarActionType) -> Void)?
    
//    class func accountToolBar() -> MyAccountToolBar {
//        return NSBundle.mainBundle().loadNibNamed("MyAccountToolBar", owner: self, options: nil).first as! MyAccountToolBar
//    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    func setupView() -> Void {
        NSBundle.mainBundle().loadNibNamed("MyAccountToolBar", owner: self, options: nil)
        self.addSubview(self.view)
    }


    @IBAction func buttonAction(sender: UIButton) {
        // 默认提现
        var actionType: ToolBarActionType = ToolBarActionType.withdraw
        if sender.tag == 101 {
            // 充值
            actionType = ToolBarActionType.charge
        }
        if let action = self.block {
            action(actionType: actionType)
        }
    }
}

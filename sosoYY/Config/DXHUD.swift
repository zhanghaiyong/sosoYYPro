//
//  DXHUD.swift
//  DianXinHUD
//
//  Created by wangtian on 16/3/7.
//  Copyright © 2016年 wangtian. All rights reserved.
//

import UIKit

var DXHUDArray = [DXHUD]()
let DXScreenSize = UIScreen.main.bounds.size

class DXHUD: UIView {
    
    //一些常量
    let animationTime:CFTimeInterval = 0.5
    let hiddenHudAnimationTime:CFTimeInterval = 0.5
    static let defaultArcColor = UIColor.red
    static let viewCornerRadius:CGFloat = 20.0
    
    //xib上的控件
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var desLabel: UILabel!
    
    var hudFlag:String = "DefaultFlag"
    lazy var arcLayer = CAShapeLayer()
    var bgMaskView:UIView?
    
    //圆弧的颜色
    var arcColor: UIColor = UIColor.orange{
        
        willSet(newColor){
            
            arcLayer.strokeColor = newColor.cgColor
        }
    }
    
    
    class func dxHud() -> (DXHUD)
    {
        //从xib加载view
        let hud = Bundle.main.loadNibNamed("DXHUD", owner: nil, options: nil)?.first as! DXHUD
        let centerPoint =  CGPoint(x:hud.frame.size.width / 2, y:hud.frame.size.height / 2)
        hud.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5);
        hud.layer.cornerRadius = self.viewCornerRadius
        hud.layer.masksToBounds = true
        
        //创建logo上的圆弧
        let arcLayer = hud.arcLayer
        let arcPath = UIBezierPath.init(arcCenter: centerPoint, radius: hud.logoView.frame.size.width / 2 - 1, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        arcLayer.path = arcPath.cgPath
        arcLayer.lineWidth = 4
        arcLayer.strokeStart = 11 / 16.0
        arcLayer.strokeEnd = 13 / 16.0
        arcLayer.fillColor = UIColor.clear.cgColor
        hud.arcColor = defaultArcColor
        hud.frontView.layer.addSublayer(arcLayer)
        return hud
    }
    
    //MARK: 开始动画
    func beginAnimation()
    {
        //FIXME: 显示hud的时候应该加个合适的过渡动画
        //        UIView.animateWithDuration(hiddenHudAnimationTime, animations: { () -> Void in
        //
        //                self.alpha = 1.0
        //        })
        let rotaionAnimation = CABasicAnimation.init(keyPath: "transform")
        rotaionAnimation.toValue = NSValue.init(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI - 1), 0, 0, 1))
        rotaionAnimation.duration = self.animationTime
        rotaionAnimation.repeatCount = MAXFLOAT
        rotaionAnimation.isCumulative = true
        self.frontView.layer.add(rotaionAnimation, forKey: self.hudFlag)
    }
    
    //MARK: 终止动画 并销毁hud
    func endAnimation()
    {
        UIView.animate(withDuration: hiddenHudAnimationTime, animations: { () -> Void in
            
            self.alpha = 0.0
            
        }) { (finish: Bool) -> Void in
            
            if finish == true
            {
                self.frontView.layer.removeAnimation(forKey: self.hudFlag)
                if self.bgMaskView != nil
                {
                    self.bgMaskView!.removeFromSuperview()
                }
                self.removeFromSuperview()
                if let index = DXHUDArray.index(of: self)
                {
                    DXHUDArray.remove(at: index)
                }
            }
        }
    }
    
    //MARK: 关闭按钮被点击
    @IBAction func closeBtnClicked(sender: UIButton)
    {
        self.endAnimation()
    }
    
    //MARK: 设置hud的样式
    func setUpHud(remindTitle title:String, flag:String, confi:((_ hud: DXHUD) -> ())?)
    {
        //self.alpha = 0.0
        self.hudFlag = flag
        self.desLabel.text = title
        if let setHudblock = confi
        {
            setHudblock(self)
        }
        DXHUDArray.append(self)
    }
    
    /**
     在给定view里显示hud
     
     - parameter title:  提示语
     - parameter flag:   hud标记
     - parameter inView: 要显示hud的view
     - parameter confi:  设置hud的属性(可传空)
     */
    class func showHud(remindTitle title: String, flag:String, inView:UIView, confi:((_ hud: DXHUD) -> ())?)
    {
        let hud = self.dxHud()
        hud.setUpHud(remindTitle: title, flag: flag, confi: confi)
        hud.center = CGPoint(x:DXScreenSize.width / 2, y:DXScreenSize.height / 2)
        inView.addSubview(hud)
        hud.beginAnimation()
    }
    
    class func showHud(remindTitle title: String, flag:String, confi:((_ hud: DXHUD) -> ())?)
    {
        let hud = self.dxHud()
        hud.setUpHud(remindTitle: title, flag: flag, confi: confi)
        hud.center = CGPoint(x:DXScreenSize.width / 2, y:DXScreenSize.height / 2)
        if let keyWindow = UIApplication.shared.keyWindow
        {
            hud.bgMaskView = UIView()
            hud.bgMaskView!.frame = CGRect(x:0, y:0, width:DXScreenSize.width, height:DXScreenSize.height-49)
            hud.bgMaskView!.backgroundColor = UIColor.clear
            keyWindow.addSubview(hud.bgMaskView!)
            keyWindow.addSubview(hud)
            hud.beginAnimation()
        }
    }
    
    /**
     隐藏hud
     
     - parameter hudFlag: hud标记
     */
    class func hiddenHud(hudFlag flag: String)
    {
        if DXHUDArray.isEmpty
        {
            return
        }
        for hud in DXHUDArray
        {
            if hud.hudFlag == flag
            {
                hud.endAnimation()
            }
        }
    }
    
    deinit
    {
        //print("标记为\(hudFlag)的hud被释放了.....")
    }
}

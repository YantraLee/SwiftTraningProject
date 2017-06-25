//
//  CustomeHorizontalSelectorView.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/18.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol CustomeHorizontalSelectorViewDelegate {
    func selectorClicked(index indexClicked:Int)
}

class CustomeHorizontalSelectorView{
    
    private var scrollView :UIScrollView?
    private var selectorBtn :UIButton?
    private var selectorBtnArray :[UIButton]?
    
    //delegate宣告
    var delegate : CustomeHorizontalSelectorViewDelegate?
    
    func createSelector(viewController controller:UIViewController,view viewGet:UIView,selectors selectorsArray:[String]) -> UIScrollView! {
        scrollView = UIScrollView.init(frame: viewGet.bounds)
        scrollView?.backgroundColor = UIColor.clear
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.contentSize = CGSize.init(width: ScreenWidth/2*CGFloat(selectorsArray.count), height: viewGet.bounds.height)
        scrollView?.delegate = controller as? UIScrollViewDelegate
        scrollView?.tag = ScrollViewEnumType.horizontalSelector.rawValue
        
        selectorBtnArray = [UIButton]()
        for i in stride(from: 0, to: selectorsArray.count, by: 1){
            selectorBtn = UIButton.init(type: .custom)
            selectorBtn?.tag = i
            selectorBtn!.setTitle(selectorsArray[i], for: .normal)
            selectorBtn!.setTitleColor(UIColor.lightGray, for: .normal)
            selectorBtn!.setTitleColor(UIColor.white, for: .selected)
            selectorBtn!.backgroundColor = UIColor.clear
//            selectorBtn!.layer.borderColor = UIColor.lightGray.cgColor
//            selectorBtn!.layer.borderWidth = 0.5
            selectorBtn!.layer.masksToBounds = true
            selectorBtn!.titleLabel?.font = UIFont.init(name: fontNameSet, size: CGFloat(horizontalSelectorFontSize))
            selectorBtn!.frame = CGRect.init(x: ScreenWidth/2*CGFloat(i), y: 5, width: ScreenWidth/2, height: viewGet.bounds.height)
            
            //添加點擊按鈕觸發的delegate
            selectorBtn!.reactive.controlEvents(.touchUpInside).observeValues({ (button) in
                self.delegate?.selectorClicked(index: i) //呼叫delegate
                if i != selectorsArray.count-1 {//如果點擊的項目不是最後一個 才去移動scrollview
                    self.scrollView!.setContentOffset( CGPoint.init(x: ScreenWidth/2*CGFloat(i), y: 0), animated: true) //移動ScrollView的座標
                }
                
               self.refreshBtnState(index: button.tag)
            })
            
            if i == 0 {
                selectorBtn?.isSelected = true //預設先選到第一顆按鈕
            }
            
            selectorBtnArray?.append(selectorBtn!)
            scrollView!.addSubview(selectorBtn!)
        }
        
        return scrollView!
    }
    
    func refreshBtnState(index indexClicked:Int){
        for buttonGet in selectorBtnArray! {
            if buttonGet.tag != indexClicked {
                buttonGet.isSelected = false
            }else{
                buttonGet.isSelected = true
            }
        }
    }
}

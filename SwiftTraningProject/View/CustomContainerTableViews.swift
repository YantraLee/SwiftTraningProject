//
//  CustomContainerTableViews.swift
//  SwiftTraningProject
//
//  Created by 吉祥具 on 2017/6/19.
//  Copyright © 2017年 吉祥具. All rights reserved.
//

import Foundation
import ReactiveSwift

class CustomContainerTableViews:NSObject{
    
    //UI宣告
    private var scrollView :UIScrollView?
    private var tableView: UITableView?
    
    var tableViewsArray = [UITableView]()
    
    func createContainerTableViews(viewController controller:UIViewController,view viewGet:UIView,nibNames nibNamesArray:[String], cellIdentifiers cellIdentifierArray:[String]) -> UIScrollView! {
        scrollView = UIScrollView.init(frame: viewGet.bounds)
        scrollView?.backgroundColor = UIColor.clear
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.contentSize = CGSize.init(width: ScreenWidth*CGFloat(nibNamesArray.count), height: viewGet.bounds.height)
        scrollView?.delegate = controller as? UIScrollViewDelegate
        scrollView?.tag = ScrollViewEnumType.container.rawValue
        
        for i in stride(from: 0, to: nibNamesArray.count, by: 1){
            tableView = UITableView.init(frame: CGRect.init(x: ScreenWidth*CGFloat(i), y: 0, width: ScreenWidth, height: viewGet.bounds.height), style: .plain)
            tableView?.tag = i
            tableView?.backgroundColor = UIColor.clear
            tableView?.backgroundView = nil
            tableView?.separatorStyle = .none
            
            tableView?.delegate = controller as? UITableViewDelegate
            tableView?.dataSource = controller as? UITableViewDataSource
            
            tableView?.register(UINib.init(nibName: nibNamesArray[i], bundle: nil), forCellReuseIdentifier: cellIdentifierArray[i])
            
            tableViewsArray.append(tableView!)
            
            scrollView?.addSubview(tableView!)
        }
        
        
        
        return scrollView!
    }
    
    func reloadTableViews(index indexGet:Int){
        tableViewsArray[indexGet].reloadData()
    }
}

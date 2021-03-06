//
//  ChartVC.swift
//  JDChart_swift
//
//  Created by liuhang on 17/6/30.
//  Copyright © 2017年 liuhang. All rights reserved.
//

import UIKit
import Alamofire

class ChartVC: UIViewController,UITableViewDelegate,UITableViewDataSource,headerDelegate,chartViewCellDelegate,mainCellDelegate {
    
    var viewModel = chartVM()//视图模型
    var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: UITableViewStyle.plain)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK UI
        setupUI()
        //数据设置
        dataSetup()
    }
    func setupUI() {
        //uicollectionView  代理设置
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //cell
        tableView.register(mainCell.self, forCellReuseIdentifier: "reuseMainCell")
        tableView.register(UINib.init(nibName: "chartViewCell", bundle: nil), forCellReuseIdentifier: "reuseChartViewCell")
        //header
        tableView.register(chartHeaderView.self, forHeaderFooterViewReuseIdentifier: "reuseHeaderView")
        
        //UIBarButton_left
        self.title = "购物车"
        let navItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(ChartVC.backVC))
        navigationItem.leftBarButtonItem = navItem
        //UIBarButton_right
        let editItem = UIBarButtonItem.init(title: "编辑", style: .plain, target: self, action: #selector(ChartVC.edit))
        let messageItem = UIBarButtonItem.init(title: "消息", style: .plain, target: self, action: #selector(ChartVC.message))
        navigationItem.rightBarButtonItems = [editItem,messageItem]
    }
    //数据设置(网络请求有延迟，采用闭包刷新)
    func dataSetup() {
        viewModel.getChartData {[weak self] venders in
            self?.tableView.reloadData()
        }
    }

    
    //MARK  UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "reuseHeaderView") as! chartHeaderView
        headerView.vender = viewModel.venders![section]
        headerView.delegate = self
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.venders![section].sorted.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.venders!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.venders![indexPath.section].sorted[indexPath.row]
        if model.itemType == 1 {
            return model.item!.itemCellHeight
        }
        return model.items!.itemsCellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.venders![indexPath.section].sorted[indexPath.row]
        
        if model.itemType == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseChartViewCell", for: indexPath) as! chartViewCell
            cell.itemModel = model.item
            cell.delegate = self
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseMainCell", for: indexPath) as! mainCell
            cell.itemsModel = model.items
        cell.delegate = self
            return cell
    }
    
    //headerDelegate,chartViewCellDelegate,mainCellDelegate
    func btnOnclicked(vender: Vendor) {
        vender.isChoiced = !vender.isChoiced
        for sort in vender.sorted {
            if sort.item != nil {
                sort.item!.isChoiced = vender.isChoiced
            }else {
                for item in sort.items!.items {
                    item.isChoiced = vender.isChoiced
                }
            }
        }
        //数据多的时候可以刷新单个分组的cell
        tableView.reloadData()
        print("店铺按钮就点击了")
    }
    func giftOnclicked(model: Gift) {
        print("点击了赠品")
    }
    func promotionsOnclicked(models:[canSelectGift]) {
        print("点击了优惠")
    }
    func choiceBtnOnclicked(model: Item) {
        print(model.isChoiced)
        //检查是否有商铺的所有商品都被选择
        for (index,vender) in viewModel.venders!.enumerated() {
            //获取到组第一个model的isChoiced
            let sortFirst = viewModel.venders![index].sorted[0]
            let temp = sortFirst.item != nil ? sortFirst.item!.isChoiced : sortFirst.items!.items[0].isChoiced    
            for sort in vender.sorted {
                if sort.item != nil {
                    if sort.item!.isChoiced != temp {
                        vender.isChoiced = false
                        tableView.reloadData()
                        return
                    }                    
                }else {
                    for item in sort.items!.items {
                        if item.isChoiced != temp {
                            vender.isChoiced = false
                            tableView.reloadData()
                            return
                        }
                    }
                }
            }
            vender.isChoiced = temp
            tableView.reloadData()
        }
}
    
    
    func add_num(model: Item) {
        print("点击加号")
    }
    func reduce_num(model: Item) {
        print("点击了减号")
    }
    func service_choice(model: Item) {
        print("点击了服务")
    }
    func exchageBtnOnclicked() {
        print("点击了换购")
    }
    func message() {
        print("点击消息")
        
    }
    func edit() {
        print("点击编辑")
    }
    //返回按钮的点击
    func backVC()  {
        dismiss(animated: true, completion: nil)
    }
}

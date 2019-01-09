//
//  EBGoodsViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/6.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBGoodsViewController: UIViewController {
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var goodsTableView: UITableView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var cartviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var cartListView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var bulkLabel: UILabel!
    
    private var goodsData: EBResponse<GoodsResult>?
    private var second_category_height_list = [Int]()
    private var second_category_cout_per_first_category = [Int]()
    private var goods_cout_per_second_category = [Int]()
    private var select_category_index = 0
    private var cartViewShow: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    deinit {
        print("EBGoodsViewController deinit")
    }
    
    @IBAction func cartButtonTap(_ sender: Any) {
        self.cartViewShow = !self.cartViewShow
        if self.cartViewShow {
            self.cartviewConstraint.constant = 0
            maskView.isHidden = false
        }else {
            self.cartviewConstraint.constant = -300
            maskView.isHidden = true
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func nextTap() {
        let goodsVC = EBInfoExViewController()
        self.navigationController?.pushViewController(goodsVC, animated: true)
    }
    
    @objc func tapGesMaskAction(_ tapGes : UITapGestureRecognizer){
        self.cartviewConstraint.constant = -300
        maskView.isHidden = true
        self.cartViewShow = !self.cartViewShow
    }
    
    private func setupUI() {
        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
        self.navigationItem.rightBarButtonItem = item
        
        cartView.layer.shadowColor = UIColor.black.cgColor
        cartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cartView.layer.shadowOpacity = 0.2
        
        cartListView.layer.shadowColor = UIColor.black.cgColor
        cartListView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cartListView.layer.shadowOpacity = 0.8
        
        cartButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesMaskAction(_:)))
        tapGes.delegate = self as? UIGestureRecognizerDelegate
        maskView.addGestureRecognizer(tapGes)
        
        self.goodsTableView.registerNibWithCell(EBGoodsTableViewCell.self)
        self.categoryTableView.registerNibWithCell(EBCategoryTableViewCell.self)
        self.cartTableView.registerNibWithCell(EBGoodsTableViewCell.self)
    }
    
    private func loadData() {
        EBServiceManager.shared.request(target: EBServiceApi.goods) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    self.goodsData = EBResponse<GoodsResult>(JSONString: try response.mapString())
                    if let _goodsData = self.goodsData, _goodsData.code == 0 {
                        self.updateUI()
                    }else {
                        HUD.flash(.label(self.goodsData?.msg), delay: 1.0)
                    }
                } catch {
                    print(MoyaError.jsonMapping(response))
                }
            case let .failure(error):
                print(error.errorDescription ?? "网络错误")
            }
        }
    }
    
    private func updateUI() {
        //初始化高度列表
        guard let all_goods = goodsData?.result?.allGoods else {
            return
        }
        guard let firstCategory = goodsData?.result?.firstCategory else {
            return
        }
        guard let secondCategory = goodsData?.result?.secondCategory else {
            return
        }
        for _firstCategory in firstCategory {
            var item_count = 0
            for _secondCategory in secondCategory {
                if(_secondCategory.parentCategoryId == _firstCategory.categoryId){
                    item_count += 1
                }
            }
            second_category_cout_per_first_category.append(item_count)
        }
        
        for _secondCategory in secondCategory {
            var item_count = 0
            for item in all_goods {
                if(item.parentCategoryId == _secondCategory.categoryId){
                    item_count += 1
                }
            }
            second_category_height_list.append(40 * (item_count + 1))
            goods_cout_per_second_category.append(item_count)
        }
        
        categoryTableView.reloadData()
        goodsTableView.reloadData()
        cartTableView.reloadData()
        updateNumbers()
    }
    
    private func updateCart(good_id: Int, good_number: Int, isAdd: Bool) {
        guard let cartGoods = goodsData?.result?.cartGoods else {
            return
        }
        
        let step = isAdd ? 1 : -1
        var fFoundItem = false
        //更新购物车 (购物车中有item，更新数量)
        var cart_goods_temp = [CartGood]()
        for item in cartGoods {
            if item.goodsId == good_id {
                if let number = item.goodsNum {
                    item.goodsNum = number + step
                    fFoundItem = true
                }
            }
            if let number = item.goodsNum {
                if number > 0 {
                    cart_goods_temp.append(item)
                }
            }
        }
        //增加时 购物车中没有item，则新插入一条
        if (isAdd){
            if (fFoundItem == false) {
                let cartGood = CartGood()
                cartGood.goodsId = good_id
                cartGood.goodsNum = 1
                cart_goods_temp.append(cartGood)
            }
        }
        EBServiceManager.shared.request(target: EBServiceApi.goodsCartUpdate(cartGoods: cart_goods_temp)) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    let resp = EBResponseEmpty(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0 {
                        self.loadData()
                    }else {
                        HUD.flash(.label(resp?.msg), delay: 1.0)
                    }
                } catch {
                    print(MoyaError.jsonMapping(response))
                }
            case let .failure(error):
                print(error.errorDescription ?? "网络错误")
            }
        }
    }
    
    private func getGoodsNumber(goods: AllGood) -> Int {
        guard let cartGoods = goodsData?.result?.cartGoods else {
            return 0
        }
        for item in cartGoods {
            if item.goodsId == goods.goodsId {
                return item.goodsNum ?? 0
            }
        }
        return 0
    }
    
    private func updateNumbers() {
        guard let cartGoods = goodsData?.result?.cartGoods else {
            return
        }
        
        //更新红点数量 更新体积
        var badge_count = 0
        var bulk_count: Float = 0.0
        for item in cartGoods {
            badge_count += item.goodsNum ?? 0
            bulk_count = bulk_count + Float((item.goodsCubage ?? 0.0) * Float(item.goodsNum ?? 0))
        }
        badgeLabel.text = String(badge_count)
        bulkLabel.text = String(format:"%.1f", bulk_count)
    }
}

// MARK: UITableView DataSource
extension EBGoodsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let result = goodsData?.result else {
            return 0
        }
        if tableView == goodsTableView {// right
            return result.secondCategory?.count ?? 0
        }else if tableView == categoryTableView { // left
            return result.firstCategory?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = goodsData?.result else {
            return 0
        }
        if tableView == goodsTableView {// right
            //计算每个分类下所有商品的数量
            guard let all_goods = result.allGoods else {
                return 0
            }
            guard let secondCategory = result.secondCategory else {
                return 0
            }
            var count = 0
            for i in 0..<all_goods.count {
                if all_goods[i].parentCategoryId == secondCategory[section].categoryId {
                    count += 1
                }
            }
            return count
        }else if tableView == categoryTableView {// left
            //计算每个分类下所有二级分类数量
            guard let firstCategory = result.firstCategory else {
                return 0
            }
            guard let secondCategory = result.secondCategory else {
                return 0
            }
            var count = 0
            for i in 0..<secondCategory.count {
                if secondCategory[i].parentCategoryId == firstCategory[section].categoryId {
                    count += 1
                }
            }
            return count
        }else if tableView == cartTableView {
            return result.cartGoods?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == goodsTableView {// right
            let cell = tableView.dequeueCell(EBGoodsTableViewCell.self)
            if let _allGoods = goodsData?.result?.allGoods {
                var item: AllGood!
                if indexPath.section > 0 {
                    var total_goods_count = 0
                    for i in 0..<indexPath.section {
                        total_goods_count += goods_cout_per_second_category[i]
                    }
                    item = _allGoods[total_goods_count + indexPath.row]
                }else {
                    item = _allGoods[indexPath.row]
                }
                cell.titleLabel.text = item.goodsName
                let number = getGoodsNumber( goods: item)
                cell.number = number
                
                cell.plus = {[weak self] in
                    self?.updateCart(good_id: item.goodsId ?? 0, good_number: number, isAdd: true)
                }
                cell.minus = {[weak self] in
                     self?.updateCart(good_id: item.goodsId ?? 0, good_number: number, isAdd: false)
                }
            }
            return cell
        }else if tableView == categoryTableView {//left
            let cell = tableView.dequeueCell(EBCategoryTableViewCell.self)
            if let _secondCategory = goodsData?.result?.secondCategory {
                var total_count = 0
                for i in 0..<indexPath.section {
                    total_count += second_category_cout_per_first_category[i]
                }
                var item: Category!
                if indexPath.section > 0 {
                    item = _secondCategory[total_count + indexPath.row]
                }else {
                    item = _secondCategory[indexPath.row]
                }
                
                cell.titleLabel.text = item.categoryName
               
                if indexPath.row == select_category_index - total_count{
                     cell.selectView.isHidden = false
                }else {
                    cell.selectView.isHidden = true
                }
            }
            return cell
        }else if tableView == cartTableView {//cart
            let cell = tableView.dequeueCell(EBGoodsTableViewCell.self)
            if let _cartGoods = goodsData?.result?.cartGoods {
                let item = _cartGoods[indexPath.row]
                cell.titleLabel.text = item.goodsName
                cell.number = item.goodsNum ?? 0
                cell.plus = {[weak self] in
                    self?.updateCart(good_id: item.goodsId ?? 0, good_number: item.goodsNum ?? 0, isAdd: true)
                }
                cell.minus = {[weak self] in
                    self?.updateCart(good_id: item.goodsId ?? 0, good_number: item.goodsNum ?? 0, isAdd: false)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITableView Delegate
extension EBGoodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == cartTableView {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == goodsTableView {// right
            let headerView = EBHeaderView()
            headerView.titleLabel.text = goodsData?.result?.secondCategory?[section].categoryName ?? ""
            return headerView
        }else if tableView == categoryTableView {//left
            let headerView = EBHeaderView()
            headerView.titleLabel.text = goodsData?.result?.firstCategory?[section].categoryName ?? ""
            return headerView
        }
        
        return UIView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == goodsTableView {
            //滚动到的类别index
            var index = 0;
            var total_height = 0;
            for i in 0..<second_category_height_list.count {
                total_height += second_category_height_list[i]
                if(Int(scrollView.contentOffset.y) >= total_height){
                     index = i + 1;
                }
            }
            select_category_index = index
            
            var section = 0
            var second_category_total_count = 0;
            for  i in 0..<second_category_cout_per_first_category.count {
                second_category_total_count += second_category_cout_per_first_category[i]
                if(index >= second_category_total_count) {
                    section += 1
                }
            }
            
            var row = 0
            if(section > 0){
                var total = 0
                for i in 0..<section {
                    total +=  second_category_cout_per_first_category[i]
                }
                row = index - total
            }else {
                row = index
            }
        
//            print("section: \(section)")
//            print("row: \(row)")
           
            if let _ = goodsData {
                categoryTableView.reloadData()
                categoryTableView.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: true)
            }
        }
    }
}

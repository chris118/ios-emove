//
//  EBGoodsViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/6.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

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
    
    private var goodsData: EBResponse?
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
        let goodsVC = EBGoodsViewController()
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
         goodsData = EBResponse(JSONString: json)
        print(goodsData?.code ?? -1)
        
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
        
        goodsTableView.reloadData()
        updateNumbers()
    }
    
    private func updateData() {
        //成功后loadData 更新数据
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
        var bulk_count = 0
        for item in cartGoods {
            badge_count += item.goodsNum ?? 0
            bulk_count += item.goodsCubage ?? 0
        }
        badgeLabel.text = String(badge_count)
        bulkLabel.text = String(bulk_count)
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
                cell.number = getGoodsNumber( goods: item)
                
                cell.plus = {[weak self] in
                    self?.updateData()
                }
                cell.minus = {[weak self] in
                     self?.updateData()
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
                cell.titleLabel.text = _cartGoods[indexPath.row].goodsName
                 cell.number = _cartGoods[indexPath.row].goodsNum ?? 0
                cell.plus = {[weak self] in
                    self?.updateData()
                }
                cell.minus = {[weak self] in
                    self?.updateData()
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
        
            print("section: \(section)")
            print("row: \(row)")
           
            categoryTableView.reloadData()
            categoryTableView.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: true)

        }
    }
}

extension EBGoodsViewController {
    var json: String {
        get {
            return  "{\"code\":0,\"msg\":\"\",\"result\":{\"first_category\":[{\"category_id\":1,\"category_name\":\"\\u5bb6\\u5177\",\"parent_category_id\":0},{\"category_id\":2,\"category_name\":\"\\u5bb6\\u7535\",\"parent_category_id\":0},{\"category_id\":27,\"category_name\":\"\\u529e\\u516c\\u7528\\u54c1\",\"parent_category_id\":0},{\"category_id\":38,\"category_name\":\"\\u5176\\u5b83\",\"parent_category_id\":0}],\"second_category\":[{\"category_id\":4,\"category_name\":\"\\u4e94\\u6597\\u67dc\",\"parent_category_id\":1},{\"category_id\":5,\"category_name\":\"\\u4e66\\u6a71\",\"parent_category_id\":1},{\"category_id\":6,\"category_name\":\"\\u73bb\\u7483\\u6a71\",\"parent_category_id\":1},{\"category_id\":8,\"category_name\":\"\\u9152\\u67dc\",\"parent_category_id\":1},{\"category_id\":9,\"category_name\":\"\\u68b3\\u5986\\u67dc\",\"parent_category_id\":1},{\"category_id\":10,\"category_name\":\"\\u6c99\\u53d1\",\"parent_category_id\":1},{\"category_id\":11,\"category_name\":\"\\u5e8a\",\"parent_category_id\":1},{\"category_id\":12,\"category_name\":\"\\u5e8a\\u8fb9\\u7bb1\",\"parent_category_id\":1},{\"category_id\":3,\"category_name\":\"\\u5927\\u8863\\u67dc\",\"parent_category_id\":1},{\"category_id\":14,\"category_name\":\"\\u9910\\u684c\\u6905\",\"parent_category_id\":1},{\"category_id\":15,\"category_name\":\"\\u7535\\u89c6\\u67dc\",\"parent_category_id\":1},{\"category_id\":16,\"category_name\":\"\\u8336\\u51e0\",\"parent_category_id\":1},{\"category_id\":17,\"category_name\":\"\\u77ee\\u67dc\",\"parent_category_id\":1},{\"category_id\":18,\"category_name\":\"\\u5199\\u5b57\\u53f0\",\"parent_category_id\":1},{\"category_id\":24,\"category_name\":\"\\u51b0\\u67dc\",\"parent_category_id\":2},{\"category_id\":25,\"category_name\":\"\\u94a2\\u7434\",\"parent_category_id\":2},{\"category_id\":26,\"category_name\":\"\\u5065\\u8eab\\u5668\\u6750\",\"parent_category_id\":2},{\"category_id\":23,\"category_name\":\"\\u7a7a\\u8c03\",\"parent_category_id\":2},{\"category_id\":45,\"category_name\":\"\\u7f1d\\u7eab\\u673a\",\"parent_category_id\":2},{\"category_id\":19,\"category_name\":\"\\u51b0\\u7bb1\",\"parent_category_id\":2},{\"category_id\":20,\"category_name\":\"\\u7535\\u89c6\\u673a\",\"parent_category_id\":2},{\"category_id\":21,\"category_name\":\"\\u6d17\\u8863\\u673a\",\"parent_category_id\":2},{\"category_id\":22,\"category_name\":\"\\u97f3\\u54cd\\u8bbe\\u5907\",\"parent_category_id\":2},{\"category_id\":34,\"category_name\":\"\\u6837\\u54c1\\u6a71\",\"parent_category_id\":27},{\"category_id\":28,\"category_name\":\"\\u7535\\u8111\",\"parent_category_id\":27},{\"category_id\":29,\"category_name\":\"\\u590d\\u5370\\u673a\",\"parent_category_id\":27},{\"category_id\":30,\"category_name\":\"\\u4f20\\u771f\\u673a\",\"parent_category_id\":27},{\"category_id\":31,\"category_name\":\"\\u4fdd\\u9669\\u7bb1\",\"parent_category_id\":27},{\"category_id\":32,\"category_name\":\"\\u4f1a\\u8bae\\u684c\",\"parent_category_id\":27},{\"category_id\":33,\"category_name\":\"\\u6587\\u4ef6\\u6a71\",\"parent_category_id\":27},{\"category_id\":35,\"category_name\":\"\\u8001\\u677f\\u684c\",\"parent_category_id\":27},{\"category_id\":36,\"category_name\":\"\\u9694\\u65ad\\u5c4f\\u98ce\",\"parent_category_id\":27},{\"category_id\":37,\"category_name\":\"\\u5199\\u5b57\\u53f0\\uff08\\u63a8\\u67dc\\uff09\",\"parent_category_id\":27},{\"category_id\":43,\"category_name\":\"\\u4eea\\u5668\\u3001\\u8bbe\\u5907\",\"parent_category_id\":27},{\"category_id\":39,\"category_name\":\"\\u6253\\u5305\\u7eb8\\u7bb1\",\"parent_category_id\":38},{\"category_id\":40,\"category_name\":\"\\u5305\\u88f9\\u6742\\u7269\",\"parent_category_id\":38},{\"category_id\":41,\"category_name\":\"\\u9c7c\\u7f38\\u3001\\u82b1\\u76c6\",\"parent_category_id\":38},{\"category_id\":42,\"category_name\":\"\\u4ea4\\u901a\\u5de5\\u5177\",\"parent_category_id\":38}],\"all_goods\":[{\"goods_id\":2,\"goods_name\":\"\\u4e94\\u6597\\u6a71\\uff08\\u9700\\u4ece\\u7a97\\u53e3\\u540a\\uff09\",\"goods_cubage\":0.9,\"parent_category_id\":4},{\"goods_id\":3,\"goods_name\":\"\\u7ea2\\u6728\\uff08\\u67da\\u6728\\uff09\\u4e94\\u6597\\u6a71\",\"goods_cubage\":0.9,\"parent_category_id\":4},{\"goods_id\":4,\"goods_name\":\"\\u666e\\u901a\\u6728\\u6599\\u4e94\\u6597\\u6a71\",\"goods_cubage\":0.9,\"parent_category_id\":4},{\"goods_id\":27,\"goods_name\":\"\\u5c0f\\u6a71\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1,\"parent_category_id\":4},{\"goods_id\":28,\"goods_name\":\"\\u67dc\\u5b50\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":1,\"parent_category_id\":4},{\"goods_id\":29,\"goods_name\":\"\\u5c0f\\u6a71\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":1,\"parent_category_id\":4},{\"goods_id\":30,\"goods_name\":\"\\u67dc\\u5b50\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1,\"parent_category_id\":4},{\"goods_id\":23,\"goods_name\":\"3\\u95e8\\u4e66\\u6a71\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":1.3,\"parent_category_id\":5},{\"goods_id\":24,\"goods_name\":\"3\\u95e8\\u4e66\\u6a71\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":1.3,\"parent_category_id\":5},{\"goods_id\":25,\"goods_name\":\"2\\u95e8\\u4e66\\u6a71\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.9,\"parent_category_id\":5},{\"goods_id\":26,\"goods_name\":\"2\\u95e8\\u4e66\\u6a71\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":2,\"parent_category_id\":5},{\"goods_id\":31,\"goods_name\":\"\\u73bb\\u7483\\u6a71\\uff08\\u9700\\u540a\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":6},{\"goods_id\":32,\"goods_name\":\"\\u73bb\\u7483\\u6a71\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":6},{\"goods_id\":33,\"goods_name\":\"\\u73bb\\u7483\\u6a71\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":6},{\"goods_id\":34,\"goods_name\":\"\\u9152\\u67dc\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":8},{\"goods_id\":35,\"goods_name\":\"\\u9152\\u67dc\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":8},{\"goods_id\":36,\"goods_name\":\"\\u68b3\\u5986\\u53f0\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1.1,\"parent_category_id\":9},{\"goods_id\":37,\"goods_name\":\"\\u68b3\\u5986\\u53f0\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":1,\"parent_category_id\":9},{\"goods_id\":5,\"goods_name\":\"3\\u4eba\\u6c99\\u53d1\\uff08\\u9700\\u540a\\uff09\",\"goods_cubage\":1.3,\"parent_category_id\":10},{\"goods_id\":6,\"goods_name\":\"\\u5355\\u4eba\\u6c99\\u53d1\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.5,\"parent_category_id\":10},{\"goods_id\":7,\"goods_name\":\"\\u4e8c\\u4eba\\u6c99\\u53d1\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1.2,\"parent_category_id\":10},{\"goods_id\":8,\"goods_name\":\"\\u4e09\\u4eba\\u6c99\\u53d1\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1.3,\"parent_category_id\":10},{\"goods_id\":9,\"goods_name\":\"\\u5355\\u4eba\\u6c99\\u53d1\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":1.5,\"parent_category_id\":10},{\"goods_id\":10,\"goods_name\":\"\\u4e8c\\u4eba\\u6c99\\u53d1\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":1.2,\"parent_category_id\":10},{\"goods_id\":11,\"goods_name\":\"\\u4e09\\u4eba\\u6c99\\u53d1\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":1.5,\"parent_category_id\":10},{\"goods_id\":38,\"goods_name\":\"\\u5e8a\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.4,\"parent_category_id\":11},{\"goods_id\":39,\"goods_name\":\"\\u5e8a+\\u5e2d\\u68a6\\u601d\",\"goods_cubage\":0.8,\"parent_category_id\":11},{\"goods_id\":40,\"goods_name\":\"\\u5e8a+\\u5e2d\\u68a6\\u601d\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.8,\"parent_category_id\":11},{\"goods_id\":41,\"goods_name\":\"\\u5e8a+\\u5e2d\\u68a6\\u601d\\uff08\\u9700\\u540a\\uff09\",\"goods_cubage\":0.8,\"parent_category_id\":11},{\"goods_id\":42,\"goods_name\":\"\\u5e8a\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.8,\"parent_category_id\":11},{\"goods_id\":43,\"goods_name\":\"\\u5e8a\\u8fb9\\u7bb1\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.2,\"parent_category_id\":12},{\"goods_id\":44,\"goods_name\":\"\\u5e8a\\u8fb9\\u7bb1\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":0.2,\"parent_category_id\":12},{\"goods_id\":17,\"goods_name\":\"5\\u95e8\\u8131\\u5378\\u7ec4\\u5408\\u5927\\u8863\\u67dc\\uff08\\u9700\\u540a\\uff09\",\"goods_cubage\":3,\"parent_category_id\":3},{\"goods_id\":18,\"goods_name\":\"5\\u95e8\\u7ec4\\u5408\\u5927\\u8863\\u67dc\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":2.5,\"parent_category_id\":3},{\"goods_id\":19,\"goods_name\":\"5\\u95e8\\u8131\\u5378\\u7ec4\\u5408\\u5927\\u8863\\u67dc\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":3,\"parent_category_id\":3},{\"goods_id\":20,\"goods_name\":\"3\\u95e8\\u5927\\u8863\\u6a71\\uff08\\u666e\\u901a\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":2,\"parent_category_id\":3},{\"goods_id\":21,\"goods_name\":\"3\\u95e8\\u5927\\u8863\\u6a71\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":2,\"parent_category_id\":3},{\"goods_id\":22,\"goods_name\":\"3\\u95e8\\u5927\\u8863\\u6a71\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":2,\"parent_category_id\":3},{\"goods_id\":103,\"goods_name\":\"\\u4f4e\\uff08\\u77ee\\uff09\\u67dc\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":0.6,\"parent_category_id\":3},{\"goods_id\":45,\"goods_name\":\"\\u73bb\\u7483\\u9910\\u684c\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":46,\"goods_name\":\"\\u9910\\u684c\\uff08\\u9700\\u540a\\uff09\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":47,\"goods_name\":\"6\\u4eba\\u9910\\u684c\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":48,\"goods_name\":\"6\\u4eba\\u9910\\u684c\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":49,\"goods_name\":\"6\\u4eba\\u9910\\u684c\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":50,\"goods_name\":\"\\u516b\\u4ed9\\u684c\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":51,\"goods_name\":\"\\u516b\\u4ed9\\u684c\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":1,\"parent_category_id\":14},{\"goods_id\":85,\"goods_name\":\"\\u7ea2\\u6728\\u592a\\u5e08\\u6905\",\"goods_cubage\":0.5,\"parent_category_id\":14},{\"goods_id\":86,\"goods_name\":\"\\u7ea2\\u6728\\u6905\\u5b50\",\"goods_cubage\":0.3,\"parent_category_id\":14},{\"goods_id\":87,\"goods_name\":\"\\u6905\\u5b50\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":0.2,\"parent_category_id\":14},{\"goods_id\":88,\"goods_name\":\"\\u7ea2\\u6728\\u592a\\u5e08\\u6905\",\"goods_cubage\":0.5,\"parent_category_id\":14},{\"goods_id\":89,\"goods_name\":\"\\u7ea2\\u6728\\u6905\\u5b50\",\"goods_cubage\":0.3,\"parent_category_id\":14},{\"goods_id\":104,\"goods_name\":\"\\u7535\\u89c6\\u67dc\\uff08\\u666e\\u901a)\",\"goods_cubage\":1,\"parent_category_id\":15},{\"goods_id\":105,\"goods_name\":\"\\u7535\\u89c6\\u67dc\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.6,\"parent_category_id\":15},{\"goods_id\":106,\"goods_name\":\"\\u7535\\u89c6\\u67dc\\uff08\\u7ea2\\u6728\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":15},{\"goods_id\":109,\"goods_name\":\"\\u7ea2\\u6728\\u6216\\u67da\\u6728\\u8336\\u51e0\",\"goods_cubage\":0.2,\"parent_category_id\":16},{\"goods_id\":110,\"goods_name\":\"\\u73bb\\u7483\\u8336\\u51e0\",\"goods_cubage\":0.2,\"parent_category_id\":16},{\"goods_id\":111,\"goods_name\":\"\\u666e\\u901a\\u6728\\u6599\\u8336\\u51e0\",\"goods_cubage\":0.2,\"parent_category_id\":16},{\"goods_id\":55,\"goods_name\":\"\\u88ab\\u67dc\",\"goods_cubage\":0.6,\"parent_category_id\":17},{\"goods_id\":102,\"goods_name\":\"\\u4f4e\\uff08\\u77ee\\uff09\\u67dc\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":0.6,\"parent_category_id\":17},{\"goods_id\":52,\"goods_name\":\"\\u5199\\u5b57\\u53f0\\uff08\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.6,\"parent_category_id\":18},{\"goods_id\":53,\"goods_name\":\"\\u5199\\u5b57\\u53f0\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1.2,\"parent_category_id\":18},{\"goods_id\":54,\"goods_name\":\"\\u5199\\u5b57\\u53f0\\uff08\\u666e\\u901a\\u6728\\u6599\\uff09\",\"goods_cubage\":1.2,\"parent_category_id\":18},{\"goods_id\":60,\"goods_name\":\"\\u5927\\u51b0\\u67dc\",\"goods_cubage\":1.5,\"parent_category_id\":24},{\"goods_id\":61,\"goods_name\":\"\\u5c0f\\u51b0\\u67dc\",\"goods_cubage\":1.2,\"parent_category_id\":24},{\"goods_id\":75,\"goods_name\":\"\\u4e09\\u89d2\\u94a2\\u7434\",\"goods_cubage\":1.5,\"parent_category_id\":25},{\"goods_id\":76,\"goods_name\":\"\\u666e\\u901a\\u94a2\\u7434\",\"goods_cubage\":1.2,\"parent_category_id\":25},{\"goods_id\":112,\"goods_name\":\"\\u8dd1\\u6b65\\u673a\",\"goods_cubage\":0.8,\"parent_category_id\":26},{\"goods_id\":113,\"goods_name\":\"\\u9ebb\\u5c06\\u673a\",\"goods_cubage\":0.8,\"parent_category_id\":26},{\"goods_id\":114,\"goods_name\":\"\\u5065\\u8eab\\u5355\\u8f66\",\"goods_cubage\":0.5,\"parent_category_id\":26},{\"goods_id\":115,\"goods_name\":\"\\u6309\\u6469\\u6905\",\"goods_cubage\":0.7,\"parent_category_id\":26},{\"goods_id\":69,\"goods_name\":\"2.5\\u5339\\u4ee5\\u4e0a\\u7a7a\\u8c03\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.6,\"parent_category_id\":23},{\"goods_id\":70,\"goods_name\":\"\\u7a7a\\u8c031.5-2.5\\u5339\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.4,\"parent_category_id\":23},{\"goods_id\":71,\"goods_name\":\"1.5\\u5339\\u4ee5\\u4e0b\\u7a7a\\u8c03\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":0.3,\"parent_category_id\":23},{\"goods_id\":72,\"goods_name\":\"2.5\\u5339\\u4ee5\\u4e0a\\u7a7a\\u8c03\",\"goods_cubage\":0.6,\"parent_category_id\":23},{\"goods_id\":73,\"goods_name\":\"\\u7a7a\\u8c031.5-2.5\\u5339\",\"goods_cubage\":0.4,\"parent_category_id\":23},{\"goods_id\":74,\"goods_name\":\"1.5\\u5339\\u4ee5\\u4e0b\\u7a7a\\u8c03\",\"goods_cubage\":0.3,\"parent_category_id\":23},{\"goods_id\":65,\"goods_name\":\"\\u5de5\\u4e1a\\u7f1d\\u7eab\\u673a\",\"goods_cubage\":0.5,\"parent_category_id\":45},{\"goods_id\":68,\"goods_name\":\"\\u666e\\u901a\\u7f1d\\u7eab\\u673a\",\"goods_cubage\":0.4,\"parent_category_id\":45},{\"goods_id\":56,\"goods_name\":\"\\u5bf9\\u5f00\\u95e8\\u5927\\u51b0\\u7bb1\",\"goods_cubage\":1.5,\"parent_category_id\":19},{\"goods_id\":57,\"goods_name\":\"\\u51b0\\u7bb1180-220\\u7acb\\u5347\",\"goods_cubage\":1.4,\"parent_category_id\":19},{\"goods_id\":58,\"goods_name\":\"\\u51b0\\u7bb1\\uff08180\\u7acb\\u5347\\u4ee5\\u4e0b\\uff09\",\"goods_cubage\":1.2,\"parent_category_id\":19},{\"goods_id\":59,\"goods_name\":\"\\u51b0\\u7bb1\\uff08220\\u7acb\\u5347\\u4ee5\\u4e0a\\uff09\",\"goods_cubage\":1.6,\"parent_category_id\":19},{\"goods_id\":12,\"goods_name\":\"\\u7535\\u89c6\\u673a\\uff08\\u8001\\u5f0f21-29\\u5bf8\\uff09\",\"goods_cubage\":0.3,\"parent_category_id\":20},{\"goods_id\":13,\"goods_name\":\"\\u7535\\u89c6\\u673a\\uff08\\u6db2\\u667621-32\\u5bf8\\uff09\",\"goods_cubage\":0.2,\"parent_category_id\":20},{\"goods_id\":14,\"goods_name\":\"\\u7535\\u89c6\\u673a\\uff08\\u6db2\\u667633-42\\u5bf8\\uff09\",\"goods_cubage\":0.3,\"parent_category_id\":20},{\"goods_id\":15,\"goods_name\":\"\\u7535\\u89c6\\u673a\\uff08\\u6db2\\u667643\\u5bf8-55\\u5bf8\\uff09\",\"goods_cubage\":0.3,\"parent_category_id\":20},{\"goods_id\":16,\"goods_name\":\"\\u7535\\u89c6\\u673a55-70\\u5bf8\",\"goods_cubage\":0.6,\"parent_category_id\":20},{\"goods_id\":62,\"goods_name\":\"\\u6eda\\u7b52\\u6d17\\u8863\\u673a\",\"goods_cubage\":0.5,\"parent_category_id\":21},{\"goods_id\":63,\"goods_name\":\"\\u53cc\\u7f38\\u6d17\\u8863\\u673a\",\"goods_cubage\":0.5,\"parent_category_id\":21},{\"goods_id\":64,\"goods_name\":\"\\u5168\\u81ea\\u52a8\\u6d17\\u8863\\u673a\",\"goods_cubage\":0.6,\"parent_category_id\":21},{\"goods_id\":66,\"goods_name\":\"\\u9ad8\\u7ea7\\u97f3\\u54cd\\uff085000\\u5143\\u4ee5\\u4e0a\\uff09\",\"goods_cubage\":0.3,\"parent_category_id\":22},{\"goods_id\":67,\"goods_name\":\"\\u666e\\u901a\\u97f3\\u54cd\",\"goods_cubage\":0.3,\"parent_category_id\":22},{\"goods_id\":80,\"goods_name\":\"\\u666e\\u901a\\u6837\\u54c1\\u6a71\",\"goods_cubage\":0.9,\"parent_category_id\":34},{\"goods_id\":81,\"goods_name\":\"\\u73bb\\u7483\\u67dc\\u53f0\",\"goods_cubage\":2,\"parent_category_id\":34},{\"goods_id\":90,\"goods_name\":\"\\u7b14\\u8bb0\\u672c\",\"goods_cubage\":0.1,\"parent_category_id\":28},{\"goods_id\":91,\"goods_name\":\"\\u53f0\\u5f0f\\u7535\\u8111\",\"goods_cubage\":0.2,\"parent_category_id\":28},{\"goods_id\":92,\"goods_name\":\"\\u666e\\u901a\\u590d\\u5370\\u673a\",\"goods_cubage\":0.4,\"parent_category_id\":29},{\"goods_id\":93,\"goods_name\":\"\\u6709\\u5e95\\u5ea7\\u4f20\\u771f\\u4e00\\u4f53\\u673a\",\"goods_cubage\":1,\"parent_category_id\":29},{\"goods_id\":94,\"goods_name\":\"\\u4f20\\u771f\\u673a\",\"goods_cubage\":0.1,\"parent_category_id\":30},{\"goods_id\":95,\"goods_name\":\"\\u4fdd\\u9669\\u7bb1\\uff08\\u4f4e\\u4e8e80cm\\uff09\",\"goods_cubage\":0.5,\"parent_category_id\":31},{\"goods_id\":96,\"goods_name\":\"\\u4fdd\\u9669\\u7bb1\\uff08\\u9ad8\\u4e8e80cm\\uff09\",\"goods_cubage\":0.7,\"parent_category_id\":31},{\"goods_id\":77,\"goods_name\":\"8\\u4eba\\u4ee5\\u4e0a\\u4f1a\\u8bae\\u684c\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":2.5,\"parent_category_id\":32},{\"goods_id\":78,\"goods_name\":\"8\\u4eba\\u4f1a\\u8bae\\u684c\\u9700\\u62c6\\u88c5\",\"goods_cubage\":1.5,\"parent_category_id\":32},{\"goods_id\":79,\"goods_name\":\"\\u666e\\u901a\\u6587\\u4ef6\\u6a71\",\"goods_cubage\":0.9,\"parent_category_id\":33},{\"goods_id\":82,\"goods_name\":\"\\u666e\\u901a\\u8001\\u677f\\u684c\",\"goods_cubage\":1.3,\"parent_category_id\":35},{\"goods_id\":83,\"goods_name\":\"\\u7ea2\\u6728\\u8001\\u677f\\u684c\",\"goods_cubage\":1.3,\"parent_category_id\":35},{\"goods_id\":84,\"goods_name\":\"\\u8001\\u677f\\u684c\\uff08\\u9700\\u62c6\\u88c5\\uff09\",\"goods_cubage\":1.3,\"parent_category_id\":35},{\"goods_id\":119,\"goods_name\":\"\\u5df2\\u62c6\\u597d\\u5c4f\\u98ce\\u4e00\\u7ec4\",\"goods_cubage\":0.2,\"parent_category_id\":36},{\"goods_id\":120,\"goods_name\":\"\\u9700\\u62c6\\u88c5\\u5c4f\\u98ce\\u4e00\\u4eba\\u4f4d\",\"goods_cubage\":0.2,\"parent_category_id\":36},{\"goods_id\":117,\"goods_name\":\"\\u8001\\u677f\\u53f0\\u957f\\u63a8\\u67dc\",\"goods_cubage\":0.8,\"parent_category_id\":37},{\"goods_id\":118,\"goods_name\":\"\\u666e\\u901a\\u63a8\\u67dc\",\"goods_cubage\":0.2,\"parent_category_id\":37},{\"goods_id\":107,\"goods_name\":\"\\u5355\\u4ef6100\\u516c\\u65a4\\u5185\\u8bbe\\u5907\",\"goods_cubage\":1.2,\"parent_category_id\":43},{\"goods_id\":108,\"goods_name\":\"\\u5355\\u4ef6100-150\\u516c\\u65a4\\u8bbe\\u5907\",\"goods_cubage\":1.3,\"parent_category_id\":43},{\"goods_id\":116,\"goods_name\":\"\\u5355\\u4ef6150-250\\u516c\\u65a4\\u8bbe\\u5907\",\"goods_cubage\":1.5,\"parent_category_id\":43},{\"goods_id\":100,\"goods_name\":\"50cm*50cm*50cm\\u7eb8\\u7bb1\",\"goods_cubage\":0.1,\"parent_category_id\":39},{\"goods_id\":101,\"goods_name\":\"40cm*40cm*40cm\\u7eb8\\u7bb1\",\"goods_cubage\":0.1,\"parent_category_id\":39},{\"goods_id\":97,\"goods_name\":\"\\u751f\\u6d3b\\u7528\\u54c1\\u5c11\\u4e8e3\\u7acb\\u65b9\",\"goods_cubage\":5,\"parent_category_id\":40},{\"goods_id\":98,\"goods_name\":\"\\u751f\\u6d3b\\u7528\\u54c1\\u5c11\\u4e8e2\\u7acb\\u65b9\",\"goods_cubage\":3,\"parent_category_id\":40},{\"goods_id\":99,\"goods_name\":\"\\u751f\\u6d3b\\u7528\\u54c1\\u5c11\\u4e8e1\\u7acb\\u65b9\",\"goods_cubage\":2,\"parent_category_id\":40},{\"goods_id\":121,\"goods_name\":\"\\u9c7c\\u7f38\\uff08\\u957f\\u5ea6\\u5c0f\\u4e8e50cm\\uff09\",\"goods_cubage\":0.1,\"parent_category_id\":41},{\"goods_id\":122,\"goods_name\":\"\\u9c7c\\u7f38\\uff08\\u957f\\u5ea650-80cm\\uff09\",\"goods_cubage\":0.2,\"parent_category_id\":41},{\"goods_id\":123,\"goods_name\":\"\\u9c7c\\u7f38\\uff08\\u957f\\u5ea680-120cm\\uff09\",\"goods_cubage\":0,\"parent_category_id\":41},{\"goods_id\":124,\"goods_name\":\"\\u82b1\\u76c6\\u3001\\u76c6\\u666f\",\"goods_cubage\":0,\"parent_category_id\":41},{\"goods_id\":125,\"goods_name\":\"\\u81ea\\u884c\\u8f66\",\"goods_cubage\":0.4,\"parent_category_id\":42},{\"goods_id\":126,\"goods_name\":\"\\u7535\\u74f6\\u8f66\",\"goods_cubage\":0.8,\"parent_category_id\":42}],\"cart_goods\":[{\"goods_id\":29,\"goods_num\":1,\"goods_name\":\"\\u5c0f\\u6a71\\uff08\\u666e\\u901a\\uff09\",\"goods_cubage\":1,\"parent_category_id\":4},{\"goods_id\":30,\"goods_num\":1,\"goods_name\":\"\\u67dc\\u5b50\\uff08\\u7ea2\\u6728\\u6216\\u67da\\u6728\\uff09\",\"goods_cubage\":1,\"parent_category_id\":4}]}}"
        }
    }
    
   
}

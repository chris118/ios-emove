//
//  EBSearchMapViewController.swift
//  ebanjia
//
//  Created by admin on 2018/8/5.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBSearchMapViewController: UIViewController {

    var itemSelected: ((String,String)->())?
    @IBOutlet weak var tableview: UITableView!
    
    private var searchController: UISearchController!
    private var poiSearch: BMKPoiSearch!
    private var searchResult = [BMKPoiInfo]()
    private var searchKeyword = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        poiSearch = BMKPoiSearch()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        poiSearch.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        poiSearch.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSearchController(){
        //通过参数searchResultsController传nil来初始化UISearchController，意思是我们告诉search controller我们会用相同的视图控制器来展示我们的搜索结果，如果我们想要指定一个不同的view controller，那就会被替代为显示搜索结果。
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self

        //设置代理，searchResultUpdater是UISearchController的一个属性，它的值必须实现UISearchResultsUpdating协议，这个协议让我们的类在UISearchBar文字改变时被通知到，我们之后会实现这个协议。
        searchController.searchResultsUpdater = self
        //默认情况下，UISearchController暗化前一个view，这在我们使用另一个view controller来显示结果时非常有用，但当前情况我们并不想暗化当前view，即设置开始搜索时背景是否显示
        searchController.dimsBackgroundDuringPresentation = false
        //设置默认显示内容
        searchController.searchBar.placeholder = "输入地址..."
        //设置searchBar的代理
        searchController.searchBar.delegate = self
        //设置searchBar自适应大小
        searchController.searchBar.sizeToFit()
        //设置definesPresentationContext为true，我们保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上。
        searchController.definesPresentationContext = true
        //将searchBar设置为tableview的头视图
        tableview.tableHeaderView = searchController.searchBar
    }

    private func sendPoiSearchRequest() {
        if searchKeyword.count == 0 {
            return
        }
        let citySearchOption = BMKPOICitySearchOption()
        citySearchOption.pageIndex = 0
        citySearchOption.pageSize = 10
        citySearchOption.city = "上海"
        citySearchOption.keyword = searchKeyword
        if poiSearch.poiSearch(inCity: citySearchOption) {
            print("城市内检索发送成功！")
        }else {
            print("城市内检索发送失败！")
        }
    }
}

// MARK: UITableView DataSource
extension EBSearchMapViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchResult[indexPath.row].name
        return cell
    }
}

// MARK: UITableView Delegate
extension EBSearchMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(searchResult[indexPath.row].uid)
        if let _itemSelected = itemSelected {
            _itemSelected(searchResult[indexPath.row].uid, searchResult[indexPath.row].name)
        }
        self.searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension EBSearchMapViewController : UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: UISearchBarDelegate UISearchResultsUpdating
//扩展SearchViewController实现UISearchBarDelegate和UISearchResultsUpdating两个协议
extension EBSearchMapViewController: UISearchBarDelegate,UISearchResultsUpdating{
    
    //开始进行文本编辑，设置显示搜索结果，刷新列表
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    //点击Cancel按钮，设置不显示搜索结果并刷新列表
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //点击搜索按钮，触发该代理方法，如果已经显示搜索结果，那么直接去除键盘，否则刷新列表
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    
    //这个updateSearchResultsForSearchController(_:)方法是UISearchResultsUpdating中唯一一个我们必须实现的方法。当search bar 成为第一响应者，或者search bar中的内容被改变将触发该方法.不管用户输入还是删除search bar的text，UISearchController都会被通知到并执行上述方法。
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if let _searchString = searchString {
            print("\(_searchString)")
            searchKeyword = _searchString
            
            sendPoiSearchRequest()
        }
    }
}

// MARK: BMKPoiSearchDelegate
extension EBSearchMapViewController: BMKPoiSearchDelegate {
    // MARK: - BMKPoiSearchDelegate
    /**
     *返回POI搜索结果
     *@param searcher 搜索对象
     *@param poiResult 搜索结果列表
     *@param errorCode 错误号，@see BMKSearchErrorCode
     */
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        print("onGetPoiResult code: \(errorCode)");
        searchResult.removeAll()
        if errorCode == BMK_SEARCH_NO_ERROR {
            for i in 0..<poiResult.poiInfoList.count {
                let poi = poiResult.poiInfoList[i]
                searchResult.append(poi)
            }
            tableview.reloadData()
          
        } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
            print("检索词有歧义")
        } else {
            // 各种情况的判断……
        }
    }
}

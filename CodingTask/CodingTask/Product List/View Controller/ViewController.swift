//
//  ViewController.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 22/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:  - - - - - Properties - - - -
    var listDataViewModel: ListViewModel! {
        didSet{
            self.listDataViewModel.observableState.bind { [unowned self] (stateObj) in
                self.observableState = stateObj
            }
        }
    }
    
    private var observableState: ViewState<Any>? {
        didSet{
            guard let stateObject = observableState else { return }
            if refreshControl.isRefreshing{
                refreshControl.endRefreshing()
            }
            switch stateObject {
            case .loading:
                self.view.showActivity()
            case .loaded(data: let data):
                self.view.hideActivity()
                if let listData = data as? [ProductUIModel], !listData.isEmpty{
                    if self.pageNumber == 1{
                        self.arrListData = listData
                    }else{
                        self.arrListData.append(contentsOf: listData)
                    }
                    self.tableView.reloadData()
                }
            case .error(type: _):
                self.view.hideActivity()
                //handle error if required
            default:
                break
            }
        }
    }
    
    private let KProductListDataPageSize = 10
    private var pageNumber = 1
    private var arrListData: [ProductUIModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    private let productCellReuseId = "ItemsTableViewCell"
    private let productCellNibName = "ItemsTableViewCell"
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refreshProductListData), for: .valueChanged)
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Products"
        configTableView()
        
        //setting up data binding
        listDataViewModel = ListViewModel()
        getProductsData()
    }

    private func configTableView(){
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: productCellNibName, bundle: nil), forCellReuseIdentifier: productCellReuseId)
    }
    
    private func getProductsData(pageNo: Int = 1){
        listDataViewModel.getProductsListData(pageNo: pageNo, pageSize: KProductListDataPageSize)
    }
    
    private func resetPageNumber(){
        self.pageNumber = 1
    }
    
    @objc private func refreshProductListData(){
        self.resetPageNumber()
        self.getProductsData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellReuseId, for: indexPath) as! ItemsTableViewCell
        cell.updateItemCellWith(productModel: arrListData[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            fetchProductDataForNextpage()
        }
    }
    
    private func fetchProductDataForNextpage() {
        let availableProductCount = self.pageNumber * KProductListDataPageSize
        let totalFoundProducts = self.listDataViewModel.totalItems
        if(availableProductCount < totalFoundProducts) {
            self.pageNumber += 1
            self.getProductsData(pageNo: self.pageNumber)
        }
    }
}


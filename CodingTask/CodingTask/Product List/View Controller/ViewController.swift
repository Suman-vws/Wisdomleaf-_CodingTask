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
            switch stateObject {
            case .loading:
                self.view.showActivity()
            case .loaded(data: let data):
                self.view.hideActivity()
                if let listData = data as? [Product], !listData.isEmpty{
                    self.arrListData = listData
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
    private var arrListData: [Product] = []
    
    @IBOutlet weak var tableView: UITableView!
    private let productCellReuseId = "ItemsTableViewCell"
    private let productCellNibName = "ItemsTableViewCell"

    
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
        tableView.register(UINib(nibName: productCellNibName, bundle: nil), forCellReuseIdentifier: productCellReuseId)
    }
    
    private func getProductsData(pageNo: Int = 1){
        listDataViewModel.getProductsListData(pageNo: pageNo, pageSize: KProductListDataPageSize)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellReuseId, for: indexPath) as! ItemsTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}


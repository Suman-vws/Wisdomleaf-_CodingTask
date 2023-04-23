//
//  ProductsViewModel.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import Foundation

class ListViewModel {
    
    var observableState: Observable<ViewState<Any>> = Observable(.none)
    private let productsListApiManager: ListDataProvider = ListDataProvider()

    func getProductsListData(pageNo: Int, pageSize: Int){
        self.observableState.value = .loading
        self.configureProductsListFetchCompletion()
        self.productsListApiManager.getProductsDataWith(pageIndex: pageNo, pageSize: pageSize)
    }
    
    private func configureProductsListFetchCompletion() {
        self.productsListApiManager.listDataCompletionHandler = { [weak self] (result) in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                    case .success(let products):
                    self.observableState.value = .loaded(data: products ?? [])
                    case .failure(let error):
                        self.observableState.value = .error(type: error)
                }
            }
        }
    }
}

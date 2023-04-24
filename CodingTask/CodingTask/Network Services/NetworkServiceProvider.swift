//
//  NetworkServiceProvider.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import Foundation

public enum NetworkError : Error {
    case noData
    case parsingError
    case custom(message:String)
    
    var errorMessage:String{
        switch self {
        case .noData:
            return "Response returned with no data to decode."
        case .parsingError:
            return "Parsing Error."
        case .custom(let message):
            return message
        }
    }
}



class ListDataProvider {
    typealias ProductListCompletionHandler = ((Result<ProductListResult?, Error>) -> ())
    var listDataCompletionHandler: ProductListCompletionHandler?
    
    public typealias Parameters = [String:Any]
    private let baseURLPath = "https://dummyjson.com"
    private let productsPath = "/products"
    
    init() {
        //perform customisation, if required
    }
    
    //MARK: - - - - Helpers - - - - -
    private func encode(urlRequest: inout URLRequest, with parameters: Parameters) {
        guard let url = urlRequest.url else { return }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
    //MARK: - - - - Fetch Products - - - - -
    func getProductsDataWith(pageIndex: Int, pageSize: Int){
        let urlString = baseURLPath + productsPath
        let urlParams = ["skip": pageIndex, "limit": pageSize]
        
        guard let requestUrl = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        encode(urlRequest: &urlRequest, with: urlParams)
        
        URLSession.shared.dataTask(with: urlRequest) { [unowned self] (data,response,error) in
            if error == nil {
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(ProductListResult.self, from: responseData)
                        self.listDataCompletionHandler?(.success(response))
                    } catch {
                        self.listDataCompletionHandler?(.failure(NetworkError.parsingError))
                    }
                }else{
                    self.listDataCompletionHandler?(.failure(NetworkError.noData))
                }
            } else {
                self.listDataCompletionHandler?(.failure(error!))
            }
        }.resume()
    }

}


//
//  Binder.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import Foundation

public enum ViewState<Response>{
    case loading
    case loaded(data: Response)
    case error(type: Any)
}

class Observable<T> {
    var bind: (T) -> () = { _ in }
    
    var value: T {
        didSet {
            bind(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}



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
    case none
}

class Observable<T> {
    private var listner: (T) -> () = { _ in }
    
    func bind(_ closure: @escaping (T) -> Void){
        closure(value)
        listner = closure
    }
    
    var value: T {
        didSet {
            listner(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}



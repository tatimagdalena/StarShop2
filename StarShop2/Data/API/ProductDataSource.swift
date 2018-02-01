//
//  ProductDataSource.swift
//  StarShop2
//
//  Created by Tatiana Magdalena on 29/01/18.
//  Copyright © 2018 TOM. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductDataSourceProtocol {
    typealias SuccessCallback = (_ products: [Product]) -> ()
    typealias ErrorCallback = (_ error: Error) -> ()
    
    func fetchAvailableProducts(successHandler: @escaping SuccessCallback, errorHandler: @escaping ErrorCallback)
}

struct ProductDataSource: ProductDataSourceProtocol {
    
    let disposeBag = DisposeBag()
    
    func fetchAvailableProducts(successHandler: @escaping SuccessCallback, errorHandler: @escaping ErrorCallback) {
        
        let getProductsUrl = "https://private-428d5-starshop.apiary-mock.com/product"
        
        Networking.sendGetRequest(url: getProductsUrl)
            .retry(1)
            .timeout(60, scheduler: MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                do {
                    let products = try JSONDecoder().decode([Product].self, from: data)
                    print("got result: \(products)")
                    successHandler(products)
                } catch let error {
                    print("decoding error \(error)")
                    errorHandler(error)
                }
            }, onError: { (error) in
                print(error)
                errorHandler(error)
            })
            .disposed(by: disposeBag)
    }
    
}

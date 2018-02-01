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
    func fetchAvailableProducts() -> Observable<[ProductResponse]>
}

struct ProductDataSource: ProductDataSourceProtocol {
    
    func fetchAvailableProducts() -> Observable<[ProductResponse]> {
        
        let getProductsUrl = "https://private-428d5-starshop.apiary-mock.com/product"
        
        return Networking.sendGetRequest(url: getProductsUrl)
            .retry(1)
            .timeout(60, scheduler: MainScheduler.instance)
            .map { data in try self.serializeProducts(data: data) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func serializeProducts(data: Data) throws -> [ProductResponse]  {
        let products = try JSONDecoder().decode([ProductResponse].self, from: data)
        print("got result: \(products)")
        return products
    }
    
}

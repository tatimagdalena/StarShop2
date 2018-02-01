//
//  ShopViewModel.swift
//  StarShop2
//
//  Created by Tatiana Magdalena on 25/01/18.
//  Copyright © 2018 TOM. All rights reserved.
//

import Foundation

struct ShopCellViewModel {
    let titleText: String
    let priceText: String
    let imageUrl: String
}

protocol ShopViewModelProtocol {
    
    var isLoading: Bool { get set }
    var numberOfCells: Int { get }
    
    var reloadCollectionViewClosure: (()->())? { get set }
    var showAlertClosure: (()->())? { get set }
    var updateLoadingStatus: (()->())? { get set }
    
    func getCellViewModel(at indexPath: IndexPath) -> ShopCellViewModel
    func loadData()
    func userPressed(at indexPath: IndexPath)
    
}

class ShopViewModel: ShopViewModelProtocol {
    
    let dataSource: ProductDataSourceProtocol
    //private var products = [Product]()
    
    var reloadCollectionViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    private var cellViewModels = [ShopCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ShopCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func userPressed(at indexPath: IndexPath) {
        print("user pressed")
    }
    
    init(dataSource: ProductDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func loadData() {
        self.isLoading = true
        dataSource.fetchAvailableProducts(successHandler: { [weak self] products in
            self?.processFetchedProducts(products)
            self?.isLoading = false
            
        }, errorHandler: { [weak self] error in
            
            self?.isLoading = false
        })
    }
    
    private func processFetchedProducts(_ products: [Product]) {
        //self.products = products
        var cellViewModels = [ShopCellViewModel]()
        for product in products {
            cellViewModels.append(createCellViewModel(product: product.mapper()))
        }
        self.cellViewModels = cellViewModels
    }
    
    func createCellViewModel(product: ProductPresentation) -> ShopCellViewModel {
        
        return ShopCellViewModel(titleText: product.titleText, priceText: product.priceText, imageUrl: product.imageUrl)
    }
}

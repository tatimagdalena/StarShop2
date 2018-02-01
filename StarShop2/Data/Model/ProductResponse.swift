//
//  Product.swift
//  StarShop2
//
//  Created by Tatiana Magdalena on 25/01/18.
//  Copyright © 2018 TOM. All rights reserved.
//

import Foundation

struct ProductResponse: Decodable {
    var title: String
    var price: Int
    var seller: String
    var thumbnailHd: String
    
    func mapper() -> ProductPresentation {
        return ProductPresentation(titleText: title, priceText: price.asCurrencyFormat, imageUrl: thumbnailHd)
    }
}

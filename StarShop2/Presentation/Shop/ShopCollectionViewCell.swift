//
//  ShopCollectionViewCell.swift
//  StarShop2
//
//  Created by Tatiana Magdalena on 01/02/18.
//  Copyright © 2018 TOM. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let identifier = "productCellIdentifier"
}

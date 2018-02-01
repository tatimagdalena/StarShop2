//
//  ShopViewController.swift
//  StarShop2
//
//  Created by Tatiana Magdalena on 25/01/18.
//  Copyright © 2018 TOM. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ShopViewController: UICollectionViewController {
    
    lazy var viewModel: ShopViewModelProtocol = {
        return ShopViewModel(dataSource: ProductDataSource())
    }()

}

// MARK: - Lifecycle -

extension ShopViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                print("update loading status closure")
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    //self?.activityIndicator.startAnimating()
                    self?.collectionView?.alpha = 0.0
                }else {
                    //self?.activityIndicator.stopAnimating()
                    self?.collectionView?.alpha = 1.0
                }
            }
        }
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                print("reload collection closure")
                self?.collectionView?.reloadData()
            }
        }
        
        viewModel.showAlertClosure = { () in
            DispatchQueue.main.async {
                print("alert closure")
            }
        }
        
        viewModel.loadData()
    }
    
}

//// MARK: - Navigation -
//
//extension ShopViewController {
//    /*
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using [segue destinationViewController].
//     // Pass the selected object to the new view controller.
//     }
//     */
//}

// MARK: - UICollectionViewDataSource -

extension ShopViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.identifier, for: indexPath) as? ShopCollectionViewCell else { fatalError("Cell does not exist in storyboard") }
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.titleLabel.text = cellVM.titleText
        cell.priceLabel.text = cellVM.priceText
        
        DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        if let url = URL(string: cellVM.imageUrl) {
            let filter = AspectScaledToFitSizeFilter(size: CGSize(width: 175.0, height: 119.0))
            cell.mainImageView.af_setImage(withURL: url, filter: filter)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate -

extension ShopViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.userPressed(at: indexPath)
    }
}

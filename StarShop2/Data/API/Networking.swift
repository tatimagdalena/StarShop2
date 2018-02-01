//
//  Networking.swift
//  GithubRx
//
//  Created by Tatiana Magdalena on 23/01/18.
//  Copyright © 2018 Stone Pagamentos. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import RxSwift

typealias JSON = [String : Any]

enum APIError: Error {
    case encoding
    case decoding
    case server
}

class Networking {
    
    static func sendGetRequest(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<Data> {
        
        return Observable.create { observer in
            
            print("Requesting to \(url)")
            
            let request = Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                    // request completed with a JSON response
                    case .success:
                        
                        if let data = response.data {
                            observer.onNext(data)
                            observer.onCompleted()
                        } else {
                            observer.onError(APIError.decoding)
                        }
                        
                    // request error without JSON response
                    case .failure(let requestError):
                        observer.onError(requestError)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func sendPostRequest(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<Data?> {
        
        print("Requesting to \(url)")
        
        return Observable.create { observer in
            
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                    // request completed with a JSON response
                    case .success:
                        observer.onNext(response.data)
                        observer.onCompleted()
                    // request error without JSON response
                    case .failure(let requestError):
                        observer.onError(requestError)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
//    static func sendImageRequest(url: String) -> Observable<Image> {
//        return Observable.create({ observer in
//            
//            let request = Alamofire.request(url)
//                .responseImage { response in
//                
//                    switch response.result {
//                    case .success:
//                        if let image = response.result.value {
//                            observer.onNext(image)
//                        }
//                        
//                    case .failure(let error):
//                        observer.onError(error)
//                        
//                    }
//            }
//            return Disposables.create {
//                request.cancel()
//            }
//            
//        })
//    }
    
}

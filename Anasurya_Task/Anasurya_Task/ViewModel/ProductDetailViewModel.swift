//
//  ProductDeleteViewModel.swift
//  Anasurya_Task
//
//  Created by Anasurya on 25/08/2024.
//

import Foundation
class ProductDetailViewModel {
   
    func deleteProduct(productID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/products/\(productID)"
        
        APIService.shared.deleteRequest(endpoint: endpoint, method: "DELETE", body: nil) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}

//
//  ProductViewModel.swift
//  Anasurya_Task
//
//  Created by Anasurya on 24/08/2024.
//

import Foundation

class ProductListViewModel {
     var products: [Product] = []
    var filteredProducts: [Product] = []

    func fetchProducts(completion: @escaping () -> Void) {
        APIService.shared.performRequest(endpoint: "/products", method: "GET") { (result: Result<ProductModel, Error>) in
            switch result {
            case .success(let products):
                self.products = products.products ?? []
                self.filteredProducts = products.products ?? []
                completion()
            case .failure(let error):
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
}


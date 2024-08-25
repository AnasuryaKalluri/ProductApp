//
//  CreateAndEditViewModel.swift
//  Anasurya_Task
//
//  Created by Anasurya on 25/08/2024.
//

import Foundation

class CreateEditProductViewModel {
    var product: Product?
    
    func saveProduct(title: String, description: String, price: Double, category: String, isEditMode: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let newProduct = Product(
            id: product?.id ?? 0,
            title: title,
            description: description,
            category: category,
            price: price,
            discountPercentage: product?.discountPercentage,
            rating: product?.rating,
            stock: product?.stock,
            tags: product?.tags,
            brand: product?.brand,
            sku: product?.sku,
            weight: product?.weight,
            dimensions: product?.dimensions,
            warrantyInformation: product?.warrantyInformation,
            shippingInformation: product?.shippingInformation,
            availabilityStatus: product?.availabilityStatus,
            reviews: product?.reviews,
            returnPolicy: product?.returnPolicy,
            minimumOrderQuantity: product?.minimumOrderQuantity,
            meta: product?.meta,
            images: product?.images,
            thumbnail: product?.thumbnail)
    
        let endpoint = isEditMode ? "/products/\(newProduct.id ?? 0)" : "/products/add"
        let method = isEditMode ? "PUT" : "POST"
        
        do {
            let body = try JSONEncoder().encode(newProduct)
            APIService.shared.performRequest(endpoint: endpoint, method: method, body: body) { (result: Result<Product, Error>) in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

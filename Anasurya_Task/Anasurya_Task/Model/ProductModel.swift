//
//  ProductModel.swift
//  Anasurya_Task
//
//  Created by Anasurya on 24/08/2024.
//

import Foundation


struct ProductModel: Codable {
    let products: [Product]?
    let total, skip, limit: Int?
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title, description: String?
    let category: String?
    let price, discountPercentage, rating: Double?
    let stock: Int?
    let tags: [String]?
    let brand: String?
    let sku: String?
    let weight: Int?
    let dimensions: Dimensions?
    let warrantyInformation, shippingInformation: String?
    let availabilityStatus: AvailabilityStatus?
    let reviews: [Review]?
    let returnPolicy: String?
    let minimumOrderQuantity: Int?
    let meta: Meta?
    let images: [String]?
    let thumbnail: String?
    
    init(id: Int?, title: String?, description: String?, category: String?, price: Double?, discountPercentage: Double?, rating: Double?, stock: Int?, tags: [String]?, brand: String?, sku: String?, weight: Int?, dimensions: Dimensions?, warrantyInformation: String?, shippingInformation: String?, availabilityStatus: AvailabilityStatus?, reviews: [Review]?, returnPolicy: String?, minimumOrderQuantity: Int?, meta: Meta?, images: [String]?, thumbnail: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.tags = tags
        self.brand = brand
        self.sku = sku
        self.weight = weight
        self.dimensions = dimensions
        self.warrantyInformation = warrantyInformation
        self.shippingInformation = shippingInformation
        self.availabilityStatus = availabilityStatus
        self.reviews = reviews
        self.returnPolicy = returnPolicy
        self.minimumOrderQuantity = minimumOrderQuantity
        self.meta = meta
        self.images = images
        self.thumbnail = thumbnail
    }

}

enum AvailabilityStatus: String, Codable {
    case inStock = "In Stock"
    case lowStock = "Low Stock"
}

// MARK: - Dimensions
struct Dimensions: Codable {
    let width, height, depth: Double?
}

// MARK: - Meta
struct Meta: Codable {
    let createdAt, updatedAt: String?
    let barcode: String?
    let qrCode: String?
}


// MARK: - Review
struct Review: Codable {
    let rating: Int?
    let comment: String?
    let date: String?
    let reviewerName, reviewerEmail: String?
}


struct editModel: Codable {
    
}

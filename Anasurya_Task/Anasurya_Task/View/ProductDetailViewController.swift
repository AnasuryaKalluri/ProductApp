//
//  ProductDetailViewController.swift
//  Anasurya_Task
//
//  Created by Anasurya on 24/08/2024.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    // Product Data
    var product: Product?
    var viewModel = ProductDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateProductDetails()
    }
    
     func populateProductDetails() {
        guard let product = product else { return }
         titleLbl.text = product.title ?? ""
         categoryLbl.text = "Category: \(product.category ?? "")"
         priceLbl.text = "Price: $\(product.price ?? 0.0)"
         ratingLbl.text = "Rating: \(product.rating ?? 0.0) ★"
         discountLbl.text = "Discount: \(product.discountPercentage ?? 0.0)%"
         stockLbl.text = "Stock: \(product.stock ?? Int(0.0))"
         brandLbl.text = "Brand: \(product.brand ?? "")"
         imgView.loadImage(from: product.thumbnail)
         descriptionLbl.text = product.description

    }
    
    @IBAction func alertBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateAndEditProductViewController") as? CreateAndEditProductViewController {
                vc.product = self.product
                vc.isEditMode = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                        self.deleteProduct()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
     func deleteProduct() {
           guard let productID = product?.id else { return }

        viewModel.deleteProduct(productID: productID) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success:
                       self?.showAlert(message: "Product deleted successfully!") {
                           self?.navigationController?.popViewController(animated: true)
                           // Update product list on Product List Screen
                           NotificationCenter.default.post(name: .didDeleteProduct, object: nil)
                       }
                   case .failure(let error):
                       self?.showAlert(message: "Failed to delete product: \(error.localizedDescription)")
                   }
               }
           }
       }
       
       private func showAlert(message: String, completion: (() -> Void)? = nil) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               completion?()
           }))
           present(alert, animated: true, completion: nil)
       }
}

// MARK: - UIImageView Extension for Loading Image
extension UIImageView {
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

extension Notification.Name {
    static let didDeleteProduct = Notification.Name("didDeleteProduct")
    static let didEditOrAddProduct  = Notification.Name("didEditOrAddProduct")
}

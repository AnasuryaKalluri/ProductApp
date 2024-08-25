//
//  CreateAndEditProductViewController.swift
//  Anasurya_Task
//
//  Created by Anasurya on 24/08/2024.
//

import UIKit

class CreateAndEditProductViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var editORAddButton: UIButton!
    
    var product: Product?
    var isEditMode: Bool?
    var viewModel = CreateEditProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.product = product
        self.setupUI()
    }
    func setupUI() {
        if isEditMode ?? false {
            titleTF.text = product?.title
            priceTF.text = "\(product?.price ?? 0)"
            categoryTF.text = "\(product?.category ?? "")"
            descriptionTF.text = product?.description
            editORAddButton.setTitle("Edit Product", for: .normal)
        } else {
            editORAddButton.setTitle("Add Product", for: .normal)
        }
    }
    
    @IBAction func editORAddBtnAction(_ sender: Any) {
        guard let title = titleTF.text, !title.isEmpty,
              let description = descriptionTF.text, !description.isEmpty,
              let priceText = priceTF.text, let price = Double(priceText),
              let category = categoryTF.text, !category.isEmpty else {
            showAlert(message: "Please fill out all fields.")
            return
        }
        viewModel.saveProduct(title: title, description: description, price: price, category: category, isEditMode: isEditMode ?? false) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if self?.isEditMode ?? false {
                        self?.showAlert(message: "Product Update successfully!", completion: {
                            self?.addNavigation()
                        })
                    }else {
                        self?.showAlert(message: "Product Added successfully!", completion: {
                            self?.addNavigation()
                        })
                    }
                  
                case .failure(let error):
                    self?.showAlert(message: "Failed to save product: \(error.localizedDescription)")
                }
            }
        }
    }
    func addNavigation() {
        self.navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: .didEditOrAddProduct, object: nil)
        
    }

    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}

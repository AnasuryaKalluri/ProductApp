//
//  ViewController.swift
//  Anasurya_Task
//
//  Created by Anasurya on 24/08/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let viewModel = ProductListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        setupUI()
        setupNavigationBar()
        fetchProducts()
        // Register for notification
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProductList), name: .didDeleteProduct, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProductList), name: .didEditOrAddProduct, object: nil)
    }
    
    func registerNib(){
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductTableViewCell")
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    func setupNavigationBar() {
        // Create the Add Product button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductTapped))
        
        // Add the button to the navigation bar
        navigationItem.rightBarButtonItem = addButton
    }

       // Action for the Add button
       @objc private func addProductTapped() {
           // Call your Add function here
           if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateAndEditProductViewController") as? CreateAndEditProductViewController {
               vc.isEditMode = false
               self.navigationController?.pushViewController(vc, animated: false)
           }
       }

    func fetchProducts() {
        viewModel.fetchProducts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc func refreshProductList() {
        // Reload product list
        fetchProducts()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.filteredProducts.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
            let product = viewModel.filteredProducts[indexPath.row]
            cell.selectionStyle = .none
            cell.titleLbl.text = product.title
            cell.categoryLbl.text = product.category
            cell.priceLbl.text = "Price: $\(product.price ?? 0.0)"
            return cell
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.filteredProducts[indexPath.row]
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        vc?.product = data
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(viewModel.filteredProducts.count, searchText)
        
        if searchText.isEmpty {
            // If the search bar is empty, show all products
            viewModel.filteredProducts = viewModel.products
        } else {
            // Filter the products based on the search text
            viewModel.filteredProducts = viewModel.products.filter { product in
                // Check if the product title or category contains the search text
                let titleMatches = product.title?.lowercased().contains(searchText.lowercased()) ?? false
                let categoryMatches = product.category?.lowercased().contains(searchText.lowercased()) ?? false
                return titleMatches || categoryMatches
            }
        }
        
        tableView.reloadData()
        print(viewModel.filteredProducts.count)
    }

        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }

}

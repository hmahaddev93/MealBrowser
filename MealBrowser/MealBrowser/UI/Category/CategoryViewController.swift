//
//  CategoryViewController.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import UIKit

final class CategoryViewController: UIViewController {
    private let viewModel: CategoryViewModel
    private let categoryView = CategoryView()
    
    private let alertPresenter: AlertPresenter_Proto = AlertPresenter()
    private let navPresenter: NavigationPresenter = NavigationPresenter()

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = categoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        categoryView.tableView.dataSource = self
        categoryView.tableView.delegate = self
        loadCategories()
    }
    
    private func loadCategories() {
        showSpinner()
        viewModel.fetchCategories { [unowned self]result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.update()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.display(error: error)
                }
            }
        }
    }
    
    private func update() {
        categoryView.tableView.reloadData()
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error.localizedDescription)",
                               dismissButtonTitle: "OK")
    }
    
    private func showSpinner() {
        categoryView.activityIndicatorView.startAnimating()
    }
    
    private func hideSpinner() {
        self.categoryView.activityIndicatorView.stopAnimating()
    }

}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {
            let category = viewModel.categories[indexPath.row]
            categoryCell.category = category
            return categoryCell
        }
        return UITableViewCell()
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        let categorySelected = viewModel.categories[indexPath.row]
        self.navPresenter.navigateToMealsBy(category: categorySelected.name, from: self, animated: true)
    }
}


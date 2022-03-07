//
//  MealDetailViewController.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import UIKit

final class MealDetailViewController: UIViewController {

    static let reuseDefaultCellIdentifier = "DefaultCell"
    static let reuseImagesCellIdentifier = "MealImageCell"
    static let reuseTextCellIdentifier = "TextCell"

    private let alertPresenter: AlertPresenter_Proto = AlertPresenter()
    private let viewModel: MealDetailViewModel
    lazy var detailView = MealDetailView()
    
    enum TableViewSection: Int, CaseIterable {
        case image
        case instructions
        case ingredients
    }

    init(viewModel: MealDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.tableView.dataSource = self
        detailView.tableView.delegate = self
        loadMeal()
    }
    
    private func loadMeal() {
        viewModel.fetchMeal { [unowned self] result in
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
        detailView.tableView.reloadData()
        detailView.nameLabel.text = viewModel.meal?.title
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error.localizedDescription)",
                               dismissButtonTitle: "OK")
    }
    
    private func showSpinner() {
        detailView.activityIndicatorView.startAnimating()
    }
    
    private func hideSpinner() {
        self.detailView.activityIndicatorView.stopAnimating()
    }
}

extension MealDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        TableViewSection.allCases.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableViewSection = TableViewSection(rawValue: section) else { return 0 }
        
        switch tableViewSection {
        case .image, .instructions:
            return 1
        case .ingredients:
            return viewModel.meal?.recipes?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableViewSection = TableViewSection(rawValue: indexPath.section) else {
            return 0
        }
        
        switch tableViewSection {
        case .image:
            return 200.0
        case .instructions:
            return viewModel.getInstructionsCellHeight()
        case .ingredients:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewSection = TableViewSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch tableViewSection {
        case .instructions:
            if let instructionCell = tableView.dequeueReusableCell(withIdentifier: type(of: self).reuseTextCellIdentifier, for: indexPath) as? MealTextCell {
                instructionCell.text = viewModel.meal?.instructions
                return instructionCell
            }
            return UITableViewCell()
            
        case .image:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: type(of: self).reuseImagesCellIdentifier, for: indexPath) as? MealImageCell {
                imageCell.meal = viewModel.meal
                return imageCell
            }
            return UITableViewCell()
        case .ingredients:
            let ingredientCell = UITableViewCell(style: .value1, reuseIdentifier: type(of: self).reuseDefaultCellIdentifier)
            if let recipe = viewModel.meal?.recipes?[indexPath.row] {
                ingredientCell.textLabel?.text = recipe.ingredient + ": " + recipe.measure
            }
            return ingredientCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let tableViewSection = TableViewSection(rawValue: section) else { return 0 }
        switch tableViewSection {
        case .image:
            return 0
        case .instructions, .ingredients:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tableViewSection = TableViewSection(rawValue: section) else { return nil }
        switch tableViewSection {
        case .image:
            return nil
        case .instructions:
            return "INSTRUCTIONS"
        case .ingredients:
            return "INGREDIENTS"
        }
    }
}

extension MealDetailViewController: UITableViewDelegate {
    
}

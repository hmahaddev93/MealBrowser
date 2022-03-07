//
//  MealsViewController.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import UIKit

final class MealsViewController: UIViewController {

    private let viewModel: MealsViewModel
    private let mealsView = MealsView()
    
    private let alertPresenter: AlertPresenter_Proto = AlertPresenter()
    private let navPresenter: NavigationPresenter = NavigationPresenter()

    init(viewModel: MealsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mealsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.byCategory
        mealsView.collectionView.dataSource = self
        mealsView.collectionView.delegate = self
        loadMeals()
    }
    
    private func loadMeals() {
        showSpinner()
        viewModel.fetchMeals { [unowned self] result in
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
        mealsView.collectionView.reloadData()
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error.localizedDescription)",
                               dismissButtonTitle: "OK")
    }
    
    private func showSpinner() {
        mealsView.activityIndicatorView.startAnimating()
    }
    
    private func hideSpinner() {
        self.mealsView.activityIndicatorView.stopAnimating()
    }

}

extension MealsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath) as? MealCollectionCell {
            let mealSummary = viewModel.meals[indexPath.row]
            cell.meal = mealSummary

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
        let mealSelected = viewModel.meals[indexPath.row]
        self.navPresenter.navigateToMealDeail(mealId: mealSelected.id, from: self, animated: true)
    }
}

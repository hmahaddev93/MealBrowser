//
//  MealsViewModel.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import Foundation

class MealsViewModel {
    // MARK: - Initialization
    init(model: [MealSummary]? = nil, category: String) {
        if let inputModel = model {
            meals = inputModel
        }
        self.byCategory = category
    }
    var meals = [MealSummary]()
    var byCategory: String!
}

extension MealsViewModel {
    func fetchMeals(completion: @escaping (Result<[MealSummary], Error>) -> Void) {
        MealService().mealSummaryByCategory(category: byCategory) { [unowned self] result in
            switch result {
            case .success(let meals):
                self.meals = meals
                completion(.success(meals))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

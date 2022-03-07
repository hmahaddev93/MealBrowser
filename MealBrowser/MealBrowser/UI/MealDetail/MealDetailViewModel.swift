//
//  MealDetailViewModel.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import Foundation
import UIKit

class MealDetailViewModel {
    // MARK: - Initialization
    init(model: Meal? = nil, mealId: String) {
        if let inputModel = model {
            meal = inputModel
        }
        self.mealId = mealId
    }
    var meal: Meal?
    var mealId: String!
}

extension MealDetailViewModel {
    
    func fetchMeal(completion: @escaping (Result<Meal, Error>) -> Void) {
        MealService().mealBy(id: mealId) { [unowned self] result in
            switch result {
            case .success(let meals):
                guard let meal = meals.first else {
                    completion(.failure(MealServiceError.emptyMeal))
                    return
                }
                self.meal = meal
                completion(.success(meal))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getInstructionsCellHeight() -> CGFloat {
        guard let meal = self.meal,
              let instructions = meal.instructions
        else {
            return 0
        }
        
        let height = instructions.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 48 , font: UIFont.systemFont(ofSize: 14))
        if height < 28 {
            return 44
        }
        return height + 30
    }
}

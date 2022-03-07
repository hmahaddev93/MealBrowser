//
//  CategoryViewModel.swift
//  MealBrowser
//
//  Created by Khateeb H. on 3/4/22.
//

import Foundation

class CategoryViewModel {
    // MARK: - Initialization
    init(model: [MealCategory]? = nil) {
        if let inputModel = model {
            categories = inputModel
        }
    }
    var categories = [MealCategory]()
    let title = "Categories"
}

extension CategoryViewModel {
    func fetchCategories(completion: @escaping (Result<[MealCategory], Error>) -> Void) {
        MealService().categories() { [unowned self] result in
            switch result {
            case .success(let categories):
                self.categories = categories
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
